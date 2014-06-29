//
//  MapStatus.m
//  Simbo1
//
//  Created by NPHD on 14-6-26.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "MapStatus.h"


@implementation MapStatus

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        self.ID = [dict[@"id"] longLongValue];
        self.text = dict[@"status"][@"text"];
        self.createdAt = dict[@"status"][@"created_at"];
//        self.repostsCount = [dict[@"status"][@"reposts_count"] intValue];
//        self.commentsCount = [dict[@"status"][@"comments_count"] intValue];
//        self.attitudesCount = [dict[@"status"][@"attitudes_count"] intValue];
        self.source = dict[@"status"][@"source"];
        
        self.latitude = [dict[@"lat"] floatValue];
        self.longitude = [dict[@"lon"] floatValue];
    }
    return self;
    
}




//微博来源
- (void)setSource:(NSString *)source
{
    
    // <a href="http://app.weibo.com/t/feed/2qiXeb" rel="nofollow">皮皮时光机</a>
    
    NSUInteger begin = [source rangeOfString:@">"].location + 1;
    NSUInteger end = [source rangeOfString:@"</"].location;
    
    _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:NSMakeRange(begin, end - begin)]];
}
@end
