//
//  FKSocketClient.h
//  FKSimpleSocketDemo
//
//  Created by 周宏辉 on 2017/6/19.
//  Copyright © 2017年 ForKid. All rights reserved.

/**
 一个自动重连的客户端
 */

#import <Foundation/Foundation.h>
#import "FKSocketClientConfig.h"
#import "FKSocketSendMessage.h"
#import "FKSocketReceiveMessage.h"

@protocol FKSocketClientDelegate;

typedef NS_ENUM(NSUInteger, FKSocketClientStatus) {
    FKSocketClientStatusNone = 0,
    FKSocketClientStatusOpening,
    FKSocketClientStatusOpened,
    FKSocketClientStatusClosing,
    FKSocketClientStatusClosed,
    FKSocketClientStatusResuming,
    FKSocketClientStatusResumed
};



NS_ASSUME_NONNULL_BEGIN

/**
 接收到新的消息通知名字
 */
FOUNDATION_EXPORT NSString *const kFKSocketReceiveNewMessageNotificationNameKey;

/**
 接收到新的错误消息通知名字
 */
FOUNDATION_EXPORT NSString *const kFKSocketReceiveNewErrorMessageNotificationNameKey;


@interface FKSocketClient : NSObject


/**
 当前聊天会话中的另一个客户端ID
 */
@property (nullable, nonatomic, copy) NSString *targetClientID;


/**
 delegate
 */
@property (nullable, nonatomic, weak) id <FKSocketClientDelegate> delegate;


/**
 客户端ID
 */
@property (nullable, nonatomic, copy, readonly) NSString *clientID;

/**
 状态
 */
@property (nonatomic, readonly) FKSocketClientStatus status;


/**
 根据一个ID创建一个客户端 使用默认的配置

 @param clientID 客户端ID 不超过64个字符
 @return 实例对象
 */
- (instancetype)initWithClientID:(nullable NSString *)clientID;


/**
 根据id创建一个客户端  可以传入一个实例化的配置对象

 @param clientID 客户端ID
 @param config 配置
 @return 实例对象
 */
- (instancetype)initWithClientID:(nullable NSString *)clientID config:(nullable FKSocketClientConfig *)config;


/**
 通用单例对象

 @return 单例实例
 */
+ (FKSocketClient *)shareClient;

/**
 打开客户端
 */
- (void)open;


/**
 根据一个id创建一个客户端

 @param clientID 客户端ID
 */
- (void)openWithClientID:(nullable NSString *)clientID;

/**
 关闭客户端
 */
- (void)close;


/**
 发送消息

 @param message 消息实体
 */
- (void)sendMessage:(FKSocketSendMessage *)message;

@end

@protocol FKSocketClientDelegate <NSObject>

@required


/**
 接收到服务器返回的消息  包括没有找到目标  开柜失败等等
 
 @param client 客户端
 @param message 消息
 */
- (void)socketClient:(FKSocketClient *)client didReceiveErrorMessage:(FKSocketReceiveMessage *)message;

/**
 成功接收到另一个客户端返回的消息(非服务器发送的消息)
 
 @param client 客户端
 @param message 消息
 */
- (void)socketClient:(FKSocketClient *)client didReceiveMessage:(FKSocketReceiveMessage *)message;


@optional


/**
 接收到心跳包返回消息
 
 @param client 客户端
 @param pong 心跳包消息
 */
- (void)socketClient:(FKSocketClient *)client didReceivePong:(FKSocketReceiveMessage *)pong;


/**
 客户端已打开

 @param client 客户端
 */
- (void)socketClientDidOpen:(FKSocketClient *)client;


/**
 客户端关闭中

 @param client 客户端
 */
- (void)socketClientClosing:(FKSocketClient *)client;

/**
 客户端已关闭
 */
- (void)socketClientDidClose:(FKSocketClient *)client;



/**
 socket暂停断开连接触发

 @param client 客户端
 */
- (void)socketClientPaused:(FKSocketClient *)client;


/**
 客户端重连时触发
 
 @param client 客户端
 */
- (void)socketClientResuming:(FKSocketClient *)client;


/**
 客户端重连或者初次连接成功时触发

 @param client 客户端
 */
- (void)socketClientResumed:(FKSocketClient *)client;


@end

NS_ASSUME_NONNULL_END
