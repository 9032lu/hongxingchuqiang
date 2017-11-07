//
//  SignViewController.m
//  BletcShop
//
//  Created by Bletc on 2017/9/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "SignViewController.h"

@interface SignViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *resultlab;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.text = [NSString getRandomCode];

}
- (IBAction)clickBtn:(UIButton *)sender {
    
    NSString *url = @"http://192.168.0.168/cnconsum/app/extra/operate/enter";
    
    NSString *randCode =self.textField.text;
    NSString *timestap = [NSString getCurrentTimestamp];
    
    
    NSMutableDictionary*pa = [NSMutableDictionary dictionary];
    [pa setValue:randCode forKey:@"randCode"];
    [pa setValue:timestap forKey:@"timestap"];
    [pa setValue:[NSString getSecretStringWithRandCode:randCode andTimestamp:timestap] forKey:@"sign"];

    NSString *s = [NSString dictionaryToJson:pa];
    
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setValue:s forKey:@"params"];
    
    
    NSLog(@"==%@==%@",paramer,url);
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        
        [self showHint:[NSString dictionaryToJson:result]];
        NSLog(@"=====%@",result);
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showHint:error.description];

        NSLog(@"error=====%@",error);

    }];

}



@end
