//
//  ShowContentVC.h
//  WangKeJi
//
//  Created by wzzyinqiang on 15-1-28.
//  Copyright (c) 2015年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"

@interface ShowContentVC : UIViewController<ServiceHelperDelegate, UIWebViewDelegate>
@property (nonatomic, strong) ServiceHelper * helper;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end
