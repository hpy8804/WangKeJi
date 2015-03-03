//
//  StartThirdView.h
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"

@interface StartThirdView : UIView<ServiceHelperDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) ServiceHelper * helper;

@property (nonatomic, strong) NSMutableArray * foodArray;

- (void)asynService;

@end
