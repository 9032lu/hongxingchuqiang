//
//  CardVipController.m
//  BletcShop
//
//  Created by Yuan on 16/1/26.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "CardVipController.h"
#import "CardVipCell.h"
#import "UIImageView+WebCache.h"
#import "CardManagerViewController.h"
#import "MoneyPAYViewController.h"
#import "CountPAYViewController.h"

#import "MealCardPayVC.h"//套餐卡支付
#import "ExperienceCardGoToPayVC.h" //体验卡支付

#import "MealAndExpCardManageVC.h" //套餐卡,体验卡,管理页面
#import "VipCardHomeTableViewCell.h"


#import "ShareCardManageVC.h"
#import "OilCardManagerVC.h"

@interface CardVipController()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)UITableView *Cardtable;
@property (nonatomic,retain)NSMutableArray *vipCardArray;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray  *wholeDataArray;

@property(nonatomic,strong)NSArray *kindArray;
@end

@implementation CardVipController
{
    UIView *noticeLine;
    UIScrollView *topBackView;
     UIButton* title_btn;
    
    UILabel *placeHoderlab;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postRequestVipCard];

    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.title = @"我的会员卡";
    
    LEFTBACK
    topBackView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 92)];
    topBackView.backgroundColor=[UIColor whiteColor];
    topBackView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:topBackView];

    [self showLoadingView];
    
    [self initCatergray];
    [self _inittable];
    


}
//卡分类
-(void)initCatergray{
    
    for (int i=0; i<self.kindArray.count; i++) {
        UIButton *Catergray=[UIButton buttonWithType:UIButtonTypeCustom];
        Catergray.frame=CGRectMake(1+i%_kindArray.count*((SCREENWIDTH-5)/4+1), 0, (SCREENWIDTH-5)/4, 92);
        Catergray.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        //[Catergray setTitle:_kindArray[i][@"mainTitle"] forState:UIControlStateNormal];
        [Catergray setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        Catergray.tag=666+i;
        [topBackView addSubview:Catergray];
        [Catergray addTarget:self action:@selector(changeTitleColorAndRefreshCard:) forControlEvents:UIControlEventTouchUpInside];
        if (i!=_kindArray.count-1) {
            if (i==0) {
                // [Catergray setTitleColor:RGB(24, 190, 245) forState:UIControlStateNormal];
                noticeLine=[[UIView alloc]init];
                noticeLine.bounds=CGRectMake(0, 0, (SCREENWIDTH-105)/4, 2);
                noticeLine.center=CGPointMake(Catergray.center.x, Catergray.center.y+43);
                noticeLine.backgroundColor=RGB(243, 73, 78);
                [topBackView addSubview:noticeLine];
                
                title_btn = Catergray;
            }
            
        }
        
        UILabel *label=[[UILabel alloc]init];
        label.bounds=CGRectMake(0, 0, 38, 38);
        label.center=CGPointMake(Catergray.center.x, Catergray.center.y-13);
        label.font=[UIFont systemFontOfSize:20.0f];
        label.text=_kindArray[i][@"title"];
        label.layer.cornerRadius=19.0f;
        label.layer.borderWidth=1.5f;
        label.textColor=[UIColor colorWithHexString:_kindArray[i][@"color"] alpha:1];
        label.textAlignment=NSTextAlignmentCenter;
        label.layer.borderColor=[UIColor colorWithHexString:_kindArray[i][@"color"] alpha:1].CGColor;
        label.clipsToBounds=YES;
        [topBackView addSubview:label];
        topBackView.contentSize = CGSizeMake(Catergray.right+5, 0);
        
        UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(1+i%_kindArray.count*((SCREENWIDTH-5)/4+1), label.bottom+11, (SCREENWIDTH-5)/4, 14)];
        titleLable.font=[UIFont systemFontOfSize:14.0f];
        titleLable.textAlignment=NSTextAlignmentCenter;
        titleLable.text=_kindArray[i][@"mainTitle"];
        [topBackView addSubview:titleLable];
        
        [topBackView bringSubviewToFront:Catergray];
        
    }
    
}

