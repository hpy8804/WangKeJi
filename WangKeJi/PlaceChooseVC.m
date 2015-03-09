//
//  PlaceChooseVC.m
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-30.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "PlaceChooseVC.h"
#import "SoapHelper.h"
#import "StartVC.h"
#import "StartFirstView.h"
#import "MJRefresh.h"
#import "StartSecondView.h"

@interface PlaceChooseVC ()
{
    NSIndexPath *_curIndexPath;
}
@end

@implementation PlaceChooseVC

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

    _helper = [[ServiceHelper alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"privince", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"city", nil]];
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"getShopList"];
    [_helper asynServiceMethod:@"getShopList" soapMessage:soapMsg];
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ServiceHelperDelegate
-(void)finishSuccessRequest:(NSString*)xml {
    NSData * data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    AppDelegateInstance.placeArray = [NSArray arrayWithArray:[dataDic objectForKey:@"data"]];
    [_tableView reloadData];
}

-(void)finishFailRequest:(NSError*)error {

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AppDelegateInstance.placeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentify = @"defaultCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }

    cell.textLabel.text = [[AppDelegateInstance.placeArray objectAtIndex:indexPath.row] objectForKey:@"shopname"];

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _curIndexPath = indexPath;
    
    NSString *strTipMsg = [NSString stringWithFormat:@"确定要进入%@吗?",[[AppDelegateInstance.placeArray objectAtIndex:indexPath.row] objectForKey:@"shopname"]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:strTipMsg
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - UIAlertView delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AppDelegateInstance.startVC.currentPlace = _curIndexPath.row;
        AppDelegateInstance.shopStr = [[AppDelegateInstance.placeArray objectAtIndex:_curIndexPath.row] objectForKey:@"shopname"];
        AppDelegateInstance.titleLabel.text = AppDelegateInstance.shopStr;
        [AppDelegateInstance.titleArray replaceObjectAtIndex:0 withObject:AppDelegateInstance.shopStr];
        AppDelegateInstance.shopID = [[AppDelegateInstance.placeArray objectAtIndex:_curIndexPath.row] objectForKey:@"id"];
        [[(StartFirstView*)[AppDelegateInstance.startVC.viewArray objectAtIndex:0] tableView] headerBeginRefreshing];
        
        //同时清除数据
        [(StartSecondView*)[AppDelegateInstance.startVC.viewArray objectAtIndex:1] cleanAllGoods];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
