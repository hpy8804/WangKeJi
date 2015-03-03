//
//  StartFirstView.h
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServiceHelper.h"

@interface StartFirstView : UIView<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,NSXMLParserDelegate,ServiceHelperDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) CLLocationManager * locManager;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger cellNumber;
@property (nonatomic, assign) NSInteger isLoading;
@property (nonatomic, strong) ServiceHelper * helper;

@end
