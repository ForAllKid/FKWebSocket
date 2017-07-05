//
//  FKSocketSendMessage.h
//  FKSimpleSocketDemo
//
//  Created by 周宏辉 on 2017/6/19.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "FKBaseMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface FKSocketSendMessage : FKBaseMessage


/**
 发送的msg data
 */
@property (nullable, nonatomic, copy) NSString *sendMsgData;


/**
 将属性转换为指令
 */
- (nullable NSString *)formatToCommandJsonString;



@end

NS_ASSUME_NONNULL_END
