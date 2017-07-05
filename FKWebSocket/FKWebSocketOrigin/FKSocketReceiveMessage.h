//
//  FKSocketReceiveMessage.h
//  FKSimpleSocketDemo
//
//  Created by 周宏辉 on 2017/6/19.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "FKBaseMessage.h"

typedef NS_ENUM(NSUInteger, FKSocketMessageDataType) {
    FKSocketMessageDataTypeNoTarget = 0,  //未连接服务器
    FKSocketMessageDataTypeFail,          //连接到了服务器 但是门没有开
    FKSocketMessageDataTypeSuccess,       //成功开门
    FKSocketMessageDataTypeHeartBeat,     //接收到心跳包
    FKSocketMessageDataTypeCloseBlock,    //接受到关门指令
    FKSocketMessageDataTypeInOperation,   //连接了服务器 但是有其他人在操作
    FKSocketMessageDataTypeNone           //未知
};


NS_ASSUME_NONNULL_BEGIN

@interface FKSocketReceiveMessage : FKBaseMessage

/**
 msg data string
 */
@property (nullable, nonatomic, copy) NSString *messageDataString;


/**
 msg data
 */
@property (nonatomic) FKSocketMessageDataType messageDataType;


/**
 msg data description(chinese)
 */
@property (nullable, nonatomic, copy) NSString *messageDataDescription;


/**
 是否是来自服务器的消息(排除心跳包)
 */
@property (nonatomic) BOOL fromServer;

/**
 赋值
 
 @param dict 数据源
 */
- (void)bindValuesWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
