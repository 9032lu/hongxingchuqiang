//
//  CountQRCodeVC.h
//  BletcShop
//
//  Created by Bletc on 2017/9/27.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountQRCodeVC : UIViewController


@property (nonatomic,copy) void(^resetNumBlock)() ;//重置次数 <#Description#>


@property(nonatomic)float all;
@property(nonatomic,assign)NSInteger number_count;
@property (nonatomic,copy)NSString *user;// <#Description#>

@property (nonatomic , strong) NSDictionary *card_dic;// <#Description#>

@end
