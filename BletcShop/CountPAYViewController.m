//
//  CountPAYViewController.m
//  BletcShop
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CountPAYViewController.h"
#import "SoundPaly.h"
#import "ChangePayPassVC.h"
#import "PayCustomView.h"
#import "AccessCodeVC.h"
#import "PayVictoryVC.h"
#import "HGDQQRCodeView.h"

#import "CountQRCodeVC.h"

@interface CountPAYViewController ()<UITextFieldDelegate,UIAlertViewDelegate,PayCustomViewDelegate,UIScrollViewDelegate>
{
    UITextField *textTF;
    NSInteger count;
    PayCustomView *view;
    LZDButton *oldBtn;
    UIView *topView;
}
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UIScrollView *scrollViewBackView;
@property (nonatomic,strong)  UIView *QRView;
@property(nonatomic,assign)NSInteger number_count;

@property (nonatomic,strong)  UIImage *thumbnailImg;

@end

@implementation CountPAYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(234, 234, 234);
    self.navigationItem.title=@"计次卡支付";
    NSLog(@"%@",self.card_dic);
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
    
    
    
    
    
    NSArray *array= [self.card_dic[@"price"] componentsSeparatedByString:@"元"];
    
    self.all=[array[0] floatValue];
    
    UIView *onebackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _scrollViewBackView.width, _scrollViewBackView.height)];
    onebackView.backgroundColor=RGB(234, 234, 234);
    
    [_scrollViewBackView addSubview:onebackView];
    
    
    
    [self creatCodeView];

    
    //修改
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 206)];
    bgView.backgroundColor=[UIColor whiteColor];
    [onebackView addSubview:bgView];
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 28, SCREENWIDTH, 20)];
    titleLable.font=[UIFont systemFontOfSize:16];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.textColor=RGB(51, 51, 51);
    titleLable.text=@"请创建消费次数";
    [bgView addSubview:titleLable];
    
    UIButton *redBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    redBtn.backgroundColor = [UIColor whiteColor];
    //[redBtn setTitle:@"-" forState:UIControlStateNormal];
    [redBtn setImage:[UIImage imageNamed:@"-"] forState:UIControlStateNormal];
    [redBtn setTitleColor:RGB(243, 73, 78) forState:UIControlStateNormal];
    redBtn.titleLabel.font=[UIFont systemFontOfSize:32];
    redBtn.frame=CGRectMake(40, 100, 40, 40);
    redBtn.layer.cornerRadius=20;
    redBtn.clipsToBounds=YES;
    redBtn.layer.borderWidth=1.0;
    redBtn.layer.borderColor=[RGB(243, 73, 78) CGColor];
    [redBtn addTarget:self action:@selector(redBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:redBtn];
    //右加
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(SCREENWIDTH-40-40, 100, 40,40);
    [addBtn setTitleColor:RGB(243, 73, 78) forState:UIControlStateNormal];
   // [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    addBtn.titleLabel.font=[UIFont systemFontOfSize:32];
    addBtn.layer.cornerRadius=20;
    addBtn.clipsToBounds=YES;
    addBtn.layer.borderWidth=1.0;
    addBtn.layer.borderColor=[RGB(243, 73, 78) CGColor];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    addBtn.backgroundColor = [UIColor whiteColor];

    [bgView addSubview:addBtn];
    //立即购买
    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame=CGRectMake(0, onebackView.height-44, SCREENWIDTH, 44);
    buyBtn.backgroundColor=NavBackGroundColor;
    [buyBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [onebackView addSubview:buyBtn];
    //显示次数的label
    textTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-60, 95, 120, 50)];
    textTF.textAlignment=1;
    textTF.backgroundColor=RGB(243, 73, 78);
    textTF.textColor=[UIColor whiteColor];
    textTF.text=@"0";
    textTF.delegate=self;
    textTF.layer.cornerRadius=15;
    textTF.clipsToBounds=YES;
    [bgView addSubview:textTF];
    
    
}
-(void)redBtnClick{
    if (count!=0) {
        count--;
        textTF.text=[[NSString alloc]initWithFormat:@"%ld",(long)count];
    }
}
-(void)addBtnClick{
    
    double price = [self.card_dic[@"price"] doubleValue];
    double card_remain = [self.card_dic[@"card_remain"] doubleValue];
    
    int rule =[self.card_dic[@"rule"] intValue];
    
    int time = (int)(card_remain/(price/rule));
    
    
//    int lastPerson = [self.card_dic[@"rule"] intValue];
    if (count<time) {
        count++;
        textTF.text=[[NSString alloc]initWithFormat:@"%ld",(long)count];
    }
}


/**
 确认支付
 */
-(void)buyClick{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *pay_passwd= [NSString getTheNoNullStr:appdelegate.userInfoDic[@"pay_passwd"] andRepalceStr:@""];
    
    NSString *oneString = self.card_dic[@"price"];
    
    
    NSString *allString = self.card_dic[@"card_remain"];;
    
    
    double onePrice = [oneString doubleValue];
    double allPrice = [allString doubleValue];
    
    int cishu =[self.card_dic[@"rule"] intValue];
    int time = (int)(onePrice/(allPrice/cishu));
    NSLog(@"-----%ld---%d",[textTF.text integerValue],time);
    
    if ([textTF.text integerValue]>0 &&  [textTF.text integerValue]<=time) {
        
        if ([pay_passwd isEqualToString:@"未设置"]) {
            
            UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有设置支付密码!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
            alt.tag = 888;
            [alt show];
            
        }else{
            
            self.payCount=[textTF.text intValue];
            
            view=[[PayCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            view.delegate=self;
            [view.forgotButton addTarget:self action:@selector(forgetPayPass) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:view];
        }
        
    }else{
        if ([textTF.text integerValue]<=0) {
            [self showHint:@"请添加消费次数"];
            
        }else{
            [self showHint:@"可消费次数不足"];

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
    }else{
        //得到输入框
        
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
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/card/count_pay",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:self.user forKey:@"uuid"];
    [params setObject:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    [params setObject:self.card_dic[@"card_level"] forKey:@"cardLevel"];
    
    
    int cishu =[self.card_dic[@"rule"] intValue];
    float pay = (self.all/cishu)*self.payCount;
    [params setObject:@"计次卡" forKey:@"cardType"];
    
    
    
    [params setObject:[[NSString alloc] initWithFormat:@"%.2f",pay] forKey:@"sum"];
    
    NSLog(@"paramer===%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"self.payCardArray%@", result);
         
         
         if ([result[@"result_code"] intValue]==1) {
             SoundPaly *sound=[SoundPaly sharedManager:@"sms-received1" type:@"caf"];
             [sound play];
             
             UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付成功" preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                 self.refresheDate();
                 PayVictoryVC *vc=[[PayVictoryVC alloc]init];
                 NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithDictionary:params];
                 [dictionary setObject:self.card_dic[@"store"] forKey:@"store"];
                 [dictionary setObject:[NSString stringWithFormat:@"%d",self.payCount] forKey:@"oldNeed"];
                 vc.dic=dictionary;
                 [self.navigationController pushViewController:vc animated:YES];
                 //POP
             }];
             
             [alertVC addAction:cancelAction];
             
             [self presentViewController:alertVC animated:YES completion:nil];
             

             
             
             
             //发送订单详情,获取店名
             
             //             [self getShopName];
         }
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error=%@", error);
     }];
    
}
//发送订单详情


-(void)getShopName{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/merchant/accountGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.card_dic[@"merchant"] forKey:@"muid"];
    [params setValue:@"store" forKey:@"type"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"result----%@",result);
        
        [self postOrderInfoWithShopName:result[@"store"]];
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

-(void)postOrderInfoWithShopName:(NSString*)shopName
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@UserType/user/cnCmt",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:self.card_dic[@"user"] forKey:@"uuid"];
    
    
    NSString *orderInfoMessage = [[NSString alloc]initWithFormat:@"%@%@结算次数%@%@",self.card_dic[@"merchant"],PAY_USCS,PAY_NP,textTF.text];
    
    
    int cishu =[self.card_dic[@"rule"] intValue];
    float pay = (self.all/cishu)*self.payCount;
    
    [params setObject:[[NSString alloc] initWithFormat:@"%.2f",pay] forKey:@"sum"];
    
    
    
    [params setObject:orderInfoMessage forKey:@"content"];
    NSDateFormatter* matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date  = [NSDate date];
    NSString *NowDate = [matter stringFromDate:date];
    [params setObject:NowDate forKey:@"datetime"];
    
    NSLog(@"发送订单---%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result)
     {
         NSLog(@"result%@", result);
         
         if ([result[@"result_code"] intValue]==1) {
             ;
             
             
         }
         else
             [self postOrderInfoWithShopName:shopName];
         
     } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         //         [self noIntenet];
         NSLog(@"%@", error);
     }];
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
-(void)dismissSelf{
    [self.navigationController popViewControllerAnimated:YES];
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
    
}
-(void)missPayAlert{
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [view removeFromSuperview];
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
    
    
//    self.QRView = [[UIView alloc]initWithFrame:CGRectMake(88, titleLab.bottom+30, whiteview.width-88*2, whiteview.width-88*2)];
//    [whiteview addSubview:_QRView];
//
//
//    [self creatQrCodeWithPayContent];

    
   
    
    
    
    //显示次数的label
    UITextField*countTF =[[UITextField alloc]initWithFrame:CGRectMake((whiteview.width-114)/2,titleLab.bottom+70, 120, 50)];
    countTF.textAlignment=1;
    countTF.backgroundColor=RGB(243, 73, 78);
    countTF.textColor=[UIColor whiteColor];
    countTF.text=@"0";
    countTF.delegate=self;
    countTF.layer.cornerRadius=15;
    countTF.clipsToBounds=YES;
    [whiteview addSubview:countTF];
    
    LZDButton *minusBtn = [LZDButton creatLZDButton];
    minusBtn.backgroundColor =[UIColor whiteColor];
    
    [minusBtn setImage:[UIImage imageNamed:@"-"] forState:UIControlStateNormal];
    [minusBtn setTitleColor:RGB(243, 73, 78) forState:UIControlStateNormal];
    minusBtn.titleLabel.font=[UIFont systemFontOfSize:32];
    minusBtn.frame=CGRectMake(countTF.left-20-40, countTF.top+5, 40, 40);
    minusBtn.layer.cornerRadius=20;
    minusBtn.clipsToBounds=YES;
    minusBtn.layer.borderWidth=1.0;
    minusBtn.layer.borderColor=[RGB(243, 73, 78) CGColor];
    [whiteview addSubview:minusBtn];
    
   
    
    //右加
    LZDButton *addBtn=[LZDButton creatLZDButton];
    
    addBtn.frame=CGRectMake(countTF.right+20, minusBtn.top, 40,40);
    [addBtn setTitleColor:RGB(243, 73, 78) forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    addBtn.titleLabel.font=[UIFont systemFontOfSize:32];
    addBtn.layer.cornerRadius=20;
    addBtn.clipsToBounds=YES;
    addBtn.layer.borderWidth=1.0;
    addBtn.layer.borderColor=[RGB(243, 73, 78) CGColor];
    addBtn.backgroundColor = [UIColor whiteColor];
    [whiteview addSubview:addBtn];
   
   
    
  
    

    
    minusBtn.block = ^(LZDButton *sender) {
        
        if (_number_count!=0) {
            _number_count--;
            countTF.text=[[NSString alloc]initWithFormat:@"%ld",_number_count];
            
           
            
        }
        
       
        
    };
  
    addBtn.block = ^(LZDButton *sender) {
        
        double price = [self.card_dic[@"price"] doubleValue];
        double card_remain = [self.card_dic[@"card_remain"] doubleValue];
        
        int rule =[self.card_dic[@"rule"] intValue];
        
        int time = (int)(card_remain/(price/rule));
        
        
        if (_number_count<time) {
            _number_count++;
            countTF.text=[[NSString alloc]initWithFormat:@"%ld",_number_count];
         
        }
        
    };
  
    
    
    LZDButton *creatbtn= [LZDButton creatLZDButton];
    creatbtn.frame = CGRectMake(70, countTF.bottom+85, whiteview.width-140, 45);
    creatbtn.layer.cornerRadius =5;
    creatbtn.layer.borderWidth = 1 ;
    creatbtn.layer.borderColor =RGB(243, 73, 78).CGColor;
    creatbtn.layer.masksToBounds = YES;
    [creatbtn setTitle:@"生成付款码" forState:0];
    [creatbtn setTitleColor:RGB(243, 73, 78) forState:0];
    creatbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [whiteview addSubview:creatbtn];

    creatbtn.block = ^(LZDButton *sender) {
      
        
        if (_number_count!=0) {
            PUSH(CountQRCodeVC)
            vc.card_dic =self.card_dic;
            vc.all = self.all;
            vc.number_count = self.number_count;
            vc.user = self.user;
            
            vc.resetNumBlock = ^{
                self.number_count= 0;
                
                countTF.text=[[NSString alloc]initWithFormat:@"%ld",_number_count];
                
                
            };
        }else{
            
            
            [self showHint:@"请选择支付次数!"];
        }
      
        
    };
    

    CGRect frame = whiteview.frame;
    
    frame.size.height = creatbtn.bottom +45;
    whiteview.frame = frame;
    
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
//-(void)creatQrCodeWithPayContent{
//
//    NSString *url = [NSString stringWithFormat:@"%@MerchantType/gather/getQrcode",BASEURL];
//
//    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//
//
//    NSMutableDictionary*muta_dic = [NSMutableDictionary dictionary];
//    [muta_dic setObject:self.user forKey:@"uuid"];
//    [muta_dic setValue:app.userInfoDic[@"nickname"] forKey:@"nickname"];
//    [muta_dic setValue:app.userInfoDic[@"headimage"] forKey:@"headimage"];
//
//
//    [muta_dic setValue:self.card_dic[@"merchant"] forKey:@"muid"];
//    [muta_dic setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
//    [muta_dic setObject:self.card_dic[@"card_level"] forKey:@"cardLevel"];
//
//    [muta_dic setValue:@"count_card" forKey:@"operate"];
//
//
//
//
//
//    int cishu =[self.card_dic[@"rule"] intValue];
//    float pay = (self.all/cishu)*self.number_count;
//    [muta_dic setObject:@"计次卡" forKey:@"cardType"];
//
//
//    [muta_dic setValue:[NSString stringWithFormat:@"%ld",self.number_count] forKey:@"num"];
//
//
//
//    [muta_dic setObject:[[NSString alloc] initWithFormat:@"%.2f",pay] forKey:@"sum"];
//
//
//    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
//    [paramer setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
//
//    [paramer setValue:[NSString dictionaryToJson:muta_dic] forKey:@"content"];
//
//
//    NSLog(@"======%@",paramer);
//    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
//
//        if ([result[@"result_code"] intValue]==1) {
//
//
//            NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
//
//            [m_dic setValue:result[@"order_id"] forKey:@"order_id"];
//            [m_dic setValue:self.card_dic[@"merchant"] forKey:@"muid"];
//
//            [m_dic setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
//
//            NSString  *codeString = [NSString dictionaryToJson:m_dic];
//
//
//            NSString *string=[NSString stringWithFormat:@"%@%@",HEADIMAGE,[app.userInfoDic objectForKey:@"headimage"]];
//
//
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//                NSURL * nurl1=[NSURL URLWithString:[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//                UIImage *img=  [UIImage imageWithData:[NSData dataWithContentsOfURL:nurl1]];
//
//                img = [NSString setThumbnailFromImage:img];
//
//                if (!img) {
//                    img = [UIImage imageNamed:@"app_icon3"];
//                }
//
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    [HGDQQRCodeView creatQRCodeWithURLString:codeString superView:self.QRView logoImage:img logoImageSize:CGSizeMake(_QRView.width*0.2, _QRView.width*0.2) logoImageWithCornerRadius:10];
//                });
//
//            }) ;
//
//
//
//        }
//
//        NSLog(@"=result=====%@",result);
//
//
//    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"=error=====%@",error);
//
//    }];
//
//
//
//}

@end
