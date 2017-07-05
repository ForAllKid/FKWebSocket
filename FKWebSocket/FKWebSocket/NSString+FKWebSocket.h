//
//  NSString+FKWebSocket.h
//  FKWebSocket
//
//  Created by 周宏辉 on 2017/7/5.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FKWebSocket)

+ (NSURLRequest *)webSocketServerURLString:(NSString *)urlString port:(NSString *)port;


@end
