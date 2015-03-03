//
//  ShowContentVC.m
//  WangKeJi
//
//  Created by wzzyinqiang on 15-1-28.
//  Copyright (c) 2015年 wzzyinqiang. All rights reserved.
//

#import "ShowContentVC.h"

@interface ShowContentVC ()

@end

@implementation ShowContentVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

    if (SYSTEMVERSION > 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    UILabel * firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + 20, ScreenWidth, 40)];
    firstLabel.text = @"旺客基介绍 习近平";
    [firstLabel setTextColor:[UIColor redColor]];
    [firstLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:firstLabel];

    UILabel * secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, firstLabel.frame.origin.y + firstLabel.frame.size.height, ScreenWidth - 20, 200)];
    secondLabel.text = AppDelegateInstance.jiameng;
    secondLabel.numberOfLines = 0;
    [self.view addSubview:secondLabel];
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
