//
//  FKIMConfig.h
//  FKWebSocket
//
//  Created by 周宏辉 on 2017/7/5.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FKIMConfig : NSObject<NSCopying>


/**
 最大重连次数 默认5次，默认最大重连次数10次, 超过10次会提示已断开连接
 0表示无限重连
 */
@property (nonatomic) NSInteger maxReconnectCount;

/**
 重连时间间隔 默认3s 最小也是3s
 */
@property (nonatomic) NSTimeInterval reconnectTimeInterval;

/**
 发送心跳包的时间间隔 默认10s一次 最小也是10s
 */
@property (nonatomic) NSTimeInterval sendPingTimeInterval;

/**
 webSocket服务器地址
 */
@property (nonatomic, copy) NSString *webSocketURLString;

/**
 端口号
 */
@property (nonatomic, copy) NSString *port;



/**
 默认配置，不包括服务器地址和端口号

 @return 实例
 */
+ (FKIMConfig *)defaultConfig;

@end

NS_ASSUME_NONNULL_END
