//
//  FKBaseMessage.h
//  FKSimpleSocketDemo
//
//  Created by 周宏辉 on 2017/6/19.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FKMessageType) {
    //表示用户可以发送的消息
    FKMessageTypeHeartBeat = 0, //心跳包
    FKMessageTypeBackToMain,    //回到主页面
    FKMessageTypeBorrow   ,     //借阅
    FKMessageTypeShare,         //分享开柜
    FKMessageTypeScanningCode,  //开始扫描二维码
    
    //表示接受消息
    FKMessageTypeResData        //服务器返回消息
};

NS_ASSUME_NONNULL_BEGIN

@interface FKBaseMessage : NSObject


/**
 消息类型
 */
@property (nonatomic) FKMessageType messageType;

/**
 网络通信标识，用于判断指令的来源，柜子端和app发送的SocketFlag必须一样，否则柜子收到命令是不会做出相应操作
 */
@property (nullable, nonatomic, copy) NSString *socketFlag;


/**
 消息类型(服务器上的原样)
 */
@property (nullable, nonatomic, copy) NSString *messageTypeString;

/**
 消息接受者
 */
@property (nullable, nonatomic, copy) NSString *toUser;

/**
 消息发送者
 */
@property (nullable, nonatomic, copy) NSString *fromUser;

/**
 柜子锁板号
 */
@property (nonatomic) NSInteger boardID;

/**
 单个锁的编号
 */
@property (nonatomic) NSInteger lockID;


/**
 超时时长 这里要求必须为整数
 */
@property (nonatomic) NSInteger timeOut;

/**
 remark 扩展参数
 */
@property (nonatomic, copy) NSString *remark;


@end

NS_ASSUME_NONNULL_END
