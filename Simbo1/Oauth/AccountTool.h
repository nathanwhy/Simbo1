//
//  AccountTool.h
//  Simbo1
//
//  Created by NPHD on 14-5-12.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//  管理账号信息

#import <Foundation/Foundation.h>
#import "Account.h"

#define kAppKey @"3532824886"
#define kAppSecret @"4b8d31de2251de16d1c07d3c38a0abc8"
#define kRedirect_uri @"https://api.weibo.com/oauth2/default.html"//回调地址
#define kBaseURL @"https://api.weibo.com"
#define kAuthorizeURL [kBaseURL stringByAppendingPathComponent:@"oauth2/authorize"]

@class Account;
@interface AccountTool : NSObject
+ (AccountTool *)shareAccountTool;

- (void)saveAccount:(Account *)account;
@property (nonatomic, readonly) Account *account;
@end