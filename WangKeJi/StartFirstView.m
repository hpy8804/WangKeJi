//
//  StartFirstView.m
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "StartFirstView.h"
#import "FirstCell.h"
#import "MJRefresh.h"
#import "StartVC.h"
#import "FirstDetailVC.h"
#import "UIWindow+YzdHUD.h"
#import "AFNetworking.h"
#import "TouchXML.h"
#import "SoapHelper.h"

@implementation StartFirstView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _helper = [[ServiceHelper alloc]initWithDelegate:self];

        _cellNumber = 5;

        _isLoading = NO;

        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_tableView];

        _locManager = [[CLLocationManager alloc]init];
        _locManager.delegate = self;
        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locManager.distanceFilter = 5.0;
        if (SYSTEMVERSION >= 8.0f) {
            if([_locManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locManager requestAlwaysAuthorization]; // 永久授权
            }
        }

        [_tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
        [_tableView headerBeginRefreshing];

        [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];

        // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
        _tableView.headerPullToRefreshText = @"下拉刷新";
        _tableView.headerReleaseToRefreshText = @"松开刷新";
        _tableView.headerRefreshingText = @"正在刷新中…";

        _tableView.footerPullToRefreshText = @"上拉加载";
        _tableView.footerReleaseToRefreshText = @"松开加载";
        _tableView.footerRefreshingText = @"正在你加载中…";
    }
    return self;
}

- (void)headerRefreshing {
    _cellNumber = 5;
    [_locManager stopUpdatingLocation];
    [_locManager startUpdatingLocation];
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
}

- (void)footerRefreshing {
    _cellNumber += 5;
    [_locManager stopUpdatingLocation];
    [_locManager startUpdatingLocation];
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
}

- (UIViewController*)getViewController {
    for (UIView * next = [self superview]; next; next = next.superview) {
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }

    return nil;
}

- (NSString*)XMLToJson:(NSString*)xml {
    int start = 0,end = 0;
    for (int i = 0; i<[xml length]; i++) {
        //截取字符串中的每一个字符
        NSString * s = [xml substringWithRange:NSMakeRange(i, 1)];
        if ([s isEqualToString:@"{"]) {
            start = i;
        }
        if ([s isEqualToString:@"<"] && start != 0) {
            end = i;
        }
    }
    NSString * jsonStr = [xml substringFromIndex:start];
    jsonStr = [xml substringWithRange:NSMakeRange(start,end - start)];
    return jsonStr;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];

    NSString * url = [NSString stringWithFormat:@"%@/getShopName?lat=%f&lon=%f",HEADER_URL,newLocation.coordinate.latitude,newLocation.coordinate.longitude];

    AFHTTPRequestOperationManager * afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [afManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData * doubi = responseObject;
        NSString * shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
        NSData * data = [[self XMLToJson:shabi] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (!AppDelegateInstance.shopStr) {
            AppDelegateInstance.shopStr = [dataDic objectForKey:@"database"];
            AppDelegateInstance.shopID = [dataDic objectForKey:@"shopid"];
        }
        AppDelegateInstance.titleLabel.text = AppDelegateInstance.shopStr;
        [AppDelegateInstance.titleArray replaceObjectAtIndex:0 withObject:AppDelegateInstance.shopStr];
        NSMutableArray *arr=[NSMutableArray array];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:AppDelegateInstance.shopStr,@"database", nil]];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"goods",@"channel_name", nil]];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"39",@"category_id", nil]];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%li",(long)_cellNumber],@"top", nil]];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"status=0 and is_red=1",@"strwhere", nil]];
        NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"get_article_list"];
        [_helper asynServiceMethod:@"get_article_list" soapMessage:soapMsg];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([_tableView isHeaderRefreshing]) {
            [_tableView headerEndRefreshing];
            _isLoading = NO;
        }
        if ([_tableView isFooterRefreshing]) {
            [_tableView footerEndRefreshing];
            _isLoading = NO;
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self.window showHUDWithText:@"获取位置失败" Type:ShowPhotoYes Enabled:YES];
    _isLoading = NO;
    if ([_tableView isHeaderRefreshing]) {
        [_tableView headerEndRefreshing];
        _isLoading = NO;
    }
    if ([_tableView isFooterRefreshing]) {
        [_tableView footerEndRefreshing];
        _isLoading = NO;
    }
}

#pragma mark - ServiceHelperDelegate
-(void)finishSuccessRequest:(NSString*)xml {
    _dataArray = [[NSMutableArray alloc]init];
    NSData * data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _dataArray = [dataDic objectForKey:@"data"];
    [_tableView reloadData];
    if ([_tableView isHeaderRefreshing]) {
        [_tableView headerEndRefreshing];
    }
    else if ([_tableView isFooterRefreshing]) {
        [_tableView footerEndRefreshing];
    }
}

-(void)finishFailRequest:(NSError*)error {
    if ([_tableView isHeaderRefreshing]) {
        [_tableView headerEndRefreshing];
    }
    else if ([_tableView isFooterRefreshing]) {
        [_tableView footerEndRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        static NSString * cellIdentify = @"headCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];

        if (cell == nil) {
            cell = [[FirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }

        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];

        UITextView * headerTV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        [headerTV setFont:[UIFont systemFontOfSize:20.0f]];
        headerTV.text = @"门店营业时间:上午09:00-晚上21:00";
        [headerTV setTextAlignment:NSTextAlignmentCenter];
        headerTV.userInteractionEnabled = NO;
        [headerTV setBackgroundColor:[UIColor colorWithRed:1 green:239/255.0 blue:134/255.0 alpha:0.5]];
        [cell.contentView addSubview:headerTV];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        return cell;
    }

    static NSString * cellIdentify = @"firstCell";
    FirstCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];

    if (cell == nil) {
        cell = [[FirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    cell.titleTF.text = [[_dataArray objectAtIndex:indexPath.row - 1]objectForKey:@"title"];

    cell.priceTF.text = [NSString stringWithFormat:@"$%@",[[_dataArray objectAtIndex:indexPath.row - 1]objectForKey:@"sell_price"]];

    cell.contentTV.text = [[_dataArray objectAtIndex:indexPath.row - 1]objectForKey:@"zhaiyao"];

    NSString * imageURL = [NSString stringWithFormat:@"%@%@",IMAGE_HEADER_URL,[[_dataArray objectAtIndex:indexPath.row - 1]objectForKey:@"img_url"]];
    if ([AppDelegateInstance.imageDic objectForKey:imageURL]) {
        cell.foodImageView.image = [UIImage imageWithData:[AppDelegateInstance.imageDic objectForKey:imageURL]];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            UIImage * image = [UIImage imageWithData:data];
            if (image) {
                [AppDelegateInstance.imageDic setObject:data forKey:imageURL];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    cell.foodImageView.image = image;
                }

            });
        });
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    FirstDetailVC * firstDetailVC = [[FirstDetailVC alloc]init];
    firstDetailVC.row = indexPath.row - 1;
    [[[self getViewController]navigationController]pushViewController:firstDetailVC animated:YES];
}

@end
