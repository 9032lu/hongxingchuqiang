//
//  MyOrderDetailVC.m
//  BletcShop
//
//  Created by Bletc on 2016/11/22.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "MyOrderDetailVC.h"

@interface MyOrderDetailVC ()

@end

@implementation MyOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.navigationItem.title = @"交易详情";
    self.view.backgroundColor = RGB(240, 240, 240);
   [self createDemoView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (void)createDemoView
{
    NSArray *infoArray = self.data_A;
    
    NSDictionary *dic = self.order_dic;
    
    NSLog(@"dic--_%@",dic);
    UIScrollView *demoView = [[UIScrollView alloc] init];
    demoView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64);
    
    
    CGFloat hight_demo = 0.0;
    demoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:demoView];
    

    
    if (infoArray.count>0) {
        //self.payMoney = 0.0;
        
        UILabel *labelShop = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 44)];
        labelShop.text = self.pay_type_s;
        labelShop.textAlignment = NSTextAlignmentLeft;
        labelShop.font = [UIFont systemFontOfSize:17];
        labelShop.textColor = RGB(51,51,51);

        [demoView addSubview:labelShop];
        UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, labelShop.top, SCREENWIDTH-120, 44)];
        shopNameLabel.textColor = RGB(51,51,51);

        shopNameLabel.text = [NSString stringWithFormat:@"%@元",dic[@"sum"]];
        
        //label.text = @"修改昵称";
        shopNameLabel.textAlignment = NSTextAlignmentRight;
        shopNameLabel.font = [UIFont systemFontOfSize:23];
        [demoView addSubview:shopNameLabel];
        //NSString *allPrice = [[NSString alloc]init];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(12, 44, SCREENWIDTH-24, 1)];
        line1.backgroundColor = RGB(234,234,234);
        [demoView addSubview:line1];
        
        for(int i=0; i<infoArray.count; i++) {
            //获取每个数组里的项目和价格-(项目sm价格)
            
            {
                NSDictionary *string_dic = infoArray[i];//项目sm价格
                
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 45*(i+1), 120, 44)];
                label.textColor = RGB(51,51,51);

                label.text = string_dic[@"item"];
                label.textAlignment = NSTextAlignmentLeft;
                label.font = [UIFont systemFontOfSize:16];
                [demoView addSubview:label];
                
                UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, label.top, SCREENWIDTH-120, 44)];
                priceLabel.textAlignment = NSTextAlignmentRight;
                priceLabel.font = [UIFont systemFontOfSize:16];
                [demoView addSubview:priceLabel];
                priceLabel.textColor = RGB(51,51,51);

                
                priceLabel.text = [NSString stringWithFormat:@"%@",string_dic[@"value"]];
                
                
                
            }
            //self.payMoney = self.payMoney+=[allPrice floatValue];
            
        }
        
        
        UILabel *state_lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 45*(infoArray.count+1), 80, 44)];
        state_lab.text = @"交易状态";
        state_lab.textAlignment = NSTextAlignmentLeft;
        state_lab.font = [UIFont systemFontOfSize:16];
        state_lab.textColor = RGB(51,51,51);
        [demoView addSubview:state_lab];
        
        UILabel *state_lab1 = [[UILabel alloc]initWithFrame:CGRectMake(100, state_lab.top, SCREENWIDTH-120, 44)];
        state_lab1.textColor = RGB(51,51,51);
        
        state_lab1.text = @"已完成" ;
        state_lab1.textAlignment = NSTextAlignmentRight;
        state_lab1.font = [UIFont systemFontOfSize:16];
        [demoView addSubview:state_lab1];

        
        //日期时间
        
        
        UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(20, state_lab.bottom+1, 80, 44)];
        labelTime.text = @"交易时间";
        labelTime.textAlignment = NSTextAlignmentLeft;
        labelTime.font = [UIFont systemFontOfSize:16];
        labelTime.textColor = RGB(51,51,51);
        [demoView addSubview:labelTime];
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, labelTime.top, SCREENWIDTH-120, 44)];
        timeLabel.textColor = RGB(51,51,51);

        timeLabel.text = dic[@"datetime"] ;
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont systemFontOfSize:16];
        [demoView addSubview:timeLabel];
        //状态
        UILabel *labelState = [[UILabel alloc]initWithFrame:CGRectMake(20, labelTime.bottom+1, 80, 44)];
        labelState.text = @"支付方式";
        labelState.textColor = RGB(51,51,51);

        labelState.textAlignment = NSTextAlignmentLeft;
        labelState.font = [UIFont systemFontOfSize:16];
        [demoView addSubview:labelState];
        UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, labelState.top, SCREENWIDTH-120, 44)];
//        if ([self.pay_type_s isEqualToString:@"计次数量"]) {
//            stateLabel.text = @"计次卡支付" ;
//
//        }else{
//            stateLabel.text = @"储值卡支付" ;
// 
//        }
        stateLabel.text = @"会员卡支付";

        stateLabel.textColor = RGB(51,51,51);
        //self.payShopName = [[infoArrayOr objectAtIndex:1] substringToIndex:range.location];
        stateLabel.textAlignment = NSTextAlignmentRight;
        stateLabel.font = [UIFont systemFontOfSize:16];
        [demoView addSubview:stateLabel];
        
        demoView.contentSize =CGSizeMake(0,stateLabel.bottom);
        hight_demo = MIN(stateLabel.bottom, SCREENHEIGHT-64);

    }
    
    demoView.frame = CGRectMake(0, 0, SCREENWIDTH, hight_demo);

    //NSLog(@"zzzzzzzzzzzzzzzzz%f",self.payMoney);
}



@end
