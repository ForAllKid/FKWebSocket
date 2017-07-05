//
//  FKSocketSendMessage.m
//  FKSimpleSocketDemo
//
//  Created by 周宏辉 on 2017/6/19.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "FKSocketSendMessage.h"

@implementation FKSocketSendMessage

- (NSString *)formatToCommandJsonString{
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setObject:self.socketFlag  forKey:@"SocketFlag"];
    [jsonDict setObject:self.fromUser    forKey:@"FromUser"];
    [jsonDict setObject:self.toUser      forKey:@"ToUser"];
    [jsonDict setObject:@(self.boardID)  forKey:@"BoardID"];
    [jsonDict setObject:@(self.lockID)   forKey:@"LockID"];
    [jsonDict setObject:@(self.timeOut)  forKey:@"TimeOut"];
    [jsonDict setObject:self.messageTypeString forKey:@"MsgType"];
    
    if (self.sendMsgData) {
        [jsonDict setObject:self.sendMsgData forKey:@"MsgData"];
    }
    
    //转换为json格式
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)description{
    NSString *string = [NSString stringWithFormat:@"\n------\n 类属性信息 :\n 消息类型:%ld\n标识符:%@\n类型说明:%@\n发送者:%@\n接受者:%@\n柜子编号:%ld\n锁编号:%ld\n超时时长:%ld\n------\n", self.messageType, self.socketFlag, self.messageTypeString, self.fromUser, self.toUser, self.boardID, self.lockID, self.timeOut];
    return string;
}


@end
