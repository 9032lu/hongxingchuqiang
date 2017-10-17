//
//  BaiduMapViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/9/8.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "BaiduMapViewController.h"

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

#define Width  [UIScreen mainScreen].bounds.size.width
#define Height [[UIScreen mainScreen] bounds].size.height
#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]
@interface BaiduMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate,BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>
{
    BMKRouteSearch* _routesearch;
}
@property(nonatomic,strong)BMKMapView* mapView;
@property(nonatomic,strong)BMKLocationService* locService;
@property (nonatomic,strong)BMKUserLocation *userLocation; //定位功能
@property (nonatomic, strong)BMKGeoCodeSearch* searchAddress;
@property (nonatomic,strong) BMKAnnotationView *selectAnnotation;
@property (nonatomic , strong) UIButton *daohangBtn;// 导航按钮

@end

@implementation BaiduMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,0, Width, Height-64)];
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.showMapScaleBar = YES;//显示比例尺
    _mapView.zoomLevel=18;//地图显示的级别
    _mapView.rotateEnabled=YES;//允许旋转
    _mapView.mapType=BMKMapTypeStandard;
    [self.view addSubview:_mapView];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _searchAddress = [[BMKGeoCodeSearch alloc] init];
    
    titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.text=@"百度动图练习demo";
//    [self.view addSubview:titleLab];
    
    
    
    self.daohangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.daohangBtn.frame = CGRectMake(SCREENWIDTH-SCREENWIDTH*0.15-20, SCREENHEIGHT-SCREENWIDTH*0.15-30-64, SCREENWIDTH*0.15, SCREENWIDTH*0.15);
    [self.daohangBtn setBackgroundImage:[UIImage imageNamed:@"飞机icon"] forState:UIControlStateNormal];
    [self.daohangBtn setBackgroundImage:[UIImage imageNamed:@"飞机icon"] forState:UIControlStateHighlighted];
    
    
    
    [self.daohangBtn addTarget:self action:@selector(daohang) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.daohangBtn];

    
    
}
#pragma mark - BaiduMap
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView

{
    
    
    
    
    
    
    [_mapView setCompassPosition:CGPointMake(200,200)];//指南针位置可能看不见，这个和官方的交流吧！不清楚是什么原因
    
    //     [_mapView reloadInputViews];
    
    
    
}

//自定义大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    
    
    
    
    if ([annotation isKindOfClass:[RouteAnnotation class]])
    {return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation *)annotation];
        
    }else
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        newAnnotationView.annotation=annotation;
        
        newAnnotationView.image = [UIImage imageNamed:@"组-4-拷贝-5"];
        
        newAnnotationView.bounds=CGRectMake(0, 0, 44, 57);
        return newAnnotationView;
    }
}
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation{
    
    BMKAnnotationView *view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = true;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"myAnnotation"];
                
                view.image = [UIImage imageNamed:@"组-4-拷贝-5"];
                
                
                view.bounds=CGRectMake(0, 0, 44, 57);
                
                view.canShowCallout = true;
            }
            view.annotation =routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = true;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image=[UIImage imageNamed:@"icon_direction.png"];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    return view;
}



- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"当前位置%f,%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    
    
    
    _userLocation=userLocation;
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = userLocation.location.coordinate;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeoOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoOption.reverseGeoPoint = pt;
    BOOL flag = [_searchAddress reverseGeoCode:reverseGeoOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    }
    
    BMKReverseGeoCodeOption *reverseGeo = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeo.reverseGeoPoint = pt;
    [_searchAddress reverseGeoCode:reverseGeo];
    
    [_mapView updateLocationData:userLocation];
    [_locService stopUserLocationService];//取消定位
    
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //点击出路径
    CLLocationCoordinate2D coor;
    coor.latitude = _latitude;
    coor.longitude = _longitude;
    CLLocationCoordinate2D pe = (CLLocationCoordinate2D){coor.latitude,coor.longitude};
    BMKReverseGeoCodeOption *reverseGeo = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeo.reverseGeoPoint = pe;
    [_searchAddress reverseGeoCode:reverseGeo];
    
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt=(CLLocationCoordinate2D){_userLocation.location.coordinate.latitude, _userLocation.location.coordinate.longitude};
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt=(CLLocationCoordinate2D){coor.latitude,coor.longitude};
    
    _routesearch=[[BMKRouteSearch alloc]init];
    _routesearch.delegate=self;
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
    
    
    
    _mapView.isSelectedAnnotationViewFront=YES;
}
//具体地址的打印
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    
    self.cityStr=result.addressDetail.city;
    self.addrDetailStr=[NSString stringWithFormat:@"%@%@%@",result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
    NSLog(@"%@xiangxidizhi ",self.addrDetailStr);
    NSLog(@"%@ ====cityname====",self.cityStr);
    
    
    place = [NSString stringWithFormat:@"%@%@",self.cityStr,self.addrDetailStr];
    _dizhiStr=[NSString stringWithFormat:@"%@",place];
    NSLog(@"%@ ====placeplac输出eplaceplaceplace====",place);
    NSLog(@"%@ ====placeplac输出eplaceplaceplace====",_dizhiStr);
    
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"执行了没有11");
    if ([view.reuseIdentifier isEqualToString:@"myAnnotation"]) {
        
        NSLog(@"执行了没有");
        view.bounds=CGRectMake(0, 0,58,75);
        if (self.selectAnnotation) {
            if ([self.selectAnnotation.reuseIdentifier isEqualToString:@"myAnnotation"]) {
                
                
                self.selectAnnotation.bounds=CGRectMake(0, 0, 44, 57);
                
            }
            
        }
        self.selectAnnotation = view;
//        //点击出路径
//        CLLocationCoordinate2D coor;
//        coor.latitude = view.annotation.coordinate.latitude;
//        coor.longitude = view.annotation.coordinate.longitude;
//        CLLocationCoordinate2D pe = (CLLocationCoordinate2D){coor.latitude,coor.longitude};
//        BMKReverseGeoCodeOption *reverseGeo = [[BMKReverseGeoCodeOption alloc]init];
//        reverseGeo.reverseGeoPoint = pe;
//        [_searchAddress reverseGeoCode:reverseGeo];
//        
//        
//        BMKPlanNode* start = [[BMKPlanNode alloc]init];
//        start.pt=(CLLocationCoordinate2D){_userLocation.location.coordinate.latitude, _userLocation.location.coordinate.longitude};
//        BMKPlanNode* end = [[BMKPlanNode alloc]init];
//        end.pt=(CLLocationCoordinate2D){coor.latitude,coor.longitude};
//        
//        _routesearch=[[BMKRouteSearch alloc]init];
//        _routesearch.delegate=self;
//        BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
//        walkingRouteSearchOption.from = start;
//        walkingRouteSearchOption.to = end;
//        BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
//        if(flag)
//        {
//            NSLog(@"walk检索发送成功");
//        }
//        else
//        {
//            NSLog(@"walk检索发送失败");
//        }
//        
//        
    }
//    _mapView.isSelectedAnnotationViewFront=YES;
//    view.paopaoView.hidden=YES;
//    //点击出弹窗
    
    
}
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"onGetWalkingRouteResult error:%d", (int)error);
    NSMutableArray * array = [NSMutableArray array];
    
    for (BMKAnnotationView* item in _mapView.annotations) {
        if ([item isKindOfClass:[RouteAnnotation class]]) {
            [array addObject:item];
        }
    }
    [_mapView removeAnnotations:array];
    NSArray*arrayTwo = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:arrayTwo];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                //                [_mapView addAnnotation:item]; // 添加起点标注
                
            }
            if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                //                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            
            [_mapView addAnnotation:item];
            
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        julidurationH=plan.duration.hours+plan.duration.dates*24;
        julidurationM=plan.duration.minutes;
        julidurationS=plan.duration.seconds;
        
        julidistance=plan.distance;
        //        julidistancekm=julidistance/1000;
        julidistancekm=[[NSString stringWithFormat:@"%.3f",julidistance/1000] doubleValue];
        
        NSLog(@"result.taxiInfo.durationresult.distance%.3f",julidistancekm);
        NSLog(@"result.taxiInfo.durationresult.duration.hour%.d",julidurationH); NSLog(@"result.taxiInfo.durationresult.duration.minutes%d",julidurationM); NSLog(@"result.taxiInfo.durationresult.duration.seconds%.d",julidurationS);
        // 通过points构建BMKPolyline
        titleLab.text=[NSString stringWithFormat:@"距离%f公里，耗时%d时%d分%d秒",julidistancekm,julidurationH,julidurationM,julidurationS];
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR) {
        //检索地址有歧义,返回起点或终点的地址信息结果：BMKSuggestAddrInfo，获取到推荐的poi列表
        NSLog(@"检索地址有岐义，请重新输入。");
        
    }
    
}
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView=[[BMKPolylineView alloc]initWithOverlay:overlay];
        polylineView.fillColor=COLOR_WITH_HEX(0x009dff);
        polylineView.strokeColor=COLOR_WITH_HEX(0x009dff);
        polylineView.lineWidth=1.5;
        return polylineView;
    }
    
    return nil;
}


//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}


