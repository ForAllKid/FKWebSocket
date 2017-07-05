//
//  FKIMClient.m
//  FKWebSocket
//
//  Created by 周宏辉 on 2017/7/5.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "FKIMClient.h"
#import "FKWebSocketDelegate.h"
#import "FKIMConfig.h"
#import "NSString+FKWebSocket.h"

@interface FKIMClient ()

@property (nonatomic, strong) SRWebSocket *webSocket;

@property (nonatomic, strong) FKWebSocketDelegate *socketDelegate;

@property (nonatomic, strong) FKIMConfig *config;

@property (nonatomic, readwrite) NSString *clientId;

@property (nonatomic) FKIMClientState state;
@end

@implementation FKIMClient

- (instancetype)initWithClientId:(NSString *)clientID{
    self = [super init];
    if (self) {
     
        _config = [FKIMConfig defaultConfig];
        if (!_config.webSocketURLString) {
            NSLog(@"websoc url is nil");
        }
        _clientID = clientID.copy;
        
        _state = FKIMClientStateNone;
        _socketDelegate = [[FKWebSocketDelegate alloc] init];
        NSURLRequest *request = [NSString webSocketServerURLString:_config.webSocketURLString port:_config.port];
        _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
        _webSocket.delegate = _socketDelegate;
    }
    return self;
}

- (void)openWithCallback:(FKWebSocketBooleanCallback)callback{
    if (self.state == FKIMClientStateNone || self.state == FKIMClientStateClosed) {
        
        if (_webSocket.readyState == SR_CLOSED) {
            
            NSURLRequest *request = [NSString webSocketServerURLString:_config.webSocketURLString port:_config.port];
            _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
            _webSocket.delegate = _socketDelegate;
            
        }else{
            
            _webSocket.delegate = nil;
            NSURLRequest *request = [NSString webSocketServerURLString:_config.webSocketURLString port:_config.port];
            _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
            _webSocket.delegate = _socketDelegate;
        }
        
        [self.webSocket open];
        
        callback = _socketDelegate.openCallback;
        [self handleCallback];
        
    }else{
        NSLog(@"已开启 等待自动重连");
    }
}


#pragma mark - private

- (void)handleCallback{
    _socketDelegate.receiveMessageCallback = ^(NSString *message, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }else{
            NSLog(@"%@", message);
        }
    };
}

//检查是否可以开启会话
- (void)checkOpenState{


}

@end
