//
//  ChosePayMealVC.m
//  BletcShop
//
//  Created by Bletc on 2017/9/25.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChosePayMealVC.h"
#import "CardDetailShowProdictCell.h"
#import "UIImageView+WebCache.h"
@interface ChosePayMealVC ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *table_view;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property(nonatomic,strong)NSArray *data_A;
@property(nonatomic,strong)NSMutableArray *send_A;
@property(nonatomic,strong)NSMutableDictionary*select_mut_D;
@end

@implementation ChosePayMealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.navigationItem.title = @"套餐卡支付";
    self.table_view.tableHeaderView = self.headerView;
    self.table_view.estimatedRowHeight = 100;
    self.table_view.rowHeight = UITableViewAutomaticDimension;
    
    [self getDataPost];

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
    
    
    
    if ([self.select_mut_D[[NSString stringWithFormat:@"%ld",indexPath.row]] boolValue]) {
        cell.selectImg.image = [UIImage imageNamed:@"选中sex"];
    }else{
        cell.selectImg.image = [UIImage imageNamed:@"默认sex"];
        
    }
    return cell;
    
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *row = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    if ([self.select_mut_D[row] boolValue]) {
        [self.select_mut_D setValue:@"0" forKey:row];

    }else{
        [self.select_mut_D setValue:@"1" forKey:row];

    }
    
    
    [self.table_view reloadData];
    
    
    
}
- (IBAction)goToBuy:(id)sender {
    
    
    
    [self.send_A removeAllObjects];
    
    for (int i = 0; i <_select_mut_D.count; i ++) {
        NSString *row = [NSString stringWithFormat:@"%d",i];

        if ([self.select_mut_D[row] boolValue]) {
            [self.send_A addObject:self.data_A[i]];
        }
    }
    
    
    
    if (self.send_A.count==0) {
        [self showHint:@"请选择支付项目!"];

    }else{
       
        NSLog(@"------%@",_send_A);
        
        self.sendValueBlock(self.send_A);
        POP
    }
    
    
  
    
    
    
    
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
            for (int i = 0; i <_data_A.count; i ++) {
                
              
                    [self.select_mut_D setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];

            }
            
            [self.table_view reloadData];
            
            
            
        }
        
        
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [self hideHud];
        
    }];
    
}

-(NSMutableArray *)send_A{
    if (!_send_A) {
        _send_A = [NSMutableArray array];
    }
    return _send_A;
}
-(NSMutableDictionary *)select_mut_D{
    if (!_select_mut_D) {
        _select_mut_D = [NSMutableDictionary dictionary];
    }
    return _select_mut_D;
}
-(NSArray *)data_A{
    if (!_data_A) {
        _data_A = [NSArray array];
    }
    return _data_A;
}
@end
