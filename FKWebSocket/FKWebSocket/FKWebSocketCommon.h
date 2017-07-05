//
//  FKWebSocketCommon.h
//  FKWebSocket
//
//  Created by 周宏辉 on 2017/7/5.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#ifndef FKWebSocketCommon_h
#define FKWebSocketCommon_h

typedef void(^FKWebSocketBooleanCallback)(BOOL successed, NSError *error);

typedef void(^FKWebSocketMessageCallback)(NSString *message, NSError *error);

#endif /* FKWebSocketCommon_h */
