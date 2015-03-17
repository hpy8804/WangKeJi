//
//  StartThirdView.m
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "StartThirdView.h"
#import "SoapHelper.h"
#import "FootCell.h"
#import "ThirdDetailVC.h"
#import "WKJUtil.h"

#define kFont [UIFont systemFontOfSize:12.0f]

@implementation StartThirdView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _foodArray = [[NSMutableArray alloc]init];

        _helper = [[ServiceHelper alloc] initWithDelegate:self];

        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 40)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_tableView];
    }
    return self;
}

- (void)asynService {
    if (AppDelegateInstance.shopStr) {
        NSMutableArray *arr=[NSMutableArray array];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:AppDelegateInstance.shopStr ,@"database", nil]];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"100",@"Top", nil]];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"user_name='%@' AND (status=1 or status=2 or status=3)",AppDelegateInstance.user_id],@"strWhere", nil]];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"id desc",@"filedOrder", nil]];

        NSString * soapMsg = [SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetMyOrderList"];
        [_helper asynServiceMethod:@"GetMyOrderList" soapMessage:soapMsg];
    }
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

#pragma mark - ServiceHelperDelegate
-(void)finishSuccessRequest:(NSString*)xml {
    [_foodArray removeAllObjects];
    NSData * data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([[dataDic objectForKey:@"data"]isKindOfClass:[NSArray class]]) {
        _foodArray = [dataDic objectForKey:@"data"];
    }
    else {
//        [self.window showHUDWithText:@"提交失败" Type:ShowPhotoYes Enabled:YES];
    }
    [_tableView reloadData];
}

-(void)finishFailRequest:(NSError*)error {

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _foodArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_foodArray[section][@"order_goods"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentify = @"footCell";
    FootCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];

    UILabel * label = nil;
    if (cell == nil) {
        cell = [[FootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.numberTF.layer.borderWidth = 0.0f;
        [cell.numberTF setFont:[UIFont systemFontOfSize:12.0f]];
        [cell.numberTF setFrame:CGRectMake(cell.titleLabel.frame.origin.x, cell.numberTF.frame.origin.y, cell.titleLabel.frame.size.width, cell.numberTF.frame.size.height)];
        [cell.numberTF setTextAlignment:NSTextAlignmentLeft];
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(10, 79, 300, 1)];
        viewLine.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:viewLine];
    }
    
    for (UIView *subView in cell.contentView.subviews) {
        if (subView.tag == 1010) {
            [subView removeFromSuperview];
        }
    }
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 40 - 10, cell.numberTF.frame.origin.y, 40, 20)];
    label.tag = 1010;
    [label setTextAlignment:NSTextAlignmentRight];
    [cell.contentView addSubview:label];

    NSString * imageURL = [NSString stringWithFormat:@"%@%@",IMAGE_HEADER_URL,_foodArray[indexPath.section][@"order_goods"][indexPath.row][@"img_url"]];
    if ([AppDelegateInstance.imageDic objectForKey:[[_foodArray objectAtIndex:indexPath.section]objectForKey:@"img_url"]]) {
        cell.footImageView.image = [UIImage imageWithData:[AppDelegateInstance.imageDic objectForKey:[[_foodArray objectAtIndex:indexPath.section]objectForKey:@"img_url"]]];
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
                    cell.footImageView.image = image;
                }

            });
        });
    }

    cell.tag = indexPath.section;

    cell.titleLabel.text = _foodArray[indexPath.section][@"order_goods"][indexPath.row][@"goods_title"];

    cell.priceLabel.text = [NSString stringWithFormat:@"¥ %@",_foodArray[indexPath.section][@"order_goods"][indexPath.row][@"goods_price"]];
    cell.priceLabel.textColor = [UIColor orangeColor];

    cell.numberTF.text = [NSString stringWithFormat:@"口味:%@",[AppDelegateInstance.tasteArray objectAtIndex:[_foodArray[indexPath.section][@"order_goods"][indexPath.row][@"taste"] integerValue]]];

    NSArray *arrGoods = _foodArray[indexPath.section][@"order_goods"];

    label.text = [NSString stringWithFormat:@"%@%@", @"x",arrGoods[indexPath.row][@"quantity"]];

    cell.addButton.hidden = YES;
    cell.reduceButton.hidden = YES;
    cell.deleteButton.hidden = YES;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ThirdDetailVC * thirdDetailVC = [[ThirdDetailVC alloc] init];
    thirdDetailVC.order_id = _foodArray[indexPath.section][@"order_goods"][indexPath.row][@"order_id"];
    [[self getViewController].navigationController pushViewController:thirdDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(4, 5, 170, 30)];
    labelDate.adjustsFontSizeToFitWidth = YES;
    labelDate.text = [NSString stringWithFormat:@"订单日期:%@", _foodArray[section][@"add_time"]];
    labelDate.font = kFont;
    [viewBack addSubview:labelDate];
    
    UILabel *labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelDate.frame)+5, 5, 50, 30)];
    labelStatus.textColor = [UIColor redColor];
    NSString *strStatus = [WKJUtil returnOrderStatusWithStatus:_foodArray[section][@"status"] payment_status:_foodArray[section][@"payment_status"] express_status:_foodArray[section][@"express_status"]];
    labelStatus.textAlignment = NSTextAlignmentCenter;
    labelStatus.text = strStatus;
    labelStatus.font = kFont;
    [viewBack addSubview:labelStatus];
    
    UILabel *labelCountPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelStatus.frame)+5, 5, 60, 30)];
    labelCountPrice.text = [NSString stringWithFormat:@"¥ %@", _foodArray[section][@"order_amount"]];
    labelCountPrice.font = kFont;
    labelCountPrice.textAlignment = NSTextAlignmentCenter;
    labelCountPrice.textColor = [UIColor orangeColor];
    [viewBack addSubview:labelCountPrice];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(10, 39, 300, 1)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [viewBack addSubview:viewLine];
    
    viewBack.backgroundColor = [UIColor whiteColor];
    
    return viewBack;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UILabel *labelAddress = [[UILabel alloc] initWithFrame:CGRectMake(4, 10, 160, 30)];
    labelAddress.text = [NSString stringWithFormat:@"地址：%@", _foodArray[section][@"address"]];
    labelAddress.font = kFont;
    [viewBack addSubview:labelAddress];
    
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 46, 320, 4)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [viewBack addSubview:viewLine];
    
    viewBack.backgroundColor = [UIColor whiteColor];
    
    return viewBack;
}

@end
