//
//  StatusTool.h
//  Simbo1
//
//  Created by NPHD on 14-5-15.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);

typedef void (^CommentsSuccessBlock)(NSArray *comments, int totalNumber, long long nextCursor);
typedef void (^CommentsFailureBlock)(NSError *error);

typedef void (^RepostsSuccessBlock)(NSArray *reposts, int totoalNumber, long long nextCursor);
typedef void (^RepostsFailureBlock)(NSError *error);

@interface StatusTool : NSObject

//获取微博数据
+ (void)statusesWithSinceID:(long long)sinceID maxId:(long long)maxId Success:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure;

// 抓取某条微博的评论数据
+ (void)commentsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(CommentsSuccessBlock)success failure:(CommentsFailureBlock)failure;

// 抓取某条微博的转发数据
+ (void)repostsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(RepostsSuccessBlock)success failure:(RepostsFailureBlock)failure;


//获取附近的微博
+ (void)statusesWithCoordinate:(CLLocationCoordinate2D)coordinate Success:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure;
@end
