//
//  FKIMClient.h
//  FKWebSocket
//
//  Created by 周宏辉 on 2017/7/5.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKWebSocketCommon.h"

@protocol FKIMClientDelegate;
@class FKIMSendMessage, FKIMReceiveMessage, FKIMErrorMessage;

typedef NS_ENUM(NSUInteger, FKIMClientState) {
    FKIMClientStateNone = 0, //初始状态
    FKIMClientStateOpening,
    FKIMClientStateOpened,
    FKIMClientStateClosing,
    FKIMClientStateClosed,
    FKIMClientStateResuming,
    FKIMClientStateResumed
};

NS_ASSUME_NONNULL_BEGIN

@interface FKIMClient : NSObject


/**
 delegate
 */
@property (nullable, nonatomic, weak) id <FKIMClientDelegate> delegate;


/**
 client id
 */
@property (nullable, nonatomic, copy, readonly) NSString *clientID;

/**
 state
 */
@property (nonatomic, readonly) FKIMClientState state;


/**
 初始化方法

 @param clientID 客户端ID
 @return 实例
 */
- (instancetype)initWithClientId:(NSString *)clientID;

/**
 开启客户端 建立链接

 @param callback 回调
 */
- (void)openWithCallback:(FKWebSocketBooleanCallback)callback;


/**
 关闭客户端 断开连接

 @param callback 回调
 */
- (void)closeWithCallback:(FKWebSocketBooleanCallback)callback;


/**
 发送消息

 @param message 发送的消息实体
 @param callback 回调
 */
- (void)sendMessage:(FKIMSendMessage *)message callback:(FKWebSocketBooleanCallback)callback;

@end

@protocol FKIMClientDelegate <NSObject>

@optional

#pragma mark - message

- (void)imClient:(FKIMClient *)client didReceivedMessage:(FKIMReceiveMessage *)message;

- (void)imClient:(FKIMClient *)client didReceivedErrorMessage:(FKIMReceiveMessage *)errorMessage;

- (void)imClient:(FKIMClient *)client didReceivedPongMessage:(FKIMReceiveMessage *)pongMessage;

- (void)imClient:(FKIMClient *)client timeoutSendMessage:(FKIMSendMessage *)message;

#pragma mark - state

- (void)imClientDidOpen:(FKIMClient *)imClient;

- (void)imClientDidClose:(FKIMClient *)imClient;


- (void)imClientResuming:(FKIMClient *)imClient;

- (void)imClientResumed:(FKIMClient *)imClient;

- (void)imClientPaused:(FKIMClient *)imClient;

//- (void)imClientPaused:(FKIMClient *)imClient reason:(NSString *)reason code:(NSInteger)code;


@end

NS_ASSUME_NONNULL_END
