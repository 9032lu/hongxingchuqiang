//
//  MoneyPaySetMoneyVC.h
//  BletcShop
//
//  Created by Bletc on 2017/9/25.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyPaySetMoneyVC : UIViewController
@property (nonatomic,copy)NSString *remian;

@property (nonatomic,copy)void (^sendMoneyBlock)(NSString*money);


@end
