//
//  UserCell.m
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-30.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CALayer * bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, 40, ScreenWidth, 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:210/255.0f alpha:1.0f].CGColor;
        [self.contentView.layer addSublayer:bottomBorder];

        _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth - 20, 40)];
        [self.contentView addSubview:_textField];
    }
    return self;
}

@end
