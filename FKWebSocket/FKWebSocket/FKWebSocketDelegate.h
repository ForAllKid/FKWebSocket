//
//  FKWebSocketWrapper.h
//  FKWebSocket
//
//  Created by 周宏辉 on 2017/7/5.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKWebSocketCommon.h"
#import <SRWebSocket.h>


NS_ASSUME_NONNULL_BEGIN

@interface FKWebSocketDelegate : NSObject
<SRWebSocketDelegate>


/**
 openCallback
 */
@property (nullable, nonatomic, copy) FKWebSocketBooleanCallback openCallback;


/**
 close callback
 */
@property (nullable, nonatomic, copy) FKWebSocketBooleanCallback closeCallback;

/**
 create conversation callback
 */
@property (nullable, nonatomic, copy) FKWebSocketBooleanCallback createConversationCallback;


/**
 send message callback
 */
@property (nullable, nonatomic, copy) FKWebSocketBooleanCallback sendMessageCallback;


/**
 received message callback
 */
@property (nullable, nonatomic, copy) FKWebSocketMessageCallback receiveMessageCallback;



@end

NS_ASSUME_NONNULL_END
