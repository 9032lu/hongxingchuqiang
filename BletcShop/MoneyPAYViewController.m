//
//  MoneyPAYViewController.m
//  BletcShop
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MoneyPAYViewController.h"
#import "SoundPaly.h"
#import "ChangePayPassVC.h"
#import "PayCustomView.h"
#import "AccessCodeVC.h"
#import "PayVictoryVC.h"
#import "HGDQQRCodeView.h"

#import "MoneyPaySetMoneyVC.h"

@interface MoneyPAYViewController ()<UIAlertViewDelegate,PayCustomViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    UITextField *textTF;
    PayCustomView *view;
    UILabel *discount;
    UILabel *realPay;
    UIView *bigView;
    
    LZDButton *oldBtn;
    UIView *topView;
}
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UIScrollView *scrollViewBackView;
@property (nonatomic,strong)  UIView *QRView;
@property (nonatomic,strong) UILabel *payMoney_lab;


@end

@implementation MoneyPAYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(234, 234, 234);
    self.navigationItem.title=@"储值卡支付";
    LEFTBACK
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 46)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    for (int i = 0; i <2; i ++) {
        LZDButton *btn = [LZDButton creatLZDButton];
        btn.frame = CGRectMake(i*SCREENWIDTH/2, 0, SCREENWIDTH/2, topView.height);
        btn.tag = i+99;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [topView addSubview:btn];
        
        
        
        
        if (btn.tag==0+99) {
            oldBtn = btn;
            [btn setTitle:@"直接付款" forState:0];
            [btn setTitleColor:RGB(237,72,77) forState:0];
            
            UIView *lineView = [[UIView alloc]init];
            lineView.tag =1000;
            lineView.backgroundColor =RGB(237,72,77);
            lineView.bounds = CGRectMake(0, 0, 81, 1);
            lineView.center = CGPointMake(btn.center.x, btn.center.y+btn.height/2-1);
            [topView addSubview:lineView];
            self.lineView = lineView;
            
        }else{
            [btn setTitle:@"二维码付款" forState:0];
            [btn setTitleColor:RGB(51,51,51) forState:0];
        }
        
        
        btn.block = ^(LZDButton *sender) {
            
            
            _scrollViewBackView.contentOffset = CGPointMake((sender.tag-99)*SCREENWIDTH, 0);
            
            if (sender!=oldBtn) {
                
                if (sender.tag ==1+99) {
                    [self.view endEditing:YES];

                }
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.lineView.center = CGPointMake(sender.center.x, sender.center.y+sender.height/2-1);
                    [sender setTitleColor:RGB(237,72,77) forState:0];
                    [oldBtn setTitleColor:RGB(51,51,51) forState:0];
                }];
               

                oldBtn = sender;
            }
            
        };
        
    }
    
    
    
    UIScrollView *scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, topView.bottom, SCREENWIDTH, SCREENHEIGHT-64-topView.height)];
    
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator= NO;
    
    scrollView.contentSize = CGSizeMake(SCREENWIDTH*2, 0);
    
    [self.view addSubview:scrollView];
    
    self.scrollViewBackView = scrollView;
    
    
    [self creatCodeView];
    
    bigView=[[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREENWIDTH, scrollView.height-1)];
    bigView.backgroundColor=RGB(234, 234, 234);
    [scrollView addSubview:bigView];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 113)];
    backView.backgroundColor = [UIColor whiteColor];
    [bigView addSubview:backView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 16)];
    titleLabel.text=@"输入金额";
    titleLabel.textColor=RGB(51, 51, 51);
    titleLabel.font=[UIFont systemFontOfSize:16.0f];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    
    UILabel *dol=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-50, titleLabel.bottom+10, 30, 25)];
    dol.text=@"￥:";
    dol.font=[UIFont systemFontOfSize:20];
    dol.textAlignment=NSTextAlignmentCenter;
    dol.textColor=RGB(51, 51, 51);
    [backView addSubview:dol];
    
    textTF=[[UITextField alloc]initWithFrame:CGRectMake(dol.right, titleLabel.bottom+10, 150,25)];
    textTF.borderStyle=UITextBorderStyleNone;
    textTF.returnKeyType=UIReturnKeyDone;
    textTF.delegate=self;
    textTF.font=[UIFont systemFontOfSize:20.0f];
    textTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    textTF.placeholder=@"";
    [backView addSubview:textTF];
    
    [textTF becomeFirstResponder];
    
    UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(0, textTF.bottom+10, SCREENWIDTH, 15)];
    noticeLable.textAlignment=NSTextAlignmentCenter;
    noticeLable.textColor=RGB(153,153,153);
    noticeLable.font=[UIFont systemFontOfSize:14];
    noticeLable.text=@"请按商铺原价输入消费金额";
    [backView addSubview:noticeLable];
    
    
    UIView *bottomBackView=[[UIView alloc]initWithFrame:CGRectMake(0, backView.bottom+10, SCREENWIDTH, 170)];
    bottomBackView.backgroundColor=[UIColor whiteColor];
    [bigView addSubview:bottomBackView];
    
    UILabel *discountLable=[[UILabel alloc]initWithFrame:CGRectMake(13, 0, 120, 56)];
    discountLable.textAlignment=NSTextAlignmentLeft;
    discountLable.font=[UIFont systemFontOfSize:16];
    discountLable.text=@"折扣力度:";
    discountLable.textColor=RGB(51, 51, 51);
    [bottomBackView addSubview:discountLable];
    
    UILabel *disPercent=[[UILabel alloc]initWithFrame:CGRectMake(discountLable.right, 0, SCREENWIDTH-13-120-13, 56)];
    disPercent.textAlignment=NSTextAlignmentRight;
    disPercent.textColor=RGB(51, 51, 51);
    disPercent.font=[UIFont systemFontOfSize:16];
    disPercent.text=[NSString stringWithFormat:@"%@%%",self.card_dic[@"rule"]];
    [bottomBackView addSubview:disPercent];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, disPercent.bottom, SCREENWIDTH, 1)];
    line1.backgroundColor=RGB(220, 220, 220);
    [bottomBackView addSubview:line1];
    
    UILabel *deceaseMoney=[[UILabel alloc]initWithFrame:CGRectMake(13, line1.bottom,120, 56)];
    deceaseMoney.textAlignment=NSTextAlignmentLeft;
    deceaseMoney.font=[UIFont systemFontOfSize:16];
    deceaseMoney.text=@"优惠金额:";
    deceaseMoney.textColor=RGB(51, 51, 51);
    [bottomBackView addSubview:deceaseMoney];
    
    discount=[[UILabel alloc]initWithFrame:CGRectMake(deceaseMoney.right, line1.bottom, SCREENWIDTH-13-120-13, 56)];
    discount.textAlignment=NSTextAlignmentRight;
    discount.text=@"￥：0.00元";
    discount.textColor=RGB(51, 51, 51);
    discount.font=[UIFont systemFontOfSize:16.0f];
    [bottomBackView addSubview:discount];

    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, discount.bottom, SCREENWIDTH, 1)];
    line2.backgroundColor=RGB(220, 220, 220);
    [bottomBackView addSubview:line2];
    
    UILabel *realPayLable=[[UILabel alloc]initWithFrame:CGRectMake(13, line2.bottom,120, 56)];
    realPayLable.textAlignment=NSTextAlignmentLeft;
    realPayLable.font=[UIFont systemFontOfSize:16];
    realPayLable.text=@"实际消费金额:";
    realPayLable.textColor=RGB(51, 51, 51);
    [bottomBackView addSubview:realPayLable];
    
    realPay=[[UILabel alloc]initWithFrame:CGRectMake(realPayLable.right, line2.bottom, SCREENWIDTH-13-120-13, 56)];
    realPay.text=@"￥：0.00元";
    realPay.textAlignment=NSTextAlignmentRight;
    realPay.textColor=RGB(51, 51, 51);
    realPay.font=[UIFont systemFontOfSize:16.0f];
    [bottomBackView addSubview:realPay];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:realPay.text];

    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23.0] range:NSMakeRange(2, realPay.text.length-3)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,  realPay.text.length-3)];
    realPay.attributedText=AttributedStr;
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, bigView.height-44, SCREENWIDTH, 44);
    button.backgroundColor=NavBackGroundColor;
    [button setTitle:@"确认支付" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:button];
    NSLog(@"self.card_dic=====%@",self.card_dic);
}
-(void)btnClick:(UIButton *)sender{
    [textTF resignFirstResponder];
    
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *pay_passwd= [NSString getTheNoNullStr:appdelegate.userInfoDic[@"pay_passwd"] andRepalceStr:@""];
    
    
    
    //判断输入的金额和卡的余额对比，如果小于，就弹出输入密码警告框，否就弹出提示，余额不够
    
    NSArray *array=[self.card_dic[@"card_remain"] componentsSeparatedByString:@"元"];
    //    NSLog(@"---%lf",)
    if ([textTF.text floatValue]>0&&[textTF.text floatValue]<=[array[0] floatValue]) {
        
        if ([pay_passwd isEqualToString:@"未设置"]) {
            
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有设置支付密码!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            alt.tag = 888;
            [alt show];
            
        }else{
            
             bigView.frame=CGRectMake(0, -230, SCREENWIDTH, _scrollViewBackView.height-1);
            
            view=[[PayCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            view.delegate=self;
            [view.forgotButton addTarget:self action:@selector(forgetPayPass) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:view];
            
        }
        
    }else{
        if ([textTF.text isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"没有输入金额,请输入金额", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:2.f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"输入金额大于当前卡余额", @"HUD message title");
            hud.label.font = [UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:2.f];
        }
    }
    
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==888) {
        NSLog(@"去设置");
        if (buttonIndex==1) {
            ChangePayPassVC *vc=[[ChangePayPassVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    
}

-(void)checkPayPassWd:(NSString *)payPassWd{
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@Extra/passwd/checkPayPasswd",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    [params setObject:payPassWd forKey:@"pay_passwd"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
       

        
        NSLog(@"result---_%@",result);
        if ([result[@"result_code"] isEqualToString:@"access"]) {
            [view removeFromSuperview];
            
             bigView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64);
            
            [self postSocketCardPayAction];
            
        }else{
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"支付密码错误,请重新输入!";
            hud.mode = MBProgressHUDModeText;
            hud.label.font =[UIFont systemFontOfSize:13];
            [hud hideAnimated:YES afterDelay:1.5];
        }
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)postSocketCardPayAction
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/value_pay",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.user forKey:@"uuid"];
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.card_dic[@"card_level"] forKey:@"cardLevel"];
    
    [params setObject:@"储值卡" forKey:@"cardType"];
    NSString *payMoneyString = [NSString stringWithFormat:@"%.2f",[textTF.text floatValue]*[self.card_dic[@"rule"] floatValue]/100];
    
    [params setObject:payMoneyString forKey:@"sum"];
    
    NSLog(@"params===%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"self.payCardArray=result=%@", result);
         if ([result[@"result_code"] intValue]==1) {
             
             SoundPaly *sound=[SoundPaly sharedManager:@"sms-received1" type:@"caf"];
             [sound play];
             
             
             
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付成功" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
               
//                 self.refresheDate();
                 PayVictoryVC *vc=[[PayVictoryVC alloc]init];
                 NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithDictionary:params];
                 [dictionary setObject:self.card_dic[@"store"] forKey:@"store"];
                 [dictionary setObject:textTF.text forKey:@"oldNeed"];
                 vc.dic=dictionary;
                 [self.navigationController pushViewController:vc animated:YES];
                 
                // [self.navigationController popViewControllerAnimated:YES];

             }];
             
            
             [alertController addAction:sure];
             
             
             [self presentViewController:alertController animated:YES completion:nil];


             //提交消费记录,先获取店铺名
             //             [self getShopName];
             
             
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}
//发送订单详情

//-(void)getShopName{
//    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountGet",BASEURL];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:self.card_dic[@"merchant"] forKey:@"muid"];
//    [params setValue:@"store" forKey:@"type"];
//    
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//        
//        NSLog(@"result----%@",result);
//        
//        [self postOrderInfoWithShopName:result[@"store"]];
//        
//        
//    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//    
//}
//-(void)postOrderInfoWithShopName:(NSString*)shopName
//{
//    
//    
//    
//    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/cnCmt",BASEURL];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:self.card_dic[@"user"] forKey:@"uuid"];
//    
//    
//    
//    NSString *orderInfoMessage = [[NSString alloc]initWithFormat:@"%@%@结算金额%@%@元",self.card_dic[@"merchant"],PAY_USCS,PAY_NP,textTF.text];
//    
//    [params setObject:orderInfoMessage forKey:@"content"];
//    
//    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
//    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate* date  = [NSDate date];
//    NSString *NowDate = [matter stringFromDate:date];
//    [params setObject:NowDate forKey:@"datetime"];
//    [params setObject:textTF.text forKey:@"sum"];
//    NSLog(@"params----%@",params);
//    
//    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
//     {
//         NSLog(@"result%@", result);
//         if ([result[@"result_code"] intValue]==1) {
//             ;
//             
//             
//         }
//         else
//             [self postOrderInfoWithShopName:shopName];
//         
//     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//         //         [self noIntenet];
//         NSLog(@"%@", error);
//     }];
//    
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [view removeFromSuperview];
    bigView.frame=CGRectMake(0, 1, SCREENWIDTH, _scrollViewBackView.height-1);
}

-(void)confirmPassRightOrWrong:(NSString *)pass{
   
    [self checkPayPassWd:pass];
}
-(void)forgetPayPass{
    AccessCodeVC *vc=[[AccessCodeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    CGFloat disc=[self.card_dic[@"rule"] floatValue]/100;
    CGFloat inputMoney=[textTF.text floatValue];
    
    realPay.text=[NSString stringWithFormat:@"￥：%.2f元",disc*inputMoney];
    discount.text=[NSString stringWithFormat:@"￥：%.2f元",inputMoney-disc*inputMoney];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:realPay.text];
    
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23.0] range:NSMakeRange(2, realPay.text.length-3)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,  realPay.text.length-3)];
    realPay.attributedText=AttributedStr;
    return YES;
}
-(void)missPayAlert{
    bigView.frame=CGRectMake(0, 1, SCREENWIDTH, _scrollViewBackView.height-1);
}


-(void)creatCodeView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, _scrollViewBackView.width, _scrollViewBackView.height)];
    view.backgroundColor = RGB(220,220,220);
    [_scrollViewBackView addSubview:view];
    
    
    UIView *whiteview = [[UIView  alloc]initWithFrame:CGRectMake(13, 10, view.width-26, view.width-26)];
    whiteview.backgroundColor = [UIColor whiteColor];
    whiteview.layer.cornerRadius =6;
    [view addSubview:whiteview];
    
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 31, whiteview.width, 14)];
    titleLab.text = @"向商家付款";
    titleLab.textAlignment= NSTextAlignmentCenter;
    titleLab.textColor = RGB(51,51,51);
    titleLab.font = [UIFont systemFontOfSize:15];
    [whiteview addSubview:titleLab];
    
    
    self.QRView = [[UIView alloc]initWithFrame:CGRectMake(88, titleLab.bottom+30, whiteview.width-88*2, whiteview.width-88*2)];
    [whiteview addSubview:_QRView];
   
    
    [self creatQrCodeWithPayContent:@"0"];
    
    
    
    UILabel *payMoney_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, _QRView.bottom+30, whiteview.width, 16)];
    payMoney_lab.textColor = RGB(51,51,51);
    payMoney_lab.textAlignment = NSTextAlignmentCenter;
    payMoney_lab.font = [UIFont systemFontOfSize:19];
    payMoney_lab.text = @"";
    [whiteview addSubview:payMoney_lab];
    
    self.payMoney_lab = payMoney_lab;
    
    for (int i = 0; i <2; i ++) {
        
        LZDButton *btn = [LZDButton creatLZDButton];
        
        btn.frame = CGRectMake(i*whiteview.width/2, payMoney_lab.bottom +40-13, whiteview.width/2, 40);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:RGB(51,51,51) forState:0];
        [whiteview addSubview:btn];
        btn.tag =i;
       
        
        if (i == 0) {
            [btn setTitle:@"设置金额" forState:0];
            
            UIView *shuxina = [[UIView alloc]initWithFrame:CGRectMake(btn.right, btn.top+(btn.height-12)/2, 1, 12)];
            shuxina.backgroundColor = RGB(220,220,220);
            [whiteview addSubview:shuxina];
            
            CGRect frame = whiteview.frame;
            frame.size.height = btn.bottom+18;
            whiteview.frame = frame;
            
        }else{
            NSString *rule = [NSString stringWithFormat:@"折扣力度:%@%%",_card_dic[@"rule"]];
            [btn setTitle:rule forState:0];

        }
        
        
        btn.block = ^(LZDButton *sender) {
            
            if (sender.tag==0) {
                PUSH(MoneyPaySetMoneyVC)
                vc.remian = self.card_dic[@"card_remain"];
                vc.sendMoneyBlock = ^(NSString *money) {
                    
                    [sender setTitle:@"重置金额" forState:0];

                    self.payMoney_lab.text =[NSString stringWithFormat:@"¥%.2f",[money floatValue]*[_card_dic[@"rule"] floatValue]/100];
                    
            [self creatQrCodeWithPayContent:[self.payMoney_lab.text substringFromIndex:1]];

                    
                };
            }
        };
        
    }
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"--%lf",scrollView.contentOffset.x);
    
    [self.view endEditing:YES];
    
    NSInteger tag =scrollView.contentOffset.x/SCREENWIDTH+99;
    
    
    
    LZDButton *btn = (LZDButton*)[topView viewWithTag:tag];
    
    if (btn !=oldBtn) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.lineView.center = CGPointMake(btn.center.x, btn.center.y+btn.height/2-1);
            [btn setTitleColor:RGB(237,72,77) forState:0];
            [oldBtn setTitleColor:RGB(51,51,51) forState:0];
        }];
        
        oldBtn = btn;
        
    }
    
    
    
    
    
    
    
    
}