-(void)changeTitleColorAndRefreshCard:(UIButton *)sender{
    
    title_btn = sender;

    
    if (sender.tag-666==0) {
        NSInteger count_sum = 0;
        for (NSArray *arr in self.wholeDataArray) {
            count_sum +=arr.count;
            
        }
        
        if (count_sum ==0) {
            placeHoderlab.hidden = NO;
        }else{
            placeHoderlab.hidden = YES;;

        }
    
    }else{
        
        
        if ([self.wholeDataArray[sender.tag-666-1] count]==0) {
            placeHoderlab.hidden = NO;
        }else{
            placeHoderlab.hidden = YES;
            
        }

        
    }
    
    [self.Cardtable reloadData];

    noticeLine.center=CGPointMake(sender.center.x, sender.center.y+43);
    noticeLine.backgroundColor=[UIColor colorWithHexString:_kindArray[sender.tag-666][@"color"]];
    for (int i=0; i<_kindArray.count; i++) {
        UIButton*button=(UIButton *)[topBackView viewWithTag:666+i];
        if (button.tag==sender.tag) {
            [button setTitleColor:RGB(24, 190, 245) forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    [self hintLoadingView];

}
-(void)postRequestVipCard
{
    
    NSString *url = [NSString stringWithFormat:@"%@UserType/card/multiGet",BASEURL];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.userInfoDic[@"uuid"] forKey:@"uuid"];
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        
        NSArray *value_A = result[@"value"];
        NSArray *count_A = result[@"count"];
        NSArray *meal_A = result[@"meal"];
        NSArray *experience_A = result[@"experience"];
        NSArray *share_A = result[@"share"];
        NSArray *oil_A = [NSArray arrayWithObject:@{@"store":@"商消乐",@"card_temp_color":@"#7B68EE",@"card_type":@"加油卡",@"card_remain":@"1000",@"store":@"商消乐"}];
        
        [self.wholeDataArray removeAllObjects];
        [self.wholeDataArray addObjectsFromArray:@[value_A,count_A,meal_A,experience_A,share_A,oil_A]];
        
        
        if (value_A.count+count_A.count+meal_A.count+experience_A.count+share_A.count+oil_A.count==0 ) {
            placeHoderlab.hidden= NO;
        }else{
            placeHoderlab.hidden= YES;
 
        }
       
        [self changeTitleColorAndRefreshCard:title_btn];
        

        NSLog(@"result===%@", result);
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hintLoadingView];

//        [self showHint:@"服务器出错了..."];
        NSLog(@"%@", error);
    }];
    
}


//创建TableView
-(void)_inittable
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 92+10, SCREENWIDTH, SCREENHEIGHT-64-92-10) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.bounces = YES;
    self.Cardtable = table;
    [self.view addSubview:table];
    
    
    placeHoderlab = [[UILabel alloc]init];
    placeHoderlab.text = @"您暂时还没有会员卡哦！";
    placeHoderlab.textAlignment = NSTextAlignmentCenter;
    placeHoderlab.font = [UIFont systemFontOfSize:13];
    placeHoderlab.textColor = RGB(175,174,174);
    placeHoderlab.bounds = CGRectMake(0, 0, SCREENWIDTH, 13);
    placeHoderlab.center = self.view.center;
    placeHoderlab.hidden = YES;
    [self.view addSubview:placeHoderlab];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.wholeDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"[self.wholeDataArray[section] count]----%ld",[self.wholeDataArray[section] count]);
    
    if (title_btn.tag==666) {
        
         return [self.wholeDataArray[section] count];

    }else{
        
        if (title_btn.tag-666-1 ==section) {
            
            
            return [self.wholeDataArray[section] count];

        }else{
            return 0;
        }
    }
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH-24)*105/350+5;//185;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (title_btn.tag==666) {
        return 0.01;//10;
        
    }else{
        
        if (title_btn.tag-666-1 ==section) {
            return 0.01;//10;
            
        }else{
            return 0.01;
        }
    }

    
//    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    static NSString *resuseIdentify=@"VipCardHomeCell";
    VipCardHomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuseIdentify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VipCardHomeTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    
    NSDictionary *dic =[self.wholeDataArray[indexPath.section] objectAtIndex:indexPath.row];
    
    if (dic) {
        
        cell.vipCardBgImage.backgroundColor=[UIColor colorWithHexString:dic[@"card_temp_color"]];
        
        cell.shopName.text=[NSString getTheNoNullStr:dic[@"store"] andRepalceStr:@""];
        
        
        cell.cardStyleAndLevel.text = [NSString stringWithFormat:@"%@(%@)",dic[@"card_type"],dic[@"card_level"]];
        
        cell.tradeLab.text = [NSString getTheNoNullStr:dic[@"trade"] andRepalceStr:@""];
        //套餐卡 体验卡
        if ([dic[@"card_type"] isEqualToString:@"套餐卡"] || [dic[@"card_type"] isEqualToString:@"体验卡"] || [dic[@"card_type"] isEqualToString:@"加油卡"]) {
            
            cell.cardStyleAndLevel.text = [NSString stringWithFormat:@"%@",dic[@"card_type"]];
            
        }
        
        
        

        
    }
    
    return cell;

}

