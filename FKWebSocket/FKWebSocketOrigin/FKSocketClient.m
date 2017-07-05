//
//  FKSocketClient.m
//  FKSimpleSocketDemo
//
//  Created by 周宏辉 on 2017/6/19.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "FKSocketClient.h"
#import <SRWebSocket.h>

NSString *const kFKSocketURLString = @"ws://47.93.254.46:9111";

#pragma mark - 通知名字

/**
 接收到新的消息通知名字
 */
NSString *const kFKSocketReceiveNewMessageNotificationNameKey = @"fk_socketReceiveNewMessageNotificationNameKey";

/**
 接收到新的错误消息通知名字
 */
NSString *const kFKSocketReceiveNewErrorMessageNotificationNameKey = @"fk_socketReceiveNewErrorMessageNotificationNameKey";


@interface FKSocketClient ()
<SRWebSocketDelegate>

{
    BOOL _isFirstInit, _needResponsePause;//是否需要响应断开方法
}

@property (nonatomic, strong) SRWebSocket *socket;

/**
 客户端ID
 */
@property (nonatomic, copy, readwrite) NSString *clientID;

/**
 状态
 */
@property (nonatomic, readwrite) FKSocketClientStatus status;

@property (nonatomic, weak) NSTimer *pingTimer;

@property (nonatomic, strong) FKSocketClientConfig *config;

@end

@implementation FKSocketClient

+ (FKSocketClient *)shareClient{
    static FKSocketClient *_client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _client = [[FKSocketClient alloc] init];
    });
    return _client;
}

- (instancetype)init{
    return [self initWithClientID:nil];
}

- (instancetype)initWithClientID:(NSString *)clientID{
    return [self initWithClientID:clientID config:[FKSocketClientConfig defaultConfig]];
}

- (instancetype)initWithClientID:(NSString *)clientID config:(FKSocketClientConfig *)config{
    self = [super init];
    if (self) {
    
        _isFirstInit = YES;
        _needResponsePause = YES;
        
        if (clientID) {
            _clientID = clientID.copy;
        }
        _status = FKSocketClientStatusNone;
        _config = config.copy;
        
        _pingTimer = [NSTimer scheduledTimerWithTimeInterval:config.pingTimeInterval
                                                      target:self
                                                    selector:@selector(sendPingMessage)
                                                    userInfo:nil
                                                     repeats:YES];
        
        _pingTimer.fireDate = [NSDate distantFuture];
    }
    return self;
}

#pragma mark - 公开方法



- (void)open{
    if (self.status != FKSocketClientStatusNone) {
        return;
    }
    
    [self.socket open];
    self.status = FKSocketClientStatusOpening;
    if (self.delegate && [self.delegate respondsToSelector:@selector(socketClientResuming:)]) {
        [self.delegate socketClientResuming:self];
    }
}

- (void)openWithClientID:(NSString *)clientID{
    self.clientID = clientID.copy;
    
    if (self.status != FKSocketClientStatusNone) {
        return;
    }
    
    [self.socket open];
    self.status = FKSocketClientStatusOpening;
    if (self.delegate && [self.delegate respondsToSelector:@selector(socketClientResuming:)]) {
        [self.delegate socketClientResuming:self];
    }
    
}

- (void)close{
    [self.socket close];
    [self reset];
    self.status = FKSocketClientStatusClosing;
    if (self.delegate && [self.delegate respondsToSelector:@selector(socketClientClosing:)]) {
        [self.delegate socketClientClosing:self];
    }
}

- (void)sendMessage:(FKSocketSendMessage *)message{
    if (self.socket.readyState != SR_OPEN) {
        return;
    }
    NSString *string = [message formatToCommandJsonString].copy;
    [self.socket send:string];
}

#pragma mark - 私有方法

- (void)startSendPing{
    self.pingTimer.fireDate = [NSDate distantPast];
}

- (void)stopSendPing{
    self.pingTimer.fireDate = [NSDate distantFuture];
}

