//
//  MoneyPaySetMoneyVC.m
//  BletcShop
//
//  Created by Bletc on 2017/9/25.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "MoneyPaySetMoneyVC.h"

@interface MoneyPaySetMoneyVC ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *moneTF;

@end

@implementation MoneyPaySetMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.navigationItem.title = @"设置金额";

}
- (IBAction)sureBtnClick:(UIButton *)sender {
    
    
    [_moneTF resignFirstResponder];
    
    if ([NSString isPureInt:_moneTF.text] || [NSString isPureFloat:_moneTF.text]) {
        
        if ([_moneTF.text floatValue]<=[_remian floatValue]) {
            POP

            self.sendMoneyBlock(_moneTF.text);
        }else{
            [self showHint:@"会员卡余额不足!"];

        }
        
    }else{
        [self showHint:@"请输入纯数字!"];
    }
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
