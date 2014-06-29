//
//  BaseText.h
//  Simbo1
//
//  Created by NPHD on 14-5-25.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import <Foundation/Foundation.h>


@class User;
@interface BaseText : NSObject

@property (nonatomic, assign)long long ID;
@property (nonatomic, copy)NSString *createdAt;
@property (nonatomic, copy)NSString *text;
@property (nonatomic, strong)User *user;

- (id)initWithDict:(NSDictionary *)dict;
@end
