//
//  LeagueVC.m
//  WangKeJi
//
//  Created by wzzyinqiang on 15-1-28.
//  Copyright (c) 2015年 wzzyinqiang. All rights reserved.
//

#import "LeagueVC.h"
#import "OfficialWebViewController.h"

#define kBtnCalltag 100
#define kBtnWebtag 200
#define kStrCallNum AppDelegateInstance.phone
#define kStrWebAddress @"www.wangkeji.com.cn"

@interface LeagueVC ()

@end

@implementation LeagueVC
@synthesize myWebView;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    if (SYSTEMVERSION > 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self customSelfUI];
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customSelfUI
{
    /*******************加盟电话********************/
    UILabel *labelSale = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 70, 30)];
    labelSale.font = [UIFont boldSystemFontOfSize:16.0];
    labelSale.text = @"加盟电话:";
    [self.view addSubview:labelSale];
    UIButton *btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCall setFrame:CGRectMake(80, 15, 200, 30)];
    [btnCall setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnCall setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [btnCall setTitle:kStrCallNum forState:UIControlStateNormal];
    btnCall.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnCall.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [btnCall addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btnCall.tag = kBtnCalltag;
    [self.view addSubview:btnCall];
    //下划线
    UIView *viewForbtnCall = [[UIView alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(btnCall.frame), 120, 1)];
    viewForbtnCall.backgroundColor = [UIColor grayColor];
    [self.view addSubview:viewForbtnCall];
    
    /*******************官方网站********************/
    UILabel *labelSupport = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 70, 30)];
    labelSupport.font = [UIFont boldSystemFontOfSize:16.0];
    labelSupport.text = @"官方网站:";
    [self.view addSubview:labelSupport];
    
    UIButton *btnWeb = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnWeb setFrame:CGRectMake(80, 50, 200, 30)];
    [btnWeb setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnWeb setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [btnWeb setTitle:kStrWebAddress forState:UIControlStateNormal];
    btnWeb.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnWeb.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    [btnWeb addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btnWeb.tag = kBtnWebtag;
    [self.view addSubview:btnWeb];
    //下划线
    UIView *viewForbtnEmailSupport = [[UIView alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(btnWeb.frame), 170, 1)];
    viewForbtnEmailSupport.backgroundColor = [UIColor grayColor];
    [self.view addSubview:viewForbtnEmailSupport];
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.myWebView = webView;
}

- (void)handleBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case kBtnCalltag:
        {
            NSString *telStr=[[NSString alloc]initWithFormat:@"%@%@",@"tel://",kStrCallNum];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:telStr]];
            [myWebView loadRequest:request];
        }
            break;
        case kBtnWebtag:
        {
            OfficialWebViewController *vcOfficialWeb = [[OfficialWebViewController alloc] init];
            [self.navigationController pushViewController:vcOfficialWeb animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
