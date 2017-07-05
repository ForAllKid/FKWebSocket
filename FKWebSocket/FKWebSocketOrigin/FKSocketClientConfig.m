//
//  FKSocketClientConfig.m
//  FKSimpleSocketDemo
//
//  Created by 周宏辉 on 2017/6/19.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "FKSocketClientConfig.h"

NSInteger const kDefaultMaxRetryCount = 10;

@implementation FKSocketClientConfig

- (instancetype)init{
    self = [super init];
    if (self) {
        _retryCount = 0;
        _maxRetryCount = 10;
        _retryTimeInterval = 3.f;
        _pingTimeInterval = 10.f;
    }
    return self;
}

+ (FKSocketClientConfig *)defaultConfig{
    static FKSocketClientConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

- (id)copyWithZone:(NSZone *)zone{
    FKSocketClientConfig *config = [[FKSocketClientConfig alloc] init];
    config.retryCount = self.retryCount;
    config.maxRetryCount = self.maxRetryCount;
    config.retryTimeInterval = self.retryTimeInterval;
    config.pingTimeInterval = self.pingTimeInterval;
    return config;
}

@end

