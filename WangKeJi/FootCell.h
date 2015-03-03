//
//  FootCell.h
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-30.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootCell : UITableViewCell

@property (nonatomic, strong) UIImageView * footImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UIButton * reduceButton;
@property (nonatomic, strong) UITextField * numberTF;
@property (nonatomic, strong) UIButton * addButton;
@property (nonatomic, strong) UIButton * deleteButton;
@property (nonatomic, strong) UILabel * tasteLabel;

@end
