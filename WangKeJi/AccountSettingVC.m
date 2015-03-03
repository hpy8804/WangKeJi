//
//  AccountSettingVC.m
//  WangKeJi
//
//  Created by wzzyinqiang on 15-1-28.
//  Copyright (c) 2015年 wzzyinqiang. All rights reserved.
//

#import "AccountSettingVC.h"
#import "SoapHelper.h"
#import "UIWindow+YzdHUD.h"
#import <AVFoundation/AVFoundation.h>

@interface AccountSettingVC ()

@end

@implementation AccountSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];

    _tfArray = [[NSMutableArray alloc] init];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

    if (SYSTEMVERSION > 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 + 20, ScreenWidth, 40)];
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

    _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, _tableView.frame.origin.y + _tableView.frame.size.height + 20, ScreenWidth, 40)];
    _tableView1.scrollEnabled = NO;
    _tableView1.dataSource = self;
    _tableView1.delegate = self;
    _tableView1.tag = 1;
    [self.view addSubview:_tableView1];

    _helper = [[ServiceHelper alloc]initWithDelegate:self];


    _topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [_topView setBarStyle:UIBarStyleDefault];

    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneInput)];
    [doneButton setTintColor:[UIColor colorWithRed:236/255.0 green:184/255.0 blue:2/255.0 alpha:1.0]];
    [_topView setItems:[NSArray arrayWithObjects:btnSpace, doneButton, nil]];
}

- (void)doneInput {
    for (UITextField * textField in _tfArray) {
        [textField resignFirstResponder];
    }
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentify = @"defaultCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        CALayer * layer = [CALayer layer];
        [layer setFrame:CGRectMake(0, 40, ScreenWidth, 1.0f)];
        [cell.layer addSublayer:layer];
    }

    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 40)];
    [textField setInputAccessoryView:_topView];
    [_tfArray addObject:textField];
    [textField setTextAlignment:NSTextAlignmentCenter];
    if (tableView.tag == 0) {
        textField.placeholder = @"请输入手机号";
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    else if (tableView.tag == 1) {
        textField.userInteractionEnabled = NO;
        textField.text = @"手机号绑定";
        [textField setTextAlignment:NSTextAlignmentCenter];
    }
    [cell.contentView addSubview:textField];

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        NSMutableArray *arr=[NSMutableArray array];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[(UITextField*)[_tfArray objectAtIndex:0] text],@"phone", nil]];
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:AppDelegateInstance.user_id,@"imei", nil]];
        NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"UpdateUser"];
        [_helper asynServiceMethod:@"UpdateUser" soapMessage:soapMsg];
    }
}

#pragma mark - ServiceHelperDelegate
-(void)finishSuccessRequest:(NSString*)xml {
    NSData * data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([[dataDic objectForKey:@"status"] isEqualToString:@"true"]) {
        [self.view.window showHUDWithText:@"绑定成功" Type:ShowPhotoNo Enabled:YES];
    }
}

-(void)finishFailRequest:(NSError*)error {

}

@end
