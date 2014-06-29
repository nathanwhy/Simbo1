//
//  StatusDetailCell.m
//  Simbo1
//
//  Created by NPHD on 14-5-24.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "StatusDetailCell.h"
#import "StatusCell.h"
#import "DetailViewController.h"
@implementation StatusDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 1.监听被转发微博的点击
        [_retweeted addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRetweeted)]];
        
        
    }
    return self;
}


- (void)showRetweeted
{
    
    [self.delegate statuesDetailCellPushToRetweet:self];
}







//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
