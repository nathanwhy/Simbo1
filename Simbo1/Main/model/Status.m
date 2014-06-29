//
//  Status.m
//  Simbo1
//
//  Created by NPHD on 14-5-15.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved
//

#import "Status.h"
#import "User.h"

@implementation Status
- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        
        self.picUrls = dict[@"pic_urls"];
        self.repostsCount = [dict[@"reposts_count"] intValue];
        self.commentsCount = [dict[@"comments_count"] intValue];
        self.attitudesCount = [dict[@"attitudes_count"] intValue];
        self.source = dict[@"source"];
        NSDictionary *retweet = dict[@"retweeted_status"];
        if (retweet) {
            self.retweetedStatus = [[Status alloc] initWithDict:retweet];
        }
        
        self.bmiddle_pic = dict[@"bmiddle_pic"];
        self.original_pic = dict[@"original_pic"];
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
