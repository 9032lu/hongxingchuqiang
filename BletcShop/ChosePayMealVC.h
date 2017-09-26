//
//  ChosePayMealVC.h
//  BletcShop
//
//  Created by Bletc on 2017/9/25.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChosePayMealVC : UIViewController
@property (nonatomic , strong) NSDictionary *card_dic;// 卡的信息

@property (nonatomic,copy)void (^sendValueBlock)(NSArray *arr);// <#Description#>

@end
