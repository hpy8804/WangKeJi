//
//  ThirdDetailVC.h
//  WangKeJi
//
//  Created by wzzyinqiang on 15-2-14.
//  Copyright (c) 2015年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceHelper.h"

@class FootCell;

@interface ThirdDetailVC : UIViewController<ServiceHelperDelegate>

@property (nonatomic, strong) ServiceHelper * helper;
@property (nonatomic, strong) ServiceHelper * helper1;
@property (nonatomic, strong) NSString * order_id;
@property (nonatomic, strong) NSArray * tableDataArray;
@property (nonatomic, strong) NSDictionary * dataDic;

@property (nonatomic, strong) FootCell * cell;
@property (nonatomic, strong) UITableView * tableView;

@end