- (void)sendPingMessage{
    if (self.socket.readyState != SR_OPEN) {
        return;
    }
    
    FKSocketSendMessage *pingMessage = [[FKSocketSendMessage alloc] init];
    pingMessage.messageType = FKMessageTypeHeartBeat;
    pingMessage.socketFlag = @"XYP";
    pingMessage.messageTypeString = @"HeartBeat";
    pingMessage.fromUser = self.clientID;
    pingMessage.toUser = @"Server";
    
    NSString *pingString = [pingMessage formatToCommandJsonString];
    [self.socket send:pingString];
}

- (void)reset{
    self.pingTimer.fireDate = [NSDate distantFuture];
    _socket = nil;
    _socket.delegate = nil;
}

#pragma mark - socket回调方法

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    if (![message isKindOfClass:[NSString class]]) {
        NSLog(@"非字符串格式");
        return;
    }
    
    NSString *messageString = (NSString *)message;
    
    NSData *messageStringData = [messageString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    id object = [NSJSONSerialization JSONObjectWithData:messageStringData options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    if (![object isKindOfClass:[NSDictionary class]]) {
        NSLog(@"类型不匹配");
        return;
    }
    
    NSDictionary *dict = (NSDictionary *)object;
    
    FKSocketReceiveMessage *receiveMessage = [[FKSocketReceiveMessage alloc] init];
    [receiveMessage bindValuesWithDict:dict];
    
    if (receiveMessage.fromServer == YES) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(socketClient:didReceiveErrorMessage:)]) {
            [self.delegate socketClient:self didReceiveErrorMessage:receiveMessage];
        }
        
        //发送通知消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kFKSocketReceiveNewErrorMessageNotificationNameKey object:receiveMessage];
        
        return;
    }
    
    if (receiveMessage.messageDataType == FKSocketMessageDataTypeHeartBeat) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(socketClient:didReceivePong:)]) {
            [self.delegate socketClient:self didReceivePong:receiveMessage];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(socketClient:didReceiveMessage:)]) {
        [self.delegate socketClient:self didReceiveMessage:receiveMessage];
    }
    
    //发送通知消息
    [[NSNotificationCenter defaultCenter] postNotificationName:kFKSocketReceiveNewMessageNotificationNameKey
                                                        object:receiveMessage];
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket{

    NSLog(@"did open");
    
    _isFirstInit = NO;
    
    self.config.retryCount = 0;
    self.status = FKSocketClientStatusResumed;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(socketClientResumed:)]) {
        [self.delegate socketClientResumed:self];
    }

    [self startSendPing];
    _needResponsePause = YES;
}


- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    NSLog(@"open fail");
    
    if (_isFirstInit) {
        NSLog(@"首次打开失败");
        _isFirstInit = NO;
    }else{
        if (_needResponsePause) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(socketClientPaused:)]) {
                [self.delegate socketClientPaused:self];
            }
            _needResponsePause = NO;
        }
    }
    
    if (self.config.retryCount > self.config.maxRetryCount) {
        NSLog(@"达到最大重连次数");
        return;
    }
    
    [self reset];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.config.retryTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.config.retryCount += 1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(socketClientResuming:)]) {
            [self.delegate socketClientResuming:self];
        }
        [self.socket open];
    });
    
}


- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    NSLog(@"did closed");

    self.config.retryCount = 0;
    [self stopSendPing];
    self.status = FKSocketClientStatusClosed;
    if (self.delegate && [self.delegate respondsToSelector:@selector(socketClientDidClose:)]) {
        [self.delegate socketClientDidClose:self];
    }
    self.status = FKSocketClientStatusNone;
}


- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSLog(@"pong   pong   pong  pong  pong !!!");
}


- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket{
    return YES;
}

#pragma mark - getter

- (SRWebSocket *)socket{
    if (!_socket) {
        NSURL *url = [NSURL URLWithString:kFKSocketURLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        _socket = [[SRWebSocket alloc] initWithURLRequest:request];
        _socket.delegate = self;
    }
    return _socket;
}

- (NSString *)clientID{
    return _clientID;
}

- (FKSocketClientStatus)status{
    return _status;
}

- (void)setTargetClientID:(NSString *)targetClientID{
    _targetClientID = targetClientID;
}



@end

