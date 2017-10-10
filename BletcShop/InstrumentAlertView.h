//
//  InstrumentAlertView.h
//  BletcShop
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertResult)(NSInteger index);
@interface InstrumentAlertView : UIView
@property (nonatomic,copy) AlertResult resultIndex;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle logo:(NSString *)imageName bgImageView:(NSString *)bgName;

- (void)showXLAlertView;
@end
