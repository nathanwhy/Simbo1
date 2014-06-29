//
//  HttpTool.h
//  Simbo1
//
//  Created by NPHD on 14-5-13.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError *error);

@interface HttpTool : NSObject

+ (void) requestWithpath:(NSString *)path method:(NSString *)method params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

+ (void) postWithpath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

+ (void) getWithpath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

+ (void)downloadImage:(NSString*)url place:(UIImage*)place imageView:(UIImageView *)imageView;
@end
