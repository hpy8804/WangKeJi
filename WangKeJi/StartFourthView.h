//
//  StartFourthView.h
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartFourthView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray * tableContentArray;

@property (nonatomic, strong) UITableView * tableView;

@end
