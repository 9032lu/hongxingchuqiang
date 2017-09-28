//
//  CountQRCodeVC.m
//  BletcShop
//
//  Created by Bletc on 2017/9/27.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "CountQRCodeVC.h"
#import "HGDQQRCodeView.h"

@interface CountQRCodeVC ()
@property (nonatomic,strong)  UIView *QRView;

@end

@implementation CountQRCodeVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    LZDButton *back =[LZDButton creatLZDButton];
    back.frame = CGRectMake(13, 31, 10, 20);
    [back setImage:[UIImage imageNamed:@"返回箭头"] forState:0];
    back.block = ^(LZDButton *sender) {
        POP
        
    };
    
    [self.view addSubview:back];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    
    [self creatCodeView];

}


-(void)creatCodeView{
    
    
    
    
    
    UIView *whiteview = [[UIView  alloc]initWithFrame:CGRectMake(0, 10+64, SCREENWIDTH-26, SCREENWIDTH-26)];
    whiteview.backgroundColor = [UIColor whiteColor];
    whiteview.layer.cornerRadius =6;
    [self.view addSubview:whiteview];
    
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 31, whiteview.width, 14)];
    titleLab.text = @"付款二维码";
    titleLab.textAlignment= NSTextAlignmentCenter;
    titleLab.textColor = RGB(51,51,51);
    titleLab.font = [UIFont systemFontOfSize:15];
    [whiteview addSubview:titleLab];
    
    
    self.QRView = [[UIView alloc]initWithFrame:CGRectMake(88, titleLab.bottom+30, whiteview.width-88*2, whiteview.width-88*2)];
    [whiteview addSubview:_QRView];
    
    
    
    
    
//    UILabel *title_lab_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 31+self.QRView.bottom, whiteview.width, 16)];
//    title_lab_1.text = @"体验金额";
//    title_lab_1.textAlignment= NSTextAlignmentCenter;
//    title_lab_1.textColor = RGB(51,51,51);
//    title_lab_1.font = [UIFont systemFontOfSize:15];
//    [whiteview addSubview:title_lab_1];
    
    
    UILabel *title_lab_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 31+self.QRView.bottom, whiteview.width, 15)];
    title_lab_2.text = [NSString stringWithFormat:@"%ld次",self.number_count];
    title_lab_2.textAlignment= NSTextAlignmentCenter;
    title_lab_2.textColor = RGB(51,51,51);
    title_lab_2.font = [UIFont boldSystemFontOfSize:20];
    [whiteview addSubview:title_lab_2];
    
    
    
   
    
    
    LZDButton *resetBtn = [LZDButton creatLZDButton];
    
    resetBtn.frame = CGRectMake(whiteview.width/2-60, title_lab_2.bottom +75, 120, 45);
    [resetBtn setTitle:@"重置付款次数" forState:0];
    [resetBtn setTitleColor:RGB(51, 51, 51) forState:0];
    
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [whiteview addSubview:resetBtn];
    
    
    
    resetBtn.block = ^(LZDButton *sender) {
        POP;
        self.resetNumBlock();
    };
    
    
    
    
    
    
    CGRect frame = whiteview.frame;
    frame.size.height = resetBtn.bottom+21;
    whiteview.frame = frame;
    
    
    
    
    [self creatQrCodeWithPayContent];
    
    
}


/*
 生成订单信息,生成二维码
 **/
-(void)creatQrCodeWithPayContent{
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/gather/getQrcode",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    NSMutableDictionary*muta_dic = [NSMutableDictionary dictionary];
    [muta_dic setObject:self.user forKey:@"uuid"];
    [muta_dic setValue:app.userInfoDic[@"nickname"] forKey:@"nickname"];
    [muta_dic setValue:app.userInfoDic[@"headimage"] forKey:@"headimage"];
    
    
    [muta_dic setValue:self.card_dic[@"merchant"] forKey:@"muid"];
    [muta_dic setObject:self.card_dic[@"card_code"] forKey:@"cardCode"];
    [muta_dic setObject:self.card_dic[@"card_level"] forKey:@"cardLevel"];
    
    [muta_dic setValue:@"count_card" forKey:@"operate"];
    
    
    
    
    
    int cishu =[self.card_dic[@"rule"] intValue];
    float pay = (self.all/cishu)*self.number_count;
    [muta_dic setObject:@"计次卡" forKey:@"cardType"];
    
    
    [muta_dic setValue:[NSString stringWithFormat:@"%ld",self.number_count] forKey:@"num"];
    
    
    
    [muta_dic setObject:[[NSString alloc] initWithFormat:@"%.2f",pay] forKey:@"sum"];
    
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [paramer setValue:[NSString dictionaryToJson:muta_dic] forKey:@"content"];
    
    
    NSLog(@"======%@",paramer);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        if ([result[@"result_code"] intValue]==1) {
            
            
            NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
            
            [m_dic setValue:result[@"order_id"] forKey:@"order_id"];
            [m_dic setValue:self.card_dic[@"merchant"] forKey:@"muid"];
            
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
