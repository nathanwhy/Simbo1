//
//  StatusTool.m
//  Simbo1
//
//  Created by NPHD on 14-5-15.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved
//

#import "StatusTool.h"
#import "HttpTool.h"
#import "AccountTool.h"
#import "Status.h"
#import "User.h"
#import "Comment.h"
#import "BaseText.h"
@implementation StatusTool

#pragma mark - 获取微博数据
+ (void)statusesWithSinceID:(long long)sinceID maxId:(long long)maxID Success:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure
{
    [HttpTool getWithpath:@"2/statuses/home_timeline.json" params:@{
                                                                    @"count" : @30,
                                                                    @"since_id" :@(sinceID),
                                                                    @"max_id":@(maxID)
                                                                    
                                                                    }success:^(id JSON) {
        if (success == nil) return;
         NSMutableArray *statuses = [NSMutableArray array];
        
        // 解析json对象
         NSArray *array = JSON[@"statuses"];
         for (NSDictionary *dict in array) {
             Status *s = [[Status alloc] initWithDict:dict];
             [statuses addObject:s];
             
         }
         // 回调block
         success(statuses);
     } failure:^(NSError *error) {
         if (failure == nil) return;
         
         NSLog(@"失败");
         
         failure(error);
     }];
}

#pragma mark -抓取某条微博的评论数据
+ (void)commentsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(CommentsSuccessBlock)success failure:(CommentsFailureBlock)failure
{
    [HttpTool getWithpath:@"2/comments/show.json" params:@{
                                                           @"id" : @(statusId),
                                                           @"since_id" : @(sinceId),
                                                           @"max_id" : @(maxId),
                                                           @"count" : @20
                                                           }
        success:^(id JSON) {
                 if (success == nil) return;
                                                               
                 // JSON数组（装着所有的评论）
                 NSArray *array = JSON[@"comments"];
                 NSMutableArray *comments = [NSMutableArray array];
                                                               
                 for (NSDictionary *dict in array) {
                        Comment *c = [[Comment alloc] initWithDict:dict];
                        [comments addObject:c];
                 }
            
                 success(comments, [JSON[@"total_number"] intValue], [JSON[@"next_cursor"] longLongValue]);
                                                               
         } failure:^(NSError *error) {
                 if (failure == nil) return;
                                                               
                 failure(error);
         }];
}


#pragma mark - 抓取某条微博的转发数据
+ (void)repostsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(RepostsSuccessBlock)success failure:(RepostsFailureBlock)failure
{
    [HttpTool getWithpath:@"2/statuses/repost_timeline.json" params:@{
                                                                      @"id" : @(statusId),
                                                                      @"since_id" : @(sinceId),
                                                                      @"max_id" : @(maxId),
                                                                      @"count" : @20
                                                                      }
                  success:^(id JSON) {
                      if (success == nil) return;
                      NSArray *array = JSON[@"reposts"];
                      NSMutableArray *reposts = [NSMutableArray array];
                      
                      for (NSDictionary *dict in array) {
                          BaseText *r = [[BaseText alloc] initWithDict:dict];
                          
                          [reposts addObject:r];}
                                                                          
                   success(reposts, [JSON[@"total_number"] intValue], [JSON[@"next_cursor"] longLongValue]);
                                                                      }
                  failure:^(NSError *error) {
                         if (failure == nil) return;
                                                                          
                           failure(error);}];
}



#pragma mark - 获取附近的微博
+ (void)statusesWithCoordinate:(CLLocationCoordinate2D)coordinate Success:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure
{
    NSDictionary *dic = @{@"lat": @(coordinate.latitude),
                          @"long":@(coordinate.longitude)};
    [HttpTool getWithpath:@"2/place/nearby/photos.json" params:dic success:^(id JSON) {
//        if (success == nil) return;
//        NSMutableArray *statuses = [NSMutableArray array];
//        
//        // 解析json对象
//        NSArray *array = JSON[@"statuses"];
//        for (NSDictionary *dict in array) {
//            Status *s = [[Status alloc] initWithDict:dict];
//            [statuses addObject:s];
//            
//        }
//        // 回调block
        NSLog(@"--成功-%@",JSON);
//        success(statuses);
        
    } failure:^(NSError *error) {
        NSLog(@"加载失败 - %@",error);
    }];
}













@end
