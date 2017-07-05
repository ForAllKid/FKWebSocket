//
//  FKWebSocketWrapper.m
//  FKWebSocket
//
//  Created by 周宏辉 on 2017/7/5.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "FKWebSocketDelegate.h"

@interface FKWebSocketDelegate ()

@end

@implementation FKWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    if (message == nil) {
        NSError *error = [NSError errorWithDomain:@"message nil error" code:1002 userInfo:nil];
        if (self.receiveMessageCallback) {
            self.receiveMessageCallback(nil, error);
        }
        return;
    }
    
    if ([message isKindOfClass:[NSString class]] == NO) {
        NSError *error = [NSError errorWithDomain:@"message type error" code:1001 userInfo:nil];
        if (self.receiveMessageCallback) {
            self.receiveMessageCallback(nil, error);
        }
    }
    NSString *messageString = (NSString *)message;
    
    if (self.receiveMessageCallback) {
        self.receiveMessageCallback(messageString, nil);
    }
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    if (self.openCallback) {
        self.openCallback(YES, nil);
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    if (self.openCallback) {
        self.openCallback(NO, error.copy);
    }
}


- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    if (self.closeCallback) {
        self.closeCallback(YES, nil);
    }
}


- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    
}

// Return YES to convert messages sent as Text to an NSString. Return NO to skip NSData -> NSString conversion for Text messages. Defaults to YES.
- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket{
    return YES;
}


@end
