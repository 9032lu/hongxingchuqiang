//
//  BaiduMapViewController.h
//  BletcShop
//
//  Created by Bletc on 2017/9/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface BaiduMapViewController : UIViewController
{   NSString * place;
    int julidurationH;
    int julidurationM;
    int julidurationS;
    double julidistance;
    double julidistancekm;
    UILabel*titleLab;
}
@property(nonatomic,copy)NSString * cityStr;//定位之后的城市
@property(nonatomic,copy)NSString *addrDetailStr;//定位之后的详细地址
@property(nonatomic,copy)NSString *districtStr;//搜索之后的小区名称
@property(nonatomic,copy)NSString *dizhiStr;

@property (nonatomic,copy)NSString *shopName;// <#Description#>

@property(nonatomic)CLLocationDegrees latitude;
@property(nonatomic)CLLocationDegrees longitude;

@end
