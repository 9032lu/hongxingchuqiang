//
//  UserInfoHeaderCell.m
//  BletcShop
//
//  Created by Bletc on 2017/3/15.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "UserInfoHeaderCell.h"

@implementation UserInfoHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius=6.0f;
    self.bgView.clipsToBounds=YES;
    
    self.headImg.layer.cornerRadius = self.headImg.width/2;
    self.headImg.layer.masksToBounds = YES;
    self.contentView.backgroundColor=RGB(240, 240, 240);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
