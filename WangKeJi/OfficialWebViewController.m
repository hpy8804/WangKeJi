//
//  OfficialWebViewController.m
//  WangKeJi
//
//  Created by sven on 3/3/15.
//  Copyright (c) 2015 wzzyinqiang. All rights reserved.
//

#import "OfficialWebViewController.h"

#define kStrWebAddress @"http://www.wangkeji.com.cn"

@interface OfficialWebViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    UIActivityIndicatorView *_activityIndicatorView;
}
@end

@implementation OfficialWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customSelfUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customSelfUI
{
    [self.view setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    if (SYSTEMVERSION > 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-64)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:kStrWebAddress]];
    [self.view addSubview: _webView];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:request];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicatorView setFrame:CGRectMake(0, 0, 35, 35)];
    _activityIndicatorView.center = _webView.center;
    _activityIndicatorView.hidesWhenStopped = YES;
    [_webView addSubview:_activityIndicatorView];
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicatorView startAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicatorView stopAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
    [alterview show];
}

@end
