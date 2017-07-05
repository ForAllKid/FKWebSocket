//
//  ViewController.m
//  FKWebSocket
//
//  Created by 周宏辉 on 2017/7/5.
//  Copyright © 2017年 ForKid. All rights reserved.
//

#import "ViewController.h"
#import "FKWebSocketHeader.h"
#import "FKIMClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FKIMClient *client = [[FKIMClient alloc] initWithClientId:@"FOrKid"];
    
    [client openWithCallback:^(BOOL successed, NSError *error) {
        NSLog(@"open %@", successed ? @"YES" : @"NO");
    }];
    
}




@end
