//
//  StartFourthView.m
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "StartFourthView.h"
#import "StartVC.h"
#import "AccountSettingVC.h"
#import "ShowContentVC.h"
#import "LeagueVC.h"

@implementation StartFourthView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self setBackgroundColor:[UIColor colorWithWhite:235/255.0f alpha:1.0]];

        _tableContentArray = [NSArray arrayWithObjects:@"账户设置", @"旺客基介绍", @"我要加盟", nil];

        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 + 20, ScreenWidth, 40 * [_tableContentArray count])];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.scrollEnabled = NO;
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableContentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentify = @"tableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 100, 20)];
        textField.userInteractionEnabled = NO;
        textField.text = [_tableContentArray objectAtIndex:indexPath.row];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.contentView addSubview:textField];
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * classArray = [NSArray arrayWithObjects:[AccountSettingVC class], [ShowContentVC class], [LeagueVC class], nil];
    UIViewController * nextVC = [[[classArray objectAtIndex:indexPath.row] alloc] init];
    UIViewController * vc;
    GET_VC(self,vc);
    [vc.navigationController pushViewController:nextVC animated:YES];
}

@end
