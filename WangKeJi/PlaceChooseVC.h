//
//  PlaceChooseVC.h
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-30.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"

@interface PlaceChooseVC : UIViewController<UITableViewDataSource,UITableViewDelegate,ServiceHelperDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) ServiceHelper * helper;

@end
