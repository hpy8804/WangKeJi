//
//  ThirdDetailVC.m
//  WangKeJi
//
//  Created by wzzyinqiang on 15-2-14.
//  Copyright (c) 2015年 wzzyinqiang. All rights reserved.
//

#import "ThirdDetailVC.h"
#import "SoapHelper.h"
#import "FootCell.h"
#import "UIWindow+YzdHUD.h"

@interface ThirdDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ThirdDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if (SYSTEMVERSION > 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self.view setBackgroundColor:[UIColor colorWithWhite:235/255.0f alpha:1.0]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

    _tableDataArray = [NSArray array];
    _dataDic = [NSDictionary dictionary];

    _helper = [[ServiceHelper alloc] initWithDelegate:self];
    _helper1 = [[ServiceHelper alloc] initWithDelegate:nil];

    UIButton * confirmOrderButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 40)];
    [confirmOrderButton setBackgroundColor:[UIColor colorWithRed:239/255.0 green:150/255.0 blue:26/255.0 alpha:1.0]];
    [confirmOrderButton addTarget:self action:@selector(confirmOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [confirmOrderButton setTitle:@"确认订单" forState:UIControlStateNormal];
    [self.view addSubview:confirmOrderButton];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, confirmOrderButton.frame.origin.y + confirmOrderButton.frame.size.height + 10, ScreenWidth - 20, 240)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

    UIView * backCell = [[UIView alloc] initWithFrame:CGRectMake(10, _tableView.frame.origin.y + _tableView.frame.size.height + 10, ScreenWidth - 20, 80)];
    [backCell setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:backCell];

    _cell = [[FootCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [_cell setFrame:CGRectMake(0, _tableView.frame.origin.y + _tableView.frame.size.height + 10, ScreenWidth - 20, 80)];
    _cell.numberTF.layer.borderWidth = 0.0f;
    [_cell.numberTF setFont:[UIFont systemFontOfSize:12.0f]];
    [_cell.numberTF setFrame:CGRectMake(_cell.titleLabel.frame.origin.x, _cell.numberTF.frame.origin.y, _cell.titleLabel.frame.size.width, _cell.numberTF.frame.size.height)];
    [_cell.numberTF setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_cell];

    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:AppDelegateInstance.shopStr,@"database", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:_order_id,@"id", nil]];
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetMyOrder"];
    [_helper asynServiceMethod:@"GetMyOrder" soapMessage:soapMsg];
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmOrderButtonClicked:(UIButton*)button {
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:AppDelegateInstance.shopStr,@"database", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[_dataDic objectForKey:@"order_no"],@"order_no", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[_dataDic objectForKey:@"user_id"],@"userid", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[_dataDic objectForKey:@"user_name"],@"username", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[_dataDic objectForKey:@"status"],@"status", nil]];
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"ConfirmOrder"];
    [_helper1 asynServiceMethod:@"ConfirmOrder" soapMessage:soapMsg];

    [self.view.window showHUDWithText:@"订单已确认" Type:ShowPhotoNo Enabled:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ServiceHelperDelegate
-(void)finishSuccessRequest:(NSString*)xml {
    NSData * data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _dataDic = [NSDictionary dictionaryWithDictionary:[[NSArray arrayWithArray:[dataDic objectForKey:@"data"]] objectAtIndex:0]];
    NSArray * paymentArray = [NSArray arrayWithObjects:@"待确认", @"已确认", nil];
    _tableDataArray = [NSArray arrayWithObjects:
                       [_dataDic objectForKey:@"order_no"],
                       [_dataDic objectForKey:@"accept_name"],
                       [_dataDic objectForKey:@"address"],
                       [_dataDic objectForKey:@"mobile"],
                       [paymentArray objectAtIndex:[[_dataDic objectForKey:@"payment_status"] integerValue]],
                       @"",
                       @"",
                       [_dataDic objectForKey:@"order_amount"], nil];
    [_tableView reloadData];
    NSDictionary * orderDic = [[_dataDic objectForKey:@"order_goods"] objectAtIndex:0];

    NSString * imageURL = [NSString stringWithFormat:@"%@%@",IMAGE_HEADER_URL,[orderDic objectForKey:@"img_url"]];
    if ([AppDelegateInstance.imageDic objectForKey:[orderDic objectForKey:@"img_url"]]) {
        _cell.footImageView.image = [UIImage imageWithData:[AppDelegateInstance.imageDic objectForKey:[orderDic objectForKey:@"img_url"]]];
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
                    _cell.footImageView.image = image;
                }

            });
        });
    }

    _cell.titleLabel.text = [orderDic objectForKey:@"goods_title"];

    _cell.priceLabel.text = [NSString stringWithFormat:@"$%@",[orderDic objectForKey:@"goods_price"]];

    _cell.numberTF.text = [NSString stringWithFormat:@"口味:%@",[AppDelegateInstance.tasteArray objectAtIndex:[[orderDic objectForKey:@"taste"] integerValue]]];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 40 - 10, _cell.numberTF.frame.origin.y, 40, 20)];
    [label setTextAlignment:NSTextAlignmentRight];
    [_cell.contentView addSubview:label];
    label.text = [NSString stringWithFormat:@"x%@",[orderDic objectForKey:@"quantity"]];

    _cell.addButton.hidden = YES;
    _cell.reduceButton.hidden = YES;
    _cell.deleteButton.hidden = YES;
}

-(void)finishFailRequest:(NSError*)error {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentify = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }

    NSArray * keyArray = [NSArray arrayWithObjects:@"订单编号:", @"收货人:   ", @"地址:       ", @"联系方式:", @"订单状态:", @"外卖员:   ", @"发货时间:", @"总金额:   ", nil];

    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",[keyArray objectAtIndex:indexPath.row],[_tableDataArray objectAtIndex:indexPath.row]];

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
