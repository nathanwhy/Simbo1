//
//  Status.h
//  Simbo1
//
//  Created by NPHD on 14-5-15.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved
//  微博

#import "BaseText.h"
//@class User;
@interface Status : BaseText

@property (nonatomic, strong) NSArray *picUrls; // 微博配图
@property (nonatomic, strong) Status *retweetedStatus; // 被转发的微博

@property (nonatomic, assign) int repostsCount; // 转发数
@property (nonatomic, assign) int commentsCount; // 评论数
@property (nonatomic, assign) int attitudesCount; // 表态数(被赞)
@property (nonatomic, copy) NSString *source; // 微博来源

//目前只有一张大图
@property (nonatomic, copy) NSString *bmiddle_pic;//中图
@property (nonatomic, copy) NSString *original_pic;//大图
@end