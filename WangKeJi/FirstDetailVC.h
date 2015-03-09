//
//  FirstDetailVC.h
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"

@class SGFocusImageFrame;

@interface FirstDetailVC : UIViewController<UITableViewDataSource,UITableViewDelegate,ServiceHelperDelegate>

@property (nonatomic, strong) SGFocusImageFrame * imageView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * joinShoppingButton;
@property (nonatomic, strong) UIButton * direct_buyButton;
@property (nonatomic, strong) UIButton * enterShoppingCar;
@property (nonatomic, strong) UISegmentedControl * segmentedControl;
@property (nonatomic, strong) NSArray * detailArray;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSArray * imageURLs;
@property (nonatomic, strong) ServiceHelper * helper;

@end
