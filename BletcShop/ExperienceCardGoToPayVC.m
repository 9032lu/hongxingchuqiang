//
//  ExperienceCardGoToPayVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/28.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ExperienceCardGoToPayVC.h"
#import "PayCustomView.h"
#import "AccessCodeVC.h"
#import "ChangePayPassVC.h"
#import "PayVictoryVC.h"
#import "HGDQQRCodeView.h"
@interface ExperienceCardGoToPayVC ()<PayCustomViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    PayCustomView * Payview;

    LZDButton *oldBtn;
    UIView *topView;
}
@property (strong, nonatomic) IBOutlet UIView *twoBackView;
@property (nonatomic,strong)  UIView *QRView;

@property(nonatomic,strong) UIView *lineView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBackView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollviewContentWidth;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *card_des;//价格

@end

@implementation ExperienceCardGoToPayVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"体验卡支付";
    
    LZDButton *back =[LZDButton creatLZDButton];back.frame = CGRectMake(0, 11, 30, 40);
    back.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    [back setImage:[UIImage imageNamed:@"返回箭头"] forState:0];back.block = ^(LZDButton *sender) {
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        
        
        
    };
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    
    self.card_des.text = [NSString stringWithFormat:@"¥:%@",_card_dic[@"price"]];
    self.scrollviewContentWidth.constant = SCREENWIDTH*2;

    
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
    
    [self creatCodeView];

}
- (IBAction)goToPayClick:(id)sender {
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *pay_passwd= [NSString getTheNoNullStr:appdelegate.userInfoDic[@"pay_passwd"] andRepalceStr:@""];
    
    
    
    if ([pay_passwd isEqualToString:@"未设置"]) {
        
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有设置支付密码!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        alt.tag = 888;
        [alt show];
        
    }else{
        
        Payview=[[PayCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        Payview.delegate=self;
        
        [Payview.forgotButton addTarget:self action:@selector(forgetPayPass) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:Payview];
        
    }
    
    
    
    
    
}

#pragma mark PayCustomViewDelegate 密码

-(void)confirmPassRightOrWrong:(NSString *)pass
{
    [self checkPayPassWd:pass];
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
            [Payview removeFromSuperview];
            
            
            [self payRequest];
            
            
        }else{
            
            
            [self showHint:@"支付密码错误,请重新输入!"];
            
        }
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)forgetPayPass{
    AccessCodeVC *vc=[[AccessCodeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)payRequest{
    NSString *url = [NSString stringWithFormat:@"%@UserType/ExperienceCard/pay_v2",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer setValue:self.card_dic[@"merchant"] forKey:@"muid"];
    [paramer setValue:self.card_dic[@"card_code"] forKey:@"code"];
    
    
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] intValue]==1) {
            
            
            SoundPaly *sound=[SoundPaly sharedManager:@"sms-received1" type:@"caf"];
            [sound play];
            
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                self.refresheDate();
                
                PayVictoryVC *vc=[[PayVictoryVC alloc]init];
                NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithDictionary:paramer];
                [dictionary setObject:self.card_dic[@"store"] forKey:@"store"];
                [dictionary setObject:[NSString stringWithFormat:@"%@",self.card_dic[@"price"]] forKey:@"oldNeed"];
                [dictionary setObject:self.card_dic[@"card_type"] forKey:@"cardType"];

                vc.dic=dictionary;
                [self.navigationController pushViewController:vc animated:YES];
                
                //[self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                
                
            }];
            
            
            [alertController addAction:sure];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"--------%@",error);
    }];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag ==888) {
        NSLog(@"去设置");
        if (buttonIndex==1) {
            ChangePayPassVC *vc=[[ChangePayPassVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        //得到输入框
        
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [Payview removeFromSuperview];
}


-(void)creatCodeView{
    
    
    
    
    
    UIView *whiteview = [[UIView  alloc]initWithFrame:CGRectMake(13, 10, SCREENWIDTH-26, SCREENWIDTH-26)];
    whiteview.backgroundColor = [UIColor whiteColor];
    whiteview.layer.cornerRadius =6;
    [_twoBackView addSubview:whiteview];
    
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 31, whiteview.width, 14)];
    titleLab.text = @"向商家付款";
    titleLab.textAlignment= NSTextAlignmentCenter;
    titleLab.textColor = RGB(51,51,51);
    titleLab.font = [UIFont systemFontOfSize:15];
    [whiteview addSubview:titleLab];
    
    
    self.QRView = [[UIView alloc]initWithFrame:CGRectMake(88, titleLab.bottom+30, whiteview.width-88*2, whiteview.width-88*2)];
    [whiteview addSubview:_QRView];
    

    
    
    
    UILabel *title_lab_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 31+self.QRView.bottom, whiteview.width, 16)];
    title_lab_1.text = @"体验金额";
    title_lab_1.textAlignment= NSTextAlignmentCenter;
    title_lab_1.textColor = RGB(51,51,51);
    title_lab_1.font = [UIFont systemFontOfSize:15];
    [whiteview addSubview:title_lab_1];
    
    
    UILabel *title_lab_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 31+title_lab_1.bottom, whiteview.width, 15)];
    title_lab_2.text = [NSString stringWithFormat:@"¥:%@",self.card_dic[@"price"]];
    title_lab_2.textAlignment= NSTextAlignmentCenter;
    title_lab_2.textColor = RGB(51,51,51);
    title_lab_2.font = [UIFont boldSystemFontOfSize:20];
    [whiteview addSubview:title_lab_2];
    
    
    
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, title_lab_2.bottom+30, whiteview.width, 1)];
    topline.backgroundColor = RGB(220,220,220);
    [whiteview addSubview:topline];
    
    
    UILabel *title_lab_3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20+topline.bottom, whiteview.width, 13)];
    title_lab_3.text = @"温馨提示：体验卡为一次性体验使用";
    title_lab_3.textAlignment= NSTextAlignmentCenter;
    title_lab_3.textColor = RGB(153,153,153);
    title_lab_3.font = [UIFont systemFontOfSize:14];
    [whiteview addSubview:title_lab_3];
    
    
    
    
  
    
    
    CGRect frame = whiteview.frame;
    frame.size.height = title_lab_3.bottom+21;
    whiteview.frame = frame;

    
    
    
    [self creatQrCodeWithPayContent];
    
    
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
-(void)creatQrCodeWithPayContent{
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/gather/getQrcode",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
   
    NSMutableDictionary*muta_dic = [NSMutableDictionary dictionary];
    [muta_dic setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [muta_dic setValue:app.userInfoDic[@"nickname"] forKey:@"nickname"];
    [muta_dic setValue:app.userInfoDic[@"headimage"] forKey:@"headimage"];

    [muta_dic setValue:self.card_dic[@"price"] forKey:@"sum"];

    [muta_dic setValue:self.card_dic[@"merchant"] forKey:@"muid"];
    [muta_dic setValue:self.card_dic[@"card_code"] forKey:@"code"];
    [muta_dic setValue:@"exp_card" forKey:@"operate"];
    
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];

    [paramer setValue:[NSString dictionaryToJson:muta_dic] forKey:@"content"];

    
    NSLog(@"======%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] intValue]==1) {
            
            
            NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
            
            [m_dic setValue:result[@"order_id"] forKey:@"order_id"];
            
           [m_dic setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
            [m_dic setValue:self.card_dic[@"merchant"] forKey:@"muid"];

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
