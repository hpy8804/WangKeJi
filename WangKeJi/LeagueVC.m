//
//  LeagueVC.m
//  WangKeJi
//
//  Created by wzzyinqiang on 15-1-28.
//  Copyright (c) 2015年 wzzyinqiang. All rights reserved.
//

#import "LeagueVC.h"

@interface LeagueVC ()

@end

@implementation LeagueVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    if (SYSTEMVERSION > 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    UILabel * firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + 0, ScreenWidth, 100)];
    firstLabel.text = [NSString stringWithFormat:@"加盟电话\n%@\n官方网站\nwww.wangkeji.com.cn",AppDelegateInstance.phone];
    [firstLabel setTextAlignment:NSTextAlignmentCenter];
    firstLabel.numberOfLines = 0;
    [self.view addSubview:firstLabel];

//    UILabel * secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, firstLabel.frame.origin.y + firstLabel.frame.size.height + 20, ScreenWidth - 20, 40)];
//    [secondLabel setFont:[UIFont systemFontOfSize:16.0f]];
//    [secondLabel setTextAlignment:NSTextAlignmentCenter];
//    secondLabel.text = @"官方网站\nwww.wangkeji.com.cn";
//    secondLabel.numberOfLines = 0;
//    [self.view addSubview:secondLabel];
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
