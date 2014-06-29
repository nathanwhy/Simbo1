//
//  MapViewController.m
//  Simbo1
//
//  Created by NPHD on 14-6-25.
//  Copyright (c) 2014年 Nathan Wu. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "StatusTool.h"
#import "HttpTool.h"
#import "MapStatus.h"
#import "MyAnnotation.h"
#import "MKAnnotationView+WebCache.h"

#define kSpan MKCoordinateSpanMake(0.017124, 0.010987)
@interface MapViewController ()<MKMapViewDelegate>

@end

@implementation MapViewController
{
    MKMapView *_mapView;
    NSMutableArray *_dataArray;
}


- (void)viewDidLoad
{
    _dataArray = [NSMutableArray array];
    
    [super viewDidLoad];
    
    self.title = @"附近";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //添加地图
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    [self addUI];
}

//增加控件
- (void) addUI
{
    //添加回到用户位置的按钮
    UIButton *backToUser = [UIButton buttonWithType:UIButtonTypeSystem];
    [backToUser setTitle:@"当前位置" forState:UIControlStateNormal];
    [backToUser setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.6]];
    CGFloat btnX = self.view.frame.size.width - 65;
    CGFloat btnY = self.view.frame.size.height - 45;
    backToUser.frame = CGRectMake(btnX, btnY, 60, 25);
    [backToUser addTarget:self action:@selector(backToUserClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backToUser];
    
    //关闭地图按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeBtn setTitle:@"返回" forState:UIControlStateNormal];
    [closeBtn setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    closeBtn.frame = CGRectMake(5, 17, 50, 25);
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeBtn];
}


//返回用户当前位置
- (void)backToUserClick
{
    CLLocationCoordinate2D center = _mapView.userLocation.location.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMake(center, kSpan);
    [_mapView setRegion:region animated:YES];
}

// 关闭视图
- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 当定位到用户的位置就会调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (_mapView) return;
    
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(center, kSpan);//设置跨度
    
    [mapView setRegion:region animated:YES];
    _mapView = mapView;
    
    NSLog(@"坐标-----%f,%f",center.latitude,center.longitude);
    
//    //加载数据
    [self loadMapStatusWithCoordinate:center mapView:mapView];
    
    
}


#pragma mark - 加载数据
- (void)loadMapStatusWithCoordinate:(CLLocationCoordinate2D)coordinate mapView:(MKMapView *)mapView
{
    CGFloat lat = coordinate.latitude;
    CGFloat lon = coordinate.longitude;
    NSDictionary *dic = @{@"lat": @(lat),
                          @"long":@(lon),
                          @"count":@(20),
                          @"page":@(1),
                          @"range":@(600),
                          @"sort":@0};
    
    
    [HttpTool getWithpath:@"2/place/nearby/users.json" params:dic success:^(id JSON) {
        
        
        // 解析json对象
        NSDictionary *test = JSON;
        if (test.count <1) return;//无数据返回
        
        NSArray *array = JSON[@"users"];
        for (NSDictionary *dict in array) {
            MapStatus *singleData = [[MapStatus alloc] initWithDict:dict];
            
            //过滤重复信息
            BOOL isContain = NO;
            for (MapStatus *s in _dataArray) {
                if (s.ID == singleData.ID){
                    isContain = YES;
                }
            }
            if (!isContain) {
                [_dataArray addObject:singleData];
                
                MyAnnotation *anno = [[MyAnnotation alloc] init];
                anno.coordinate = CLLocationCoordinate2DMake(singleData.latitude, singleData.longitude);
                anno.status = singleData;
                
                [mapView addAnnotation:anno];

            }
            
            
        }
        
    } failure:^(NSError *error){
        NSLog(@" 地图数据加载失败-%@",error);
    }];
    
    
}

#pragma mark 拖动地图就会调用
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D center = mapView.region.center;
    
    [self loadMapStatusWithCoordinate:center mapView:mapView];
    
}


#pragma mark 大头针视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MyAnnotation *)annotation
{
    // 1.从缓存池中取出大头针view
    static NSString *ID = @"MKAnnotationView";
    MKPinAnnotationView *annoView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    // 2.缓存池没有可循环利用的大头针view
    if (annoView == nil) {
        // 这里应该用MKPinAnnotationView这个子类
        annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
    }
    
    // 3.设置view的大头针信息
    annoView.annotation = annotation;
    annoView.animatesDrop = YES;
    annoView.canShowCallout = YES;
    
    return annoView;
    
}



- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"--error:%@",[error description]);
}
@end
