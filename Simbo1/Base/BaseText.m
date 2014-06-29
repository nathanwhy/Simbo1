//
//  BaseText.m
//  Simbo1
//
//  Created by NPHD on 14-5-25.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "BaseText.h"
#import "User.h"




@implementation BaseText



- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.ID = [dict[@"id"] longLongValue];
        self.text = dict[@"text"];
        self.user = [[User alloc] initWithDict:dict[@"user"]];
        self.createdAt = dict[@"created_at"];
    }
    return self;

}



- (NSString *)createdAt
{
    
    //时间格式：Fri May 16 21:08:03 +0800 2014
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    time.dateFormat = @"EEE MMM dd HH:mm:ss zzzz yyyy";
    time.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date = [time dateFromString:_createdAt];
    
    NSDate *now = [NSDate date];
    //求出时间差
    NSTimeInterval gap = [now timeIntervalSinceDate:date];
    
    if (gap < 60) {
        
        return @"刚刚";
        NSLog(@"----time---%@",[time stringFromDate:date]);
    }else if(gap < 60 * 60){
        return [NSString stringWithFormat:@"%.f分钟前", gap /60];
        
    }else if(gap < 60*60*24){
        return [NSString stringWithFormat:@"%.f小时前", gap / 60 / 60];
    }else{
        time.dateFormat =@"MM-dd HH:mm";
        return [time stringFromDate:date];
    }
    
    
}

@end
