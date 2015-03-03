//
//  StartVC.h
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartVC : UIViewController

@property (nonatomic, strong) NSMutableArray * buttonArray;
@property (nonatomic, strong) NSArray * viewArray;
@property (nonatomic, assign) NSInteger currentViewNumber;
@property (nonatomic, assign) NSInteger currentPlace;
@property (nonatomic, strong) UIBarButtonItem * rightBarButtonItem;

- (void)buttonClicked:(UIButton*)button;

@end
