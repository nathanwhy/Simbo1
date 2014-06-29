//
//  User.h
//  Simbo1
//
//  Created by NPHD on 14-5-15.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved
//  用户

#import <Foundation/Foundation.h>

typedef enum {
    kVerifiedTypeNone = - 1, // 没有认证
    kVerifiedTypePersonal = 0, // 个人认证
    kVerifiedTypeOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    kVerifiedTypeOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    kVerifiedTypeOrgWebsite = 5, // 网站官方：猫扑
    kVerifiedTypeDaren = 220 // 微博达人
} VerifiedType;

typedef enum {
    kMBTypeNone = 0, // 没有
    kMBTypeOne = 1,
    kMBTypeTwo = 2
} MBType;

@interface User : NSObject
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, assign) BOOL verified; //是否是微博认证用户，即加V用户
@property (nonatomic, assign) VerifiedType verifiedType; // 认证类型
@property (nonatomic, assign) int mbrank; // 会员等级
@property (nonatomic, assign) int mbtype; // 会员类型

//@property (nonatomic, copy) NSString *province;
//@property (nonatomic,copy) NSString *city;
- (id)initWithDict:(NSDictionary *)dict;
@end
