//
//  FirstCell.m
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "FirstCell.h"

@implementation FirstCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CALayer * bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, 80, ScreenWidth, 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:210/255.0f alpha:1.0f].CGColor;
        [self.contentView.layer addSublayer:bottomBorder];

        _foodImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        _foodImageView.layer.cornerRadius = 5.0f;
        _foodImageView.image = [UIImage imageNamed:@"loga.jpg"];
        [self.contentView addSubview:_foodImageView];

        _titleTF = [[UITextField alloc]initWithFrame:CGRectMake(_foodImageView.frame.origin.x + _foodImageView.frame.size.width + 10, 10 + 5, (ScreenWidth - (_foodImageView.frame.origin.x + _foodImageView.frame.size.width + 10) - 10) / 2, 20)];
        [_titleTF setFont:[UIFont systemFontOfSize:20.0f]];
        _titleTF.text = @"大份套餐A";
        _titleTF.userInteractionEnabled = NO;
        [self.contentView addSubview:_titleTF];

        _priceTF = [[UITextField alloc]initWithFrame:CGRectMake(_titleTF.frame.origin.x + _titleTF.frame.size.width, 10 + 5, (ScreenWidth - (_foodImageView.frame.origin.x + _foodImageView.frame.size.width + 10) - 10) / 2, 20)];
        [_priceTF setFont:[UIFont systemFontOfSize:20.0f]];
        _priceTF.text = @"$25.00";
        [_priceTF setTextAlignment:NSTextAlignmentRight];
        [_priceTF setTextColor:[UIColor redColor]];
        _priceTF.userInteractionEnabled = NO;
        [self.contentView addSubview:_priceTF];

        _contentTV = [[UITextView alloc]initWithFrame:CGRectMake(_foodImageView.frame.origin.x + _foodImageView.frame.size.width + 6, _titleTF.frame.origin.y + _titleTF.frame.size.height + 0, ScreenWidth - (_foodImageView.frame.origin.x + _foodImageView.frame.size.width + 10) - 10, 35)];
        _contentTV.text = @"黄焖鸡(大份)+米饭1份+韩式秘制酱汤1份";
        _contentTV.userInteractionEnabled = NO;
        [self.contentView addSubview:_contentTV];
    }
    return self;
}

@end
