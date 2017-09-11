//
//  OilMapVC.h
//  BletcShop
//
//  Created by apple on 2017/8/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "RouteAnnotation.h"
#import "UIImage+Rotate.h"
#import "BNCoreServices.h"
@interface OilMapVC : UIViewController<BMKMapViewDelegate, BMKLocationServiceDelegate>
@property (strong, nonatomic) BMKMapView *mapView;

@property (nonatomic , strong) UIButton *daohangBtn;// 导航按钮

@property (strong, nonatomic) BMKLocationService *locService;
@property(nonatomic)CLLocationDegrees latitude;
@property(nonatomic)CLLocationDegrees longitude;
@end
