//
//  StartSecondView.m
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "StartSecondView.h"
#import "UserCell.h"
#import "FootCell.h"
#import "AFNetworking.h"
#import "UIWindow+YzdHUD.h"
#import "SoapHelper.h"
#import "StartVC.h"
#import "StartThirdView.h"

#define kStr_UserName @"shopping_username"
#define kStr_Address @"shopping_address"
#define kStr_Phone @"shopping_phone"

@interface StartSecondView ()
{
    NSArray *_arrUseInfo;
}
@end

@implementation StartSecondView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _shopcartParameterArray = [NSArray arrayWithObjects:@"id", @"quantity", @"taste", nil];

        _helper = [[ServiceHelper alloc]initWithDelegate:self];

        _foodArray = [[NSMutableArray alloc]init];

        _cellArray = [[NSMutableArray alloc]init];

        _userArray = [NSArray arrayWithObjects:@"收货人姓名", @"地址", @"电话", nil];
        
        NSString *strUsername = [[NSUserDefaults standardUserDefaults]objectForKey:kStr_UserName];
        if ([strUsername length] == 0) {
            strUsername = @"";
        }
        NSString *strAddress = [[NSUserDefaults standardUserDefaults]objectForKey:kStr_Address];
        if ([strAddress length] == 0) {
            strAddress = @"";
        }
        NSString *strPhone = [[NSUserDefaults standardUserDefaults]objectForKey:kStr_Phone];
        if ([strPhone length] == 0) {
            strPhone = @"";
        }
        _arrUseInfo = @[strUsername, strAddress, strPhone];

        [self setBackgroundColor:[UIColor colorWithWhite:235/255.0f alpha:1.0]];

        _userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 120)];
        _userTableView.scrollEnabled = NO;
        _userTableView.dataSource = self;
        [_userTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _userTableView.delegate = self;
        _userTableView.tag = 0;
        [self addSubview:_userTableView];

        CALayer * topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0.0f, 0, ScreenWidth, 0.5f);
        topBorder.backgroundColor = [UIColor colorWithWhite:210/255.0f alpha:1.0f].CGColor;
        [_userTableView.layer addSublayer:topBorder];

        _foodTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _userTableView.frame.origin.y + _userTableView.frame.size.height + 20, ScreenWidth, ScreenHeight - 20 - 60 - 40 -(_userTableView.frame.origin.y + _userTableView.frame.size.height + 20 + 40))];
        _foodTableView.dataSource = self;
        [_foodTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _foodTableView.delegate = self;
        _foodTableView.tag = 1;
        [self addSubview:_foodTableView];

        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 65 - 40 - 60, ScreenWidth, 60)];
        [bottomView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:105/255.0 blue:0/255.0 alpha:1.0]];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];

        _allPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth / 2, bottomView.frame.size.height)];
        _allPriceLabel.text = @"总价:0";
        [_allPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [bottomView addSubview:_allPriceLabel];

        UIButton * affirmButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth / 2 + 20, 5, ScreenWidth / 2 - 40, 50)];
        [affirmButton setBackgroundColor:[UIColor colorWithRed:239/255.0 green:150/255.0 blue:26/255.0 alpha:1.0]];
        [affirmButton setTitle:@"确认订单" forState:UIControlStateNormal];
        [affirmButton addTarget:self action:@selector(affirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        affirmButton.layer.cornerRadius = 10.0f;
        [bottomView addSubview:affirmButton];

        _topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        [_topView setBarStyle:UIBarStyleDefault];

        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneInput)];
        [doneButton setTintColor:[UIColor colorWithRed:236/255.0 green:184/255.0 blue:2/255.0 alpha:1.0]];
        [_topView setItems:[NSArray arrayWithObjects:btnSpace, doneButton, nil]];

        _locManager = [[CLLocationManager alloc]init];
        _locManager.delegate = self;
        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locManager.distanceFilter = 5.0;
    }
    return self;
}

