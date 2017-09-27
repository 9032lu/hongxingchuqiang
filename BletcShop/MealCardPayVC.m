
//
//  MealCardPayVC.m
//  BletcShop
//
//  Created by Bletc on 2017/6/27.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "MealCardPayVC.h"
#import "CardDetailShowProdictCell.h"
#import "PayCustomView.h"
#import "AccessCodeVC.h"
#import "UIImageView+WebCache.h"
#import "ChangePayPassVC.h"
#import "PayVictoryVC.h"
#import "HGDQQRCodeView.h"
#import "ChosePayMealVC.h"

@interface MealCardPayVC ()<UITableViewDelegate,UITableViewDataSource,PayCustomViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    NSInteger selectRow;
    PayCustomView * Payview;
    LZDButton *oldBtn;
    UIView *topView;
}
@property (strong, nonatomic) IBOutlet UIView *twoBackView;
@property (nonatomic,strong)  UIView *QRView;

@property(nonatomic,strong) UIView *lineView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBackView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollviewContentWidth;
@property (weak, nonatomic) IBOutlet UITableView *table_view;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property(nonatomic,strong)NSArray *data_A;
@end

@implementation MealCardPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"套餐卡支付";
    LEFTBACK
    self.scrollviewContentWidth.constant = SCREENWIDTH*2;
    
    selectRow = -1;
    self.table_view.tableHeaderView = self.headerView;
    self.table_view.estimatedRowHeight = 100;
    self.table_view.rowHeight = UITableViewAutomaticDimension;
    
    [self getDataPost];
    
    
    
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_A.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardDetailShowProdictCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CardDetailShowCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CardDetailShowProdictCell" owner:self options:nil] firstObject];
        cell.selectImg.hidden = NO;
    }
    
    NSDictionary *dic = _data_A[indexPath.row];
    
    
    cell.productName.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
    cell.productPrice.text=[NSString stringWithFormat:@"%@元/次  (可用%@次)",dic[@"price"],dic[@"option_count"]];
    NSURL * nurl1=[[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@",PRODUCT_IMAGE,dic[@"image"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [cell.productImage sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
    
    
    
    if (indexPath.row ==selectRow) {
        cell.selectImg.image = [UIImage imageNamed:@"选中sex"];
    }else{
        cell.selectImg.image = [UIImage imageNamed:@"默认sex"];
 
    }
    return cell;
    
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectRow = indexPath.row;
    [self.table_view reloadData];
    
    
    
}
- (IBAction)goToBuy:(id)sender {
    
    
    if (selectRow<0) {
        [self showHint:@"请选择支付项目!"];
    }else{
       
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
            
            
            NSDictionary *dic =self.data_A[selectRow];
              [self payRequest:dic];
            
            
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

-(void)payRequest:(NSDictionary*)option_dic{
    NSLog(@"dic======%@",option_dic);
    NSString *url = [NSString stringWithFormat:@"%@UserType/MealCard/pay_v2",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer setValue:self.card_dic[@"merchant"] forKey:@"muid"];
    [paramer setValue:self.card_dic[@"card_code"] forKey:@"code"];
    [paramer setValue:option_dic[@"option_id"] forKey:@"option_id"];
    
    
    NSLog(@"=paramer====%@",paramer);

    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
    
        NSLog(@"-result---%@",result);
        if ([result[@"result_code"] intValue]==1) {
            
            
            SoundPaly *sound=[SoundPaly sharedManager:@"sms-received1" type:@"caf"];
            [sound play];
            
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                self.refresheDate();
                
                PayVictoryVC *vc=[[PayVictoryVC alloc]init];
                
                NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithDictionary:paramer];
                [dictionary setObject:self.card_dic[@"store"] forKey:@"store"];
                [dictionary setObject:option_dic[@"name"] forKey:@"oldNeed"];
                [dictionary setObject:self.card_dic[@"card_type"] forKey:@"cardType"];
                vc.dic=dictionary;
                
                [self.navigationController pushViewController:vc animated:YES];
                //[self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            
            [alertController addAction:sure];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
            

        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"=====%@",error);
    }];
    

}
-(void)getDataPost{
    
    
    //    [self showHudInView:self.view hint:@"加载中..."];;
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/MealCard/getOption",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    [paramer setValue:self.card_dic[@"merchant"] forKey:@"muid"];

    [paramer setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [paramer setValue:self.card_dic[@"card_code"] forKey:@"code"];

    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        [self hideHud];
        
        
        self.data_A = result;
        
        if (_data_A.count>0) {
            selectRow = 0;
            [self.table_view reloadData];

        }
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [self hideHud];

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
-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
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
    
    {
        
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        
        NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
        
        [m_dic setValue:@"null" forKey:@"order_id"];
        
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
    
    
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, self.QRView.bottom+30, whiteview.width, 1)];
    topline.backgroundColor = RGB(220,220,220);
    [whiteview addSubview:topline];
    
    
    UIScrollView *contentScrollView = [[UIScrollView alloc]init];
    [whiteview addSubview:contentScrollView];
    

    LZDButton *btn = [LZDButton creatLZDButton];
    
    btn.frame = CGRectMake(0, topline.bottom, whiteview.width, 100);
    
    [btn setTitle:@"选择消费套餐" forState:0];
    [btn setTitleColor:RGB(51,51,51) forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [whiteview addSubview:btn];
    
    btn.block = ^(LZDButton *sender) {
        
        for (UIView *view in contentScrollView.subviews) {
            [view removeFromSuperview];
        }
        
        sender.frame = CGRectMake(0, topline.bottom, whiteview.width, 100);
        [sender setTitle:@"选择消费套餐" forState:0];

        contentScrollView.frame = CGRectMake(0, topline.bottom, whiteview.width, 0);

        CGRect frame = whiteview.frame;
        frame.size.height = btn.bottom;
        whiteview.frame = frame;
        
        PUSH(ChosePayMealVC)
        vc.card_dic = _card_dic;
        vc.sendValueBlock = ^(NSArray *arr) {
            
            [self creatQrCodeWithPayContent:arr[0]];

            
            [sender setTitle:@"重置消费套餐" forState:0];


           
            
            for (NSInteger i = 0; i < arr.count; i ++) {
                NSDictionary *dic = arr[i];
               
                UIView *back_v = [[UIView alloc]initWithFrame:CGRectMake(0, i*50, whiteview.width, 50)];
                [contentScrollView addSubview:back_v];
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, back_v.height-1, back_v.width, 1)];
                line.backgroundColor = RGB(220,220,220);
                [back_v addSubview:line];
                
                
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 30, 30)];
                
                [back_v addSubview:imgView];
                NSURL * nurl1=[[NSURL alloc] initWithString:[[NSString stringWithFormat:@"%@%@",PRODUCT_IMAGE,dic[@"image"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imgView sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
                
                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(imgView.right+10, imgView.top, whiteview.width-(imgView.right+10), imgView.height)];
                title.textColor = RGB(51,51,51);
                title.font = [UIFont systemFontOfSize:13];
                title.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
                [back_v addSubview:title];
                
                
                
                contentScrollView.contentSize = CGSizeMake(0, back_v.bottom);
                
                CGFloat h = SCREENHEIGHT -topline.bottom- 10-45-64-50-10;
                
                
                contentScrollView.frame = CGRectMake(0, topline.bottom, whiteview.width, MIN(h, back_v.bottom));
                
                
                sender.frame = CGRectMake(0, contentScrollView.bottom, whiteview.width, 50);
                
                CGRect frame = whiteview.frame;
                frame.size.height = sender.bottom;
                whiteview.frame = frame;
                
            }
            
            
        };
        
        
    };
    
    
    CGRect frame = whiteview.frame;
    frame.size.height = btn.bottom;
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
-(void)creatQrCodeWithPayContent:(NSDictionary *)option_dic{
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/gather/getQrcode",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    NSMutableDictionary*muta_dic = [NSMutableDictionary dictionary];
    [muta_dic setValue:app.userInfoDic[@"uuid"] forKey:@"uuid"];
    [muta_dic setValue:app.userInfoDic[@"nickname"] forKey:@"nickname"];
    [muta_dic setValue:app.userInfoDic[@"headimage"] forKey:@"headimage"];
    
    
    [muta_dic setValue:self.card_dic[@"merchant"] forKey:@"muid"];
    [muta_dic setValue:self.card_dic[@"card_code"] forKey:@"code"];
    [muta_dic setValue:option_dic[@"option_id"] forKey:@"option_id"];

    [muta_dic setValue:option_dic[@"image"] forKey:@"option_image"];
    [muta_dic setValue:option_dic[@"name"] forKey:@"option_name"];

    [muta_dic setValue:@"meal_card" forKey:@"operate"];

    
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
