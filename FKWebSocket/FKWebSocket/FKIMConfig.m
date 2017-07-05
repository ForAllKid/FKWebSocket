//
//  FKIMConfig.m
//  FKWebSocket
//
//  Created by 周宏辉 on 2017/7/5.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "FKIMConfig.h"

@interface FKIMConfig ()

@end

@implementation FKIMConfig

#pragma mark - life cycle

- (instancetype)init{
    self = [super init];
    if (self) {
        _maxReconnectCount = 5;
        _reconnectTimeInterval = 3.0f;
        _sendPingTimeInterval = 10.0f;
    }
    return self;
}


+ (FKIMConfig *)defaultConfig{
    static FKIMConfig *_config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [[self alloc] init];
    });
    return _config;
}

#pragma mark - setter

- (void)setMaxReconnectCount:(NSInteger)maxReconnectCount{
    if (maxReconnectCount > 10) {
        maxReconnectCount = 10;
    }
    _maxReconnectCount = maxReconnectCount;
}

- (void)setReconnectTimeInterval:(NSTimeInterval)reconnectTimeInterval{
    if (reconnectTimeInterval < 3.0f) {
        reconnectTimeInterval = 3.0f;
    }
    _reconnectTimeInterval = reconnectTimeInterval;
}

#pragma mark - copying

- (id)copyWithZone:(NSZone *)zone{
    
    FKIMConfig *config = [[FKIMConfig alloc] init];
    config.maxReconnectCount = self.maxReconnectCount;
    config.reconnectTimeInterval = self.reconnectTimeInterval;
    config.sendPingTimeInterval = self.sendPingTimeInterval;
    config.webSocketURLString = self.webSocketURLString.copy;
    config.port = self.port.copy;
    
    return config;
}

@end
