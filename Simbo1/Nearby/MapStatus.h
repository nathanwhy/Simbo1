//
//  MapStatus.h
//  Simbo1
//
//  Created by NPHD on 14-6-26.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
// 附近发微博的人

#import "Status.h"
#import "User.h"
#import <MapKit/MapKit.h>

@class Status;
@interface MapStatus : User

@property (nonatomic, assign)long long ID;
@property (nonatomic, copy)NSString *createdAt;
@property (nonatomic, copy)NSString *text;;

//@property (nonatomic, assign) int repostsCount; // 转发数
//@property (nonatomic, assign) int commentsCount; // 评论数
//@property (nonatomic, assign) int attitudesCount; // 表态数(被赞)
@property (nonatomic, copy) NSString *source; // 微博来源


@property (nonatomic, assign) float latitude;//经纬度
@property (nonatomic, assign) float longitude;

- (id)initWithDict:(NSDictionary *)dict;
@end
