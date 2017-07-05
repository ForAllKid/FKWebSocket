//
//  FKSocketClientConfig.h
//  FKSimpleSocketDemo
//
//  Created by 周宏辉 on 2017/6/19.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 最大重连次数
 */
FOUNDATION_EXPORT NSInteger const kDefaultMaxRetryCount;


@interface FKSocketClientConfig : NSObject<NSCopying>


/**
 尝试重连次数
 */
@property (nonatomic) NSInteger retryCount;


/**
 最大重连次数
 */
@property (nonatomic) NSInteger maxRetryCount;


/**
 重连间隔
 */
@property (nonatomic) NSTimeInterval retryTimeInterval;


/**
 发送ping的时间间隔 默认10s
 */
@property (nonatomic) NSTimeInterval pingTimeInterval;



/**
 默认配置

 @return 实例
 */
+ (FKSocketClientConfig *)defaultConfig;

@end

NS_ASSUME_NONNULL_END
