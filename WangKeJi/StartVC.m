//
//  StartVC.m
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "StartVC.h"
#import "StartFirstView.h"
#import "StartSecondView.h"
#import "StartThirdView.h"
#import "StartFourthView.h"
#import "PlaceChooseVC.h"

#define HEIGHT_VIEW 0

#define HEIGHT_VIEW_IOS6 64

@interface StartVC ()

@end

@implementation StartVC

- (id)init {
    self = [super init];
    if (self) {//镇江大市口店，镇江一店
        _buttonArray = [[NSMutableArray alloc]init];
        _currentViewNumber = 0;
        _currentPlace = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    if (SYSTEMVERSION > 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    StartFirstView * startFirstView = [[StartFirstView alloc]initWithFrame:CGRectMake(0, HEIGHT_VIEW, ScreenWidth, ScreenHeight - HEIGHT_VIEW - 40 - HEIGHT_VIEW_IOS6)];

    StartSecondView * startSecondView = [[StartSecondView alloc]initWithFrame:CGRectMake(0, HEIGHT_VIEW, ScreenWidth, ScreenHeight - HEIGHT_VIEW - 40 - HEIGHT_VIEW_IOS6)];

    StartThirdView * startThirdView = [[StartThirdView alloc]initWithFrame:CGRectMake(0, HEIGHT_VIEW, ScreenWidth, ScreenHeight - HEIGHT_VIEW - 40 - HEIGHT_VIEW_IOS6)];

    StartFourthView * startFourthView = [[StartFourthView alloc]initWithFrame:CGRectMake(0, HEIGHT_VIEW, ScreenWidth, ScreenHeight - HEIGHT_VIEW - 40 - HEIGHT_VIEW_IOS6)];

    for (int i = 0; i < 4; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(i * ScreenWidth / 4, ScreenHeight - 40 - HEIGHT_VIEW_IOS6, ScreenWidth / 4 + 1, 40)];
        button.tag = i;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"button%i.jpg",i + 1]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"button%i.jpg",i + 1]] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"button%iClick.jpg",i + 1]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArray addObject:button];
        [self.view addSubview:button];
    }

    _viewArray = [NSArray arrayWithObjects:startFirstView, startSecondView, startThirdView, startFourthView, nil];

    _rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"切换店面" style:UIBarButtonItemStylePlain target:self action:@selector(changePlace)];
    [_rightBarButtonItem setTintColor:[UIColor whiteColor]];

    [self buttonClicked:[_buttonArray objectAtIndex:0]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    AppDelegateInstance.titleLabel.text = AppDelegateInstance.shopStr;
//    [AppDelegateInstance.titleArray replaceObjectAtIndex:0 withObject:AppDelegateInstance.shopStr];
}

- (void)changePlace {
    PlaceChooseVC * firstDetailVC = [[PlaceChooseVC alloc]init];
    [self.navigationController pushViewController:firstDetailVC animated:YES];
}

- (void)buttonClicked:(UIButton*)button {
    if (button.tag == 0) {
        self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }

    [[_viewArray objectAtIndex:_currentViewNumber] removeFromSuperview];

    [self.view insertSubview:[_viewArray objectAtIndex:button.tag] atIndex:0];

    _currentViewNumber = button.tag;
    for (UIButton * button in _buttonArray) {
        button.selected = NO;
        button.userInteractionEnabled = YES;
    }
    [[_buttonArray objectAtIndex:button.tag]setSelected:YES];
    button.userInteractionEnabled = NO;

    AppDelegateInstance.titleLabel.text = [AppDelegateInstance.titleArray objectAtIndex:button.tag];

    if (button.tag == 2) {
        [(StartThirdView*)[_viewArray objectAtIndex:button.tag] asynService];
    }
}

@end