- (void)doneInput {
    for (UserCell * cell in _cellArray) {
        [cell.textField resignFirstResponder];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[[[_cellArray objectAtIndex:0]textField]text] forKey:kStr_UserName];
        [userDefault setObject:[[[_cellArray objectAtIndex:1]textField]text] forKey:kStr_Address];
        [userDefault setObject:[[[_cellArray objectAtIndex:2]textField]text] forKey:kStr_Phone];
        [userDefault synchronize];
    }
}

- (void)affirmButtonClicked {
    if ([_foodArray count] == 0) {
        [self.window showHUDWithText:@"购物车空" Type:ShowPhotoYes Enabled:YES];
        return;
    }
    if ([[[(UserCell*)[_cellArray objectAtIndex:0] textField] text]isEqualToString:@""]) {
        [self.window showHUDWithText:@"请输入收货人姓名" Type:ShowPhotoYes Enabled:YES];
        return;
    }
    if ([[[(UserCell*)[_cellArray objectAtIndex:1] textField] text]isEqualToString:@""]) {
        [self.window showHUDWithText:@"请输入地址" Type:ShowPhotoYes Enabled:YES];
        return;
    }
    if ([[[(UserCell*)[_cellArray objectAtIndex:2] textField] text]isEqualToString:@""]) {
        [self.window showHUDWithText:@"请输入电话" Type:ShowPhotoYes Enabled:YES];
        return;
    }
    if ([[[(UserCell*)[_cellArray objectAtIndex:2] textField] text] length] != 11) {
        [self.window showHUDWithText:@"号码不正确" Type:ShowPhotoYes Enabled:YES];
        return;
    }
    [self.window showHUDWithText:@"提交中…" Type:ShowLoading Enabled:YES];
    [_locManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:AppDelegateInstance.shopStr ,@"database", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:AppDelegateInstance.user_id,@"imei", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude],@"latitude", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude],@"longitude", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[[[_cellArray objectAtIndex:0] textField] text],@"accept_name", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[[[_cellArray objectAtIndex:2] textField] text],@"mobile", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[[[_cellArray objectAtIndex:1] textField] text],@"address", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"message", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[self getShopcart],@"shopcart", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"Userid", nil]];
    NSString * soapMsg = [SoapHelper arrayToDefaultSoapMessage:arr methodName:@"SubmitOrder"];
    [_helper asynServiceMethod:@"SubmitOrder" soapMessage:soapMsg];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self.window showHUDWithText:@"获取位置失败" Type:ShowPhotoYes Enabled:YES];
}

- (void)setAllPrice {
    int allPrice = 0;
    for (int i = 0; i < [AppDelegateInstance.foodNumberArray count]; i++) {
        allPrice += [[[_foodArray objectAtIndex:i]objectForKey:@"sell_price"]intValue] * [[AppDelegateInstance.foodNumberArray objectAtIndex:i]intValue];
    }
    _allPriceLabel.text = [NSString stringWithFormat:@"总价:%i",allPrice];
}

- (NSString*)getShopcart {
    NSMutableArray * jsonArray = [[NSMutableArray alloc]init];
    NSMutableString * jsonString = [[NSMutableString alloc] initWithString:@"["];

    for (int i = 0; i < [_foodArray count]; i++) {
        NSDictionary * foodDic = [_foodArray objectAtIndex:i];

        //2. 遍历数组，取出键值对并按json格式存放
        NSString * string = @"";

        string = [NSString stringWithFormat:
                  @"{\"id\":\"%@\",\"quantity\":\"%@\",\"taste\":\"%@\"},",[foodDic objectForKey:@"id"],[AppDelegateInstance.foodNumberArray objectAtIndex:i],[foodDic objectForKey:@"taste"]];

        [jsonString appendString:string];

        NSMutableArray * smallJsonArray = [[NSMutableArray alloc]init];

        for (int j = 0; j < [_shopcartParameterArray count]; j++) {
            NSString * key = [_shopcartParameterArray objectAtIndex:j];
            if ([key isEqualToString:@"quantity"]) {
                [smallJsonArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[AppDelegateInstance.foodNumberArray objectAtIndex:i], key, nil]];
            }
            else if([key isEqualToString:@"taste"]){
                [smallJsonArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[foodDic objectForKey:key], key, nil]];
                
            }
            else {
                [smallJsonArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[foodDic objectForKey:key], key, nil]];
            }
        }

        [jsonArray addObject:smallJsonArray];
    }

    // 3. 获取末尾逗号所在位置
    NSUInteger location = [jsonString length]-1;

    NSRange range       = NSMakeRange(location, 1);

    // 4. 将末尾逗号换成结束的]}
    [jsonString replaceCharactersInRange:range withString:@"]"];

    return jsonString;
}

