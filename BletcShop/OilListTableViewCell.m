//
//  OilListTableViewCell.m
//  BletcShop
//
//  Created by apple on 2017/8/7.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "OilListTableViewCell.h"

@implementation OilListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, self.shopStars.frame.size.width,self.shopStars.frame.size.height)];
    self.starRateView.userInteractionEnabled=NO;
    self.starRateView.isAnimation = YES;
    self.starRateView.rateStyle = IncompleteStar;
    self.starRateView.tag = 1;
    self.starRateView.currentScore=5.0;
    [self.shopStars addSubview:self.starRateView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