/*
 生成订单信息,生成二维码
 **/
-(void)creatQrCodeWithPayContent:(NSString *)sumString{
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/gather/getQrcode",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    NSMutableDictionary*muta_dic = [NSMutableDictionary dictionary];
    [muta_dic setObject:self.user forKey:@"uuid"];
    [muta_dic setValue:app.userInfoDic[@"nickname"] forKey:@"nickname"];
    [muta_dic setValue:app.userInfoDic[@"headimage"] forKey:@"headimage"];
    
    
    [muta_dic setValue:@"value_card" forKey:@"operate"];

    
    [muta_dic setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [muta_dic setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    [muta_dic setObject:self.card_dic[@"card_level"] forKey:@"cardLevel"];
    
    [muta_dic setObject:@"储值卡" forKey:@"cardType"];
    
    [muta_dic setObject:sumString forKey:@"sum"];
    
    
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [paramer setValue:[NSString dictionaryToJson:muta_dic] forKey:@"content"];
    
    
    NSLog(@"======%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] intValue]==1) {
            
            
            NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
            
            [m_dic setValue:result[@"order_id"] forKey:@"order_id"];
            
            [m_dic setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
            
            NSString  *codeString = [NSString dictionaryToJson:m_dic];
            
            
            NSString *string=[NSString stringWithFormat:@"%@%@",HEADIMAGE,[app.userInfoDic objectForKey:@"headimage"]];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSURL * nurl1=[NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                UIImage *img=  [UIImage imageWithData:[NSData dataWithContentsOfURL:nurl1]];
                
                img = [NSString setThumbnailFromImage:img];
                
                if (!img) {
                    img = [UIImage imageNamed:@"app_icon3"];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [HGDQQRCodeView creatQRCodeWithURLString:codeString superView:self.QRView logoImage:img logoImageSize:CGSizeMake(_QRView.width*0.2, _QRView.width*0.2) logoImageWithCornerRadius:10];
                });
                
            }) ;
            
            
            
        }
        
        NSLog(@"=result=====%@",result);
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"=error=====%@",error);
        
    }];
    
    
    
}



@end
