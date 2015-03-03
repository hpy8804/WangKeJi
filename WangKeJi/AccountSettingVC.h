//
//  AccountSettingVC.h
//  WangKeJi
//
//  Created by wzzyinqiang on 15-1-28.
//  Copyright (c) 2015年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"

@interface AccountSettingVC : UIViewController<ServiceHelperDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITableView * tableView1;
@property (nonatomic, strong) ServiceHelper * helper;
@property (nonatomic, strong) UIToolbar * topView;
@property (nonatomic, strong) NSMutableArray * tfArray;

@end
