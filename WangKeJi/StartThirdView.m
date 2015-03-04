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
        NSArray * allDataArray = [dataDic objectForKey:@"data"];
        for (NSDictionary * dic in allDataArray) {
            [_foodArray addObjectsFromArray:[dic objectForKey:@"order_goods"]];
        }
    }
    else {
//        [self.window showHUDWithText:@"提交失败" Type:ShowPhotoYes Enabled:YES];
    }
    [_tableView reloadData];
}

-(void)finishFailRequest:(NSError*)error {

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_foodArray count];
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
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 40 - 10, cell.numberTF.frame.origin.y, 40, 20)];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell.contentView addSubview:label];
    }

    NSString * imageURL = [NSString stringWithFormat:@"%@%@",IMAGE_HEADER_URL,[[_foodArray objectAtIndex:indexPath.row]objectForKey:@"img_url"]];
    if ([AppDelegateInstance.imageDic objectForKey:[[_foodArray objectAtIndex:indexPath.row]objectForKey:@"img_url"]]) {
        cell.footImageView.image = [UIImage imageWithData:[AppDelegateInstance.imageDic objectForKey:[[_foodArray objectAtIndex:indexPath.row]objectForKey:@"img_url"]]];
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

    cell.tag = indexPath.row;

    cell.titleLabel.text = [[_foodArray objectAtIndex:indexPath.row]objectForKey:@"goods_title"];

    cell.priceLabel.text = [NSString stringWithFormat:@"$%@",[[_foodArray objectAtIndex:indexPath.row]objectForKey:@"goods_price"]];

    cell.numberTF.text = [NSString stringWithFormat:@"口味:%@",[AppDelegateInstance.tasteArray objectAtIndex:[[[_foodArray objectAtIndex:indexPath.row]objectForKey:@"taste"] integerValue]]];

    label.text = [NSString stringWithFormat:@"x%@",[[_foodArray objectAtIndex:indexPath.row]objectForKey:@"quantity"]];

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
    thirdDetailVC.order_id = [[_foodArray objectAtIndex:indexPath.row] objectForKey:@"order_id"];
    [[self getViewController].navigationController pushViewController:thirdDetailVC animated:YES];
}

@end
