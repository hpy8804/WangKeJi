//
//  FootCell.m
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-30.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "FootCell.h"
#import "StartVC.h"
#import "StartSecondView.h"

@implementation FootCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CALayer * bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, 80, ScreenWidth, 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:210/255.0f alpha:1.0f].CGColor;
        [self.contentView.layer addSublayer:bottomBorder];

        _footImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        _footImageView.image = [UIImage imageNamed:@"loga.jpg"];
        [self.contentView addSubview:_footImageView];

        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_footImageView.frame.origin.x + _footImageView.frame.size.width + 10, 10, (ScreenWidth - (_footImageView.frame.origin.x + _footImageView.frame.size.width + 10) - 10) / 2, 20)];
        _titleLabel.text = @"大份套餐A";
        [self.contentView addSubview:_titleLabel];

        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width, 10, (ScreenWidth - (_footImageView.frame.origin.x + _footImageView.frame.size.width + 10) - 10) / 2, 20)];
        _priceLabel.text = @"$25.00";
        [_priceLabel setTextColor:[UIColor colorWithRed:207/255.0 green:39/255.0 blue:65/255.0 alpha:1.0]];
        [_priceLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_priceLabel];

        _reduceButton = [[UIButton alloc]initWithFrame:CGRectMake(_footImageView.frame.origin.x + _footImageView.frame.size.width + 10, _priceLabel.frame.origin.y + _priceLabel.frame.size.height + 10, 20, 20)];
        [_reduceButton setImage:[UIImage imageNamed:@"reduce.png"] forState:UIControlStateNormal];
        [_reduceButton addTarget:self action:@selector(reduceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_reduceButton];

        _numberTF = [[UITextField alloc]initWithFrame:CGRectMake(_reduceButton.frame.origin.x + _reduceButton.frame.size.width + 1, _priceLabel.frame.origin.y + _priceLabel.frame.size.height + 10, 40, 20)];
        _numberTF.text = @"1";
        [_numberTF setTextAlignment:NSTextAlignmentCenter];
        _numberTF.layer.borderWidth = 0.5f;
        _numberTF.userInteractionEnabled = NO;
        _numberTF.layer.borderColor = [[UIColor colorWithWhite:170/255.0 alpha:1.0]CGColor];
        [self.contentView addSubview:_numberTF];

        _addButton = [[UIButton alloc]initWithFrame:CGRectMake(_numberTF.frame.origin.x + _numberTF.frame.size.width + 1, _priceLabel.frame.origin.y + _priceLabel.frame.size.height + 10, 20, 20)];
        [_addButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addButton];

        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 50, _priceLabel.frame.origin.y + _priceLabel.frame.size.height + 10, 40, 30)];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_deleteButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:105/255.0 blue:0/255.0 alpha:1.0]];
        [self.contentView addSubview:_deleteButton];

        _tasteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _reduceButton.frame.size.height, 70, 20)];
        _tasteLabel.hidden = YES;
        [_tasteLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_tasteLabel setTextAlignment:NSTextAlignmentCenter];
        [_tasteLabel setTextColor:[UIColor redColor]];
        [_reduceButton addSubview:_tasteLabel];
    }
    return self;
}

- (void)addButtonClicked {
    int i = [_numberTF.text intValue];
    i++;
    _numberTF.text = [NSString stringWithFormat:@"%i",i];

    [AppDelegateInstance.foodNumberArray replaceObjectAtIndex:self.tag withObject:_numberTF.text];

    [(StartSecondView*)[AppDelegateInstance.startVC.viewArray objectAtIndex:1] setAllPrice];
}

- (void)reduceButtonClicked {
    int i = [_numberTF.text intValue];
    if (i > 1) {
        i--;
    }
    _numberTF.text = [NSString stringWithFormat:@"%i",i];

    [AppDelegateInstance.foodNumberArray replaceObjectAtIndex:self.tag withObject:_numberTF.text];

    [(StartSecondView*)[AppDelegateInstance.startVC.viewArray objectAtIndex:1] setAllPrice];
}

@end
