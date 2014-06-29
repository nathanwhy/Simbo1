//
//  HttpTool.m
//  Simbo1
//
//  Created by NPHD on 14-5-13.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "AccountTool.h"
#import "UIImageView+WebCache.h"
#import "MKNetworkKit.h"

@implementation HttpTool


+ (void) requestWithpath:(NSString *)path
                     method:(NSString *)method
                     params:(NSDictionary *)params
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure;
{
    //1.创建post请求
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    // 拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
    }
    
    // 拼接token参数
    NSString *token = [AccountTool shareAccountTool].account.accessToken;
    if (token) {
        [allParams setObject:token forKey:@"access_token"];
    }

    NSURLRequest *request = [client requestWithMethod:method path:path parameters:allParams];
    
    //----支持text/html模式---（害我调试了半天）
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    //创建AFJSONRequestOperation对象
    NSOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success == nil) return;
        success(JSON);
   
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure == nil) return;
        failure(error);
        
    }];
    
    //发送请求
    [operation start];
    
    //------------mk---
//    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:kBaseURL];
//    MKNetworkOperation *op = [engine operationWithPath:@"2/place/nearby/photos.json" params:allParams httpMethod:@"GET"];
//    
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        NSLog(@"----加载成功--%@",[completedOperation responseString]);
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        failure(error);
//    }];
//    
//    [engine enqueueOperation:op];
    
    
    
}



+ (void) postWithpath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
{
    [self requestWithpath:path method:@"POST" params:params success:success failure:failure];

}

+ (void) getWithpath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
{
    [self requestWithpath:path method:@"GET" params:params success:success failure:failure];
}
#pragma mark 下载图片 

+ (void)downloadImage:(NSString*)url place:(UIImage*)place imageView:(UIImageView *)imageView
{
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageDownloaderLowPriority | SDWebImageRetryFailed];
}

















@end