-(void)cardPayManager:(LZDButton *)sender{
    
    NSDictionary *dic = _wholeDataArray[sender.section][sender.row];
    
    
    if ([dic[@"state"] isEqualToString:@"transfer"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"会员卡转让中" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }else{
        if (sender.section==0) {
            PUSH(MoneyPAYViewController)
            vc.refresheDate = ^{
                [self postRequestVipCard];
            };

            vc.card_dic = dic;
            
           
        }else if (sender.section==1){
            
            PUSH(CountPAYViewController)
            vc.card_dic = dic;
            vc.refresheDate = ^{
                [self postRequestVipCard];
            };

            
        }
        else if (sender.section==2){
            
            PUSH(MealCardPayVC)
            vc.card_dic = dic;
            vc.refresheDate = ^{
                [self postRequestVipCard];
            };
            
            
        }else if (sender.section==3){
            
            PUSH(ExperienceCardGoToPayVC)
            vc.card_dic = dic;
            vc.refresheDate = ^{
                [self postRequestVipCard];
            };
            

            
        }
        else if (sender.section==4){
            
            
            if ([dic[@"card_type"] isEqualToString:@"储值卡"]) {
                PUSH(MoneyPAYViewController)
                vc.refresheDate = ^{
                    [self postRequestVipCard];
                };
                
                vc.card_dic = dic;

            }
            
            if ([dic[@"card_type"] isEqualToString:@"计次卡"]) {
                PUSH(CountPAYViewController)
                vc.refresheDate = ^{
                    [self postRequestVipCard];
                };
                
                vc.card_dic = dic;
                
            }

            
            
        }

    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic =[self.wholeDataArray[indexPath.section] objectAtIndex:indexPath.row];

    if (indexPath.section ==0 || indexPath.section==1) {
        

        PUSH(CardManagerViewController)
        
        vc.card_dic = dic;
        vc.refresheDate = ^{
            
            [self postRequestVipCard];
            
        };

        
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        appdelegate.payCardType =dic[@"card_level"];

        appdelegate.cardInfo_dic =dic;
        
        
    }else if(indexPath.section ==2 || indexPath.section==3) {
    
    PUSH(MealAndExpCardManageVC)
    
        vc.card_dic = dic;
        
        vc.refresheDate = ^{
            
            [self postRequestVipCard];

        };
        
    }else if (indexPath.section ==4){
        
        AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        appdelegate.payCardType =dic[@"card_level"];
        
        appdelegate.cardInfo_dic =dic;

        
        PUSH(ShareCardManageVC)
        
        vc.card_dic = dic;
        
        vc.refresheDate = ^{
            
            [self postRequestVipCard];
            
        };
    }else if (indexPath.section==5){
        
        
        PUSH(OilCardManagerVC)
        vc.card_dic = dic;
    }
    
    
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
    return UITableViewCellEditingStyleDelete;
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==self.wholeDataArray.count-1) {
        return NO;
    }else
        
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section !=self.wholeDataArray.count-1) {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            
            NSString *url = @"http://101.201.100.191/cnconsum/App/UserType/card/del";
            
            NSDictionary *dic =[self.wholeDataArray[indexPath.section] objectAtIndex:indexPath.row];

            NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
            [paramer setValue:dic[@"merchant"] forKey:@"muid"];
            [paramer setValue:dic[@"user"] forKey:@"uuid"];
            [paramer setValue:dic[@"card_code"] forKey:@"cardCode"];
            [paramer setValue:dic[@"card_level"] forKey:@"cardLevel"];
            [paramer setValue:dic[@"card_type"] forKey:@"cardType"];

            [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
                NSLog(@"===UITableViewCellEditingStyleDelete=====%@",result);

                
                [self postRequestVipCard];

                
            } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"===UITableViewCellEditingStyleDelete====error=%@",error);

            }];

            
        }
        
    }
    
}

-(NSArray *)kindArray{
    if (!_kindArray) {
        _kindArray = @[@{@"mainTitle":@"全部",@"title":@"全",@"color":@"#F3494E"},@{@"mainTitle":@"储值卡",@"title":@"储",@"color":@"#40B9B0"},@{@"mainTitle":@"计次卡",@"title":@"次",@"color":@"#BD4EFD"},@{@"mainTitle":@"套餐卡",@"title":@"餐",@"color":@"#FF712F"},@{@"mainTitle":@"体验卡",@"title":@"验",@"color":@"#1CB5FA"},@{@"mainTitle":@"分享卡",@"title":@"享",@"color":@"#FF5885"},@{@"mainTitle":@"加油卡",@"title":@"油",@"color":@"#40B9B0"}];
    }
    return _kindArray;
}
-(NSMutableArray *)wholeDataArray{
    if (!_wholeDataArray) {
        _wholeDataArray = [NSMutableArray array];
        
    }
    return _wholeDataArray;
}
@end