- (void)deleteButtonClicked:(UIButton*)button {
    [self.window showHUDWithText:@"取消成功" Type:ShowPhotoYes Enabled:YES];
    [_foodArray removeObjectAtIndex:button.tag];
    [AppDelegateInstance.foodNumberArray removeObjectAtIndex:button.tag];
    [self setAllPrice];
    [_foodTableView reloadData];
}

#pragma mark - ServiceHelperDelegate
-(void)finishSuccessRequest:(NSString*)xml {
    NSLog(@"%@",AppDelegateInstance.user_id);
    NSData * data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([dataDic objectForKey:@"status"]) {
        [self.window showHUDWithText:@"提交成功" Type:ShowPhotoYes Enabled:YES];
        [(StartThirdView*)[AppDelegateInstance.startVC.viewArray objectAtIndex:2] asynService];
        NSString * bossname = [dataDic objectForKey:@"bossname"];
        NSString * order_id = [dataDic objectForKey:@"orderid"];
        [AppDelegateInstance.socket writeData:[OUT_ORDER_FROM_STR(bossname, order_id) dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:202];
        
        //跳转到订单列表
        [self removeFromSuperview];
        UIButton * a = [[UIButton alloc]init];
        a.tag = 2;
        [AppDelegateInstance.startVC buttonClicked:a];
        
    }
    else {
//        [self.window showHUDWithText:@"提交失败" Type:ShowPhotoYes Enabled:YES];
    }
}

-(void)finishFailRequest:(NSError*)error {
    [self.window showHUDWithText:@"提交失败" Type:ShowPhotoYes Enabled:YES];
    NSLog(@"%@",error);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) {
        return 3;
    }
    else if (tableView.tag == 1) {
        return [_foodArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        static NSString * cellIdentify = @"userCell";
        UserCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];

        if (cell == nil) {
            cell = [[UserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }

        [_cellArray addObject:cell];

        if (indexPath.row == 2) {
            [cell.textField setKeyboardType:UIKeyboardTypeNumberPad];
        }
        cell.textField.placeholder = [_userArray objectAtIndex:indexPath.row];
        cell.textField.text = _arrUseInfo[indexPath.row];
        [cell.textField setInputAccessoryView:_topView];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else if(tableView.tag == 1) {
        static NSString * cellIdentify = @"footCell";
        FootCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];

        if (cell == nil) {
            cell = [[FootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        }
        if (indexPath.row + 1 == [_foodArray count]) {
            [self setAllPrice];
        }

        cell.footImageView.image = [AppDelegateInstance load_image:[NSString stringWithFormat:@"%@%@",IMAGE_HEADER_URL,[[_foodArray objectAtIndex:indexPath.row] objectForKey:@"img_url"]]];

        cell.tag = indexPath.row;

        cell.titleLabel.text = [[_foodArray objectAtIndex:indexPath.row]objectForKey:@"title"];

        cell.priceLabel.text = [NSString stringWithFormat:@"$%@",[[_foodArray objectAtIndex:indexPath.row]objectForKey:@"sell_price"]];

        cell.deleteButton.tag = indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        cell.tasteLabel.text = [NSString stringWithFormat:@"口味:%@",[AppDelegateInstance.tasteArray objectAtIndex:[[[_foodArray objectAtIndex:indexPath.row] objectForKey:@"taste"] integerValue]]];
        cell.tasteLabel.hidden = NO;
        
        cell.numberTF.text = [AppDelegateInstance.foodNumberArray objectAtIndex:indexPath.row];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }

    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        return 40;
    }
    else if (tableView.tag == 1) {
        return 80;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
