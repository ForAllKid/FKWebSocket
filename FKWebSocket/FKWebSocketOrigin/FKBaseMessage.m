//
//  FKBaseMessage.m
//  FKSimpleSocketDemo
//
//  Created by 周宏辉 on 2017/6/19.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "FKBaseMessage.h"

@implementation FKBaseMessage

- (instancetype)init{
    self = [super init];
    if (self) {
        _messageType = FKMessageTypeHeartBeat;
        //还是初始化一下参数  不然要崩
        _socketFlag  = @"1";
        _fromUser    = @"1";
        _toUser      = @"1";
        _messageTypeString = [self messageTypeStringWithType:_messageType].copy;
        
        _boardID     = 0;
        _lockID      = 0;
        _timeOut     = 0;
    }
    return self;
}

- (void)setMessageType:(FKMessageType)messageType{
    _messageType = messageType;
    self.messageTypeString = [self messageTypeStringWithType:messageType];
}

- (NSString *)messageTypeStringWithType:(FKMessageType)type{
    NSString *string = nil;
    switch (type) {
        case FKMessageTypeHeartBeat:
            string = @"HeartBeat";
            break;
        case FKMessageTypeScanningCode:
            string = @"SCAN_CODE";
            break;
        case FKMessageTypeShare:
            string = @"SHARE_OPEN_BLOCK";
            break;
        case FKMessageTypeBorrow:
            string = @"BORROW_OPEN_BLOCK";
            break;
        case FKMessageTypeResData:
            string = @"ResData";
            break;
        case FKMessageTypeBackToMain:
            string = @"BACK_TO_MAIN";
            break;
    }
    
    return string;
}



@end