-(void)daohang{
    
    
    
    
    if (![self checkServicesInited]) return;
    [self startNavi];
    
    
    
}
- (void)startNavi
{
    BOOL useMyLocation = YES;
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    //    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //    CLLocationCoordinate2D dstLoc;
    //    dstLoc.longitude = _longitude;
    //    dstLoc.latitude =_latitude;
    //
    //    [self NavigateFrom:appdelegate.userLocation.location.coordinate to:dstLoc];
    
    CLLocation *myLocation = [BNCoreServices_Location getLastLocation];
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    if (useMyLocation) {
        startNode.pos.x = myLocation.coordinate.longitude;
        startNode.pos.y = myLocation.coordinate.latitude;
        startNode.pos.eType = BNCoordinate_OriginalGPS;
    }
    else {
        startNode.pos.x = 113.948222;
        startNode.pos.y = 22.549555;
        startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    }
    [nodesArray addObject:startNode];
    
    //也可以在此加入1到3个的途经点
    //
    //    BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
    //    midNode.pos = [[BNPosition alloc] init];
    //    midNode.pos.x = 113.977004;
    //    midNode.pos.y = 22.556393;
    //    //midNode.pos.eType = BNCoordinate_BaiduMapSDK;
    //    //    [nodesArray addObject:midNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = _longitude;
    endNode.pos.y = _latitude;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    //关闭openURL,不想跳转百度地图可以设为YES
    [BNCoreServices_RoutePlan setDisableOpenUrl:YES];
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
    
    //导航中改变终点方法示例
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
     endNode.pos = [[BNPosition alloc] init];
     endNode.pos.x = 114.189863;
     endNode.pos.y = 22.546236;
     endNode.pos.eType = BNCoordinate_BaiduMapSDK;
     [[BNaviModel getInstance] resetNaviEndPoint:endNode];
     });*/
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary*)userInfo
{
    switch ([error code]%10000)
    {
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONFAILED:
            NSLog(@"暂时无法获取您的位置,请稍后重试");
            break;
        case BNAVI_ROUTEPLAN_ERROR_ROUTEPLANFAILED:
            NSLog(@"无法发起导航");
            break;
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONSERVICECLOSED:
            NSLog(@"定位服务未开启,请到系统设置中打开定位服务。");
            break;
        case BNAVI_ROUTEPLAN_ERROR_NODESTOONEAR:
            NSLog(@"起终点距离起终点太近");
            break;
        default:
            NSLog(@"算路失败");
            break;
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}

#pragma mark - 安静退出导航

- (void)exitNaviUI
{
    [BNCoreServices_UI exitPage:EN_BNavi_ExitTopVC animated:YES extraInfo:nil];
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航页面回调
- (void)onExitPage:(BNaviUIType)pageType  extraInfo:(NSDictionary*)extraInfo
{
    if (pageType == BNaviUI_NormalNavi)
    {
        NSLog(@"退出导航");
    }
    else if (pageType == BNaviUI_Declaration)
    {
        NSLog(@"退出导航声明页面");
    }
}

- (BOOL)checkServicesInited
{
    if(![BNCoreServices_Instance isServicesInited])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"引擎尚未初始化完成，请稍后再试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [ _mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _searchAddress.delegate=self;
    _locService.delegate=self;
    _routesearch.delegate =self;
    //消除地图定位圈
    
    BMKLocationViewDisplayParam* testParam = [[BMKLocationViewDisplayParam alloc] init];
    testParam.isRotateAngleValid = false;// 跟随态旋转角度是否生效
    testParam.isAccuracyCircleShow = false;// 精度圈是否显示
    //testParam.locationViewImgName = @"icon_compass";// 定位图标名称
    // testParam.locationViewOffsetX = 0;//定位图标偏移量(经度)
    // testParam.locationViewOffsetY = 0;// 定位图标偏移量(纬度)
    
    [_mapView updateLocationViewWithParam:testParam];
    //    一般这个是从后台服务器获取的经纬度
    BMKPointAnnotation *point1 = [[BMKPointAnnotation alloc]init];
    point1.title=_shopName;
    
//    point1.subtitle=@"收到了上课的看看";
    point1.coordinate = CLLocationCoordinate2DMake(_latitude, _longitude);
 [_mapView selectAnnotation:point1 animated:YES];//标题和子标题自动显示
    [_mapView addAnnotation:point1];
    
    


    
    
//    BMKPointAnnotation *point2 = [[BMKPointAnnotation alloc]init];
//    CLLocationDegrees jingduTwo = 32.0362928891;
//    point2.title=@"2";
//    
//    point2.subtitle=@"2";
//    CLLocationDegrees weiduTwo =118.7869477272;
//    point2.coordinate = CLLocationCoordinate2DMake(jingduTwo, weiduTwo);
//    [_mapView addAnnotation:point2];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [ _mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searchAddress.delegate=nil;
    _locService.delegate=nil;
    _routesearch.delegate = nil; // 不用时，置nil
    
}

@end
