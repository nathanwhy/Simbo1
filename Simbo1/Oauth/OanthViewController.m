//
//  OanthViewController.m
//  Simbo1
//
//  Created by NPHD on 14-5-12.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "OanthViewController.h"
#import "OauthID.h"
#import "AccountTool.h"
#import "HomeViewController.h"
#import "NaviController.h"
#import "MBProgressHUD.h"
#import "HttpTool.h"



@interface OanthViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
//    UIActivityIndicatorView *_aiv;
}

@end

@implementation OanthViewController

- (void)loadView
{
    _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = _webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //请求授权
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?display=mobile&client_id=%@&redirect_uri=%@", kAppKey, kRedirect_uri];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    _webView.delegate = self;
    
}

#pragma mark 设置web的代理方法
//开始加载请求调用
-(void)webViewDidStartLoad:(UIWebView *)webView
{
//    _aiv = [[UIActivityIndicatorView alloc] init];
//    _aiv.frame = CGRectMake(100, 100, 100, 100);
//    [self.view addSubview:_aiv];
//    _aiv.color = [UIColor blackColor];
//    hud.dimBackground = YES; //蒙版
//    [_aiv startAnimating];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText =@"别慌，正在加载";

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [_aiv stopAnimating];
}





#pragma  mark 拦截webView的所有请求
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    //MyLog(@"request----URL%@", request.URL);
    
    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    if (range.length != 0) {
        NSUInteger index = range.location + range.length;
        NSString *requestToken = [request.URL.absoluteString substringFromIndex:index];
        
        //NSLog(@"requestToken--%@",requestToken);
        
        [self getAccessToken:requestToken];
        
        return NO;
    }
    
    
    return YES;
}


- (void)getAccessToken:(NSString*)requestToken
{
    
    //创建post另一种
    //NSMutableURLRequest *post = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/access_token"]];
    
    
    [HttpTool postWithpath:@"/oauth2/access_token"
                    params:@{
                             @"client_id" : kAppKey,
                             @"client_secret" : kAppSecret,
                             @"grant_type" : @"authorization_code",
                             @"redirect_uri" : kRedirect_uri,
                             @"code" : requestToken
                   }
                   success:^(id JSON) {
                       
                       MyLog(@"~~~~~~json--------%@",JSON);
                       //保存账号
                       Account *account = [[Account alloc] init];
                       account.accessToken = JSON[@"access_token"];
                       account.uid = JSON[@"uid"];
                       [[AccountTool shareAccountTool] saveAccount:account];
                       MyLog(@"-------token------%@",[AccountTool shareAccountTool].account.accessToken);
                       //回到主界面
                       HomeViewController *home = [[HomeViewController alloc] init];
                       NaviController *nav = [[NaviController alloc] initWithRootViewController:home];
                       
                       self.view.window.rootViewController = nav;
                    
                   }
                   failure:^(NSError *error) {
                       MyLog(@"failed-%@", [error localizedDescription]);
                       //清除指示器
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }];
    
    
}



@end
