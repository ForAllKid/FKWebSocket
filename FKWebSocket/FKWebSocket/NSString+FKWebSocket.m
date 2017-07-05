//
//  NSString+FKWebSocket.m
//  FKWebSocket
//
//  Created by 周宏辉 on 2017/7/5.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "NSString+FKWebSocket.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSString (FKWebSocket)

+ (NSURLRequest *)webSocketServerURLString:(NSString *)urlString port:(NSString *)port{
    NSString *string = [NSString stringWithFormat:@"%@:%@", urlString, port];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}

@end

NS_ASSUME_NONNULL_END
