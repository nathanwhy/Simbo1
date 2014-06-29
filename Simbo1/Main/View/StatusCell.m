//
//  StatusCell.m
//  Simbo1
//
//  Created by NPHD on 14-5-13.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "StatusCell.h"
#import "Status.h"
#import "StatusCellFrame.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "ImageListView.h"
#import "HeadImage.h"



@implementation StatusCell
{
    HeadImage *_icon; // 头像
    UILabel *_screenName; // 昵称
    UIImageView *_mbIcon; // 会员图标
    UILabel *_time; // 时间
    UILabel *_source; // 来源
    UILabel *_text; // 内容
    //ImageListView *_listView;
    UILabel *_retweetedScreenName; // 被转发微博作者的昵称
    UILabel *_retweetedText; // 被转发微博的内容
    ImageListView *_retweetedImage; // 被转发微博的配图
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //增加微博子视图和被转发视图
        [self addAllSubviews];
        [self addReweetedAllSubviews];
        
        
    }
    return self;
}


#pragma mark 增加微博子视图
- (void)addAllSubviews
{
    //1.头像
    _icon = [[HeadImage alloc] init];
    [self.contentView addSubview:_icon];
    
    //2.昵称
    _screenName = [[UILabel alloc] init];
    _screenName.font = kScreenNameFont;
    _screenName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_screenName];
    
    // 皇冠图标
    _mbIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_membership.png"]];
    [self.contentView addSubview:_mbIcon];
    
    //3.时间
    _time = [[UILabel alloc] init];
    _time.font = kTimeFont;
    _time.textColor = kMBScreenNameColor;
    _time.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_time];
    
    //4.来源
    _source = [[UILabel alloc] init];
    _source.font = kSourceFont;
    _source.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_source];
    
    //5.内容
    _text = [[UILabel alloc] init];
    _text.font = kTextFont;
    _text.numberOfLines = 0;
    _text.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_text];
    
    //6.配图
    _listView = [[ImageListView alloc] init];
    
    [self.contentView addSubview:_listView];
    
}


#pragma mark  被转发视图
- (void)addReweetedAllSubviews
{
    // 1.被转发微博的父控件
    _retweeted = [[UIImageView alloc] init];
    _retweeted.backgroundColor = kGlobalBg;
    _retweeted.userInteractionEnabled = YES;
    [self.contentView addSubview:_retweeted];
    
    // 2.被转发微博的昵称
    _retweetedScreenName = [[UILabel alloc] init];
    _retweetedScreenName.font = kRetweetedScreenNameFont;
    _retweetedScreenName.textColor = kRetweetedScreenNameColor;
    _retweetedScreenName.backgroundColor = [UIColor clearColor];
    [_retweeted addSubview:_retweetedScreenName];
    
    // 3.被转发微博的内容
    _retweetedText = [[UILabel alloc] init];
    _retweetedText.numberOfLines = 0;
    _retweetedText.font = kRetweetedTextFont;
    _retweetedText.backgroundColor = [UIColor clearColor];
    [_retweeted addSubview:_retweetedText];
    
    // 4.被转发微博的配图
    _retweetedImage = [[ImageListView alloc] init];
    [_retweeted addSubview:_retweetedImage];
}


- (void)setStatusCellFrame:(StatusCellFrame *)statusCellFrame
{
    _statusCellFrame = statusCellFrame;
    
    Status *s = statusCellFrame.status;
    
    // 1.头像
    _icon.frame = statusCellFrame.iconFrame;
    [_icon setUser:s.user type:kIconTypeSmall];
    
    
    // 2.昵称
    _screenName.frame = statusCellFrame.screenNameFrame;
    _screenName.text = s.user.screenName;
    // 判断是不是会员
    if (!(s.user.mbtype < 3)) {
        _screenName.textColor = kScreenNameColor;
        _mbIcon.hidden = YES;
    } else {
        _screenName.textColor = kMBScreenNameColor;
        _mbIcon.hidden = NO;
        _mbIcon.frame = statusCellFrame.mbIconFrame;
    }
    
    // 3.时间
    _time.text = s.createdAt;
    CGFloat timeX = statusCellFrame.screenNameFrame.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusCellFrame.screenNameFrame) + kCellBorderWidth;
    CGSize timeSize = [StatusCellFrame sizeWithText:_time.text font:kTimeFont contentSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _time.frame = (CGRect){{timeX, timeY}, timeSize};
    
    // 4.来源
    _source.text = s.source;
    CGFloat sourceX = CGRectGetMaxX(_time.frame) + kCellBorderWidth;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [StatusCellFrame sizeWithText:_source.text font:kSourceFont contentSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _source.frame = (CGRect) {{sourceX, sourceY}, sourceSize};
    
    // 5.内容
    
    _text.text = s.text;
    _text.frame = statusCellFrame.textFrame;
    // 6.配图
    if (s.picUrls.count) {
        _listView.hidden = NO;
        _listView.frame = statusCellFrame.imageFrame;
        _listView.imageUrls = s.picUrls;
        
    }else{
        _listView.hidden = YES;
    }
    
    //7.转发的微博
    if (s.retweetedStatus) {
        _retweeted.hidden = NO;
        _retweeted.frame = statusCellFrame.retweetedFrame;
        
        
        //7.1转发者名称
        _retweetedScreenName.frame = statusCellFrame.retweetedScreenNameFrame;
        _retweetedScreenName.text = [NSString stringWithFormat:@"@%@",s.retweetedStatus.user.screenName];
        
        
        
        //7.2转发内容
        _retweetedText.frame = statusCellFrame.retweetedTextFrame;
        NSString *lastText = [NSString stringWithFormat:@"转发(%d) 评论(%d)",s.retweetedStatus.repostsCount,s.retweetedStatus.commentsCount];
        
        
        NSString *alltext = [NSString stringWithFormat:@"%@\n%@",s.retweetedStatus.text,lastText];
        
        _retweetedText.text = alltext;
        
        //NSLog(@"--text--%@",NSStringFromCGRect(_retweetedText.frame));
        
        //7.3配图
        if (s.retweetedStatus.picUrls.count) {
            _retweetedImage.hidden = NO;
            
            _retweetedImage.frame = statusCellFrame.retweetedImageFrame;
            
            _retweetedImage.imageUrls = s.retweetedStatus.picUrls;
            
        } else {
            _retweetedImage.hidden = YES;
        }
    } else {
        _retweeted.hidden = YES;
    }
    
}







@end
