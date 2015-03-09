//
//  ShowContentVC.m
//  WangKeJi
//
//  Created by wzzyinqiang on 15-1-28.
//  Copyright (c) 2015年 wzzyinqiang. All rights reserved.
//

#import "ShowContentVC.h"
#import "SoapHelper.h"

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
    
    _helper = [[ServiceHelper alloc]initWithDelegate:self];
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:nil methodName:@"GetContent"];
    [_helper asynServiceMethod:@"GetContent" soapMessage:soapMsg];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  ScreenHeight - 64)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicatorView setFrame:CGRectMake(0, 0, 35, 35)];
    _activityIndicatorView.center = _webView.center;
    _activityIndicatorView.hidesWhenStopped = YES;
    [_webView addSubview:_activityIndicatorView];
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ServiceHelperDelegate
-(void)finishSuccessRequest:(NSString*)xml {
    [_webView loadHTMLString:xml baseURL:nil];
}

-(void)finishFailRequest:(NSError*)error {

}

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

@end
