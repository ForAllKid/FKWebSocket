//
//  FKSocketReceiveMessage.m
//  FKSimpleSocketDemo
//
//  Created by 周宏辉 on 2017/6/19.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "FKSocketReceiveMessage.h"

@implementation FKSocketReceiveMessage


- (void)setMessageDataString:(NSString *)messageDataString{
    _messageDataString = messageDataString.copy;
    
    if ([messageDataString isEqualToString:@"OPEN_BLOCK_OK"]) {
        _messageDataType = FKSocketMessageDataTypeSuccess;
        _messageDataDescription = @"开柜成功";
    }
    
    else if ([messageDataString isEqualToString:@"NO_TARGET"]){
        _messageDataType = FKSocketMessageDataTypeNoTarget;
        _messageDataDescription = @"很抱歉，连接书柜服务器失败";
    }
    
    else if ([messageDataString isEqualToString:@"OPEN_BLOCK_FAIL"]){
        if (!self.remark) {
            _messageDataType = FKSocketMessageDataTypeFail;
            _messageDataDescription = @"很抱歉，开柜失败";
        }else{
            _messageDataType = FKSocketMessageDataTypeInOperation;
            _messageDataDescription = @"他人正在操作中，请稍等";
        }
        
    }
    
    else if ([messageDataString isEqualToString:@"RECEIVE_HEART_BEAT_OK"]){
        _messageDataType = FKSocketMessageDataTypeHeartBeat;
        _messageDataDescription = @"接收到心跳包";
    }
    
    else if ([messageDataString isEqualToString:@"CLOSE_BLOCK_OK"]){
        _messageDataType = FKSocketMessageDataTypeCloseBlock;
        _messageDataDescription = @"关门成功";
    }
    
    else{
        _messageDataType = FKSocketMessageDataTypeNone;
        _messageDataDescription = @"未知原因";
    }
}


- (void)bindValuesWithDict:(NSDictionary *)dict{
    if (!dict) {
        return;
    }
    self.socketFlag  = dict[@"SocketFlag"];
    self.fromUser    = dict[@"FromUser"];
    self.toUser      = dict[@"ToUser"];
    self.boardID     = [dict[@"BoardID"] integerValue];
    self.lockID      = [dict[@"LockID"] integerValue];
    self.timeOut     = [dict[@"TimeOut"] integerValue];
    self.remark      = dict[@"Remark"];
    self.messageDataString = dict[@"MsgData"];
    
    if (self.messageDataType == FKSocketMessageDataTypeHeartBeat ||
        self.messageDataType == FKSocketMessageDataTypeSuccess ||
        self.messageDataType == FKSocketMessageDataTypeCloseBlock) {
        
        self.fromServer = NO;
        
    }else{
        self.fromServer = YES;
    }
}


- (NSString *)description{
    
    NSString *string = [NSString stringWithFormat:@"\n------\n 类属性信息 :\n消息类型:%ld\n标识符:%@\n类型说明:%@\n发送者:%@\n接受者:%@\n柜子编号:%ld\n锁编号:%ld\n超时时长:%ld\n------\n返回的消息类型:%ld\n返回的消息:%@\n返回的说明:%@", self.messageType, self.socketFlag, self.messageTypeString, self.fromUser, self.toUser, self.boardID, self.lockID, self.timeOut, self.messageDataType, self.messageTypeString, self.messageDataDescription];
    
    return string;
}


@end
