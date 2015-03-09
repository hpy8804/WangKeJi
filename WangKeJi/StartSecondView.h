//
//  StartSecondView.h
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServiceHelper.h"

@interface StartSecondView : UIView<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,ServiceHelperDelegate>

@property (nonatomic, strong) UITableView * userTableView;
@property (nonatomic, strong) UITableView * foodTableView;
@property (nonatomic, strong) UILabel * allPriceLabel;
@property (nonatomic, strong) NSArray * userArray;
@property (nonatomic, strong) UIToolbar * topView;
@property (nonatomic, strong) NSMutableArray * cellArray;
@property (nonatomic, strong) NSMutableArray * foodArray;
@property (nonatomic, strong) NSMutableArray * foodNumberTFArray;
@property (nonatomic, strong) CLLocationManager * locManager;
@property (nonatomic, strong) ServiceHelper * helper;
@property (nonatomic, strong) NSArray * shopcartParameterArray;

- (void)setAllPrice;
- (void)cleanAllGoods;

@end
