//
//  FirstDetailVC.m
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "FirstDetailVC.h"
#import "StartVC.h"
#import "StartFirstView.h"
#import "StartSecondView.h"
#import "SGFocusImageFrame.h"
#import "UIWindow+YzdHUD.h"
#import "SoapHelper.h"

#define HEIGHT_VIEW_IOS6 64

@interface FirstDetailVC ()

@end

@implementation FirstDetailVC

- (id)init {
    self = [super init];
    if (self) {
        _detailArray = [NSArray arrayWithObjects:@"", @"", @"口味选择:", @"销售价格:", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (SYSTEMVERSION > 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    _helper = [[ServiceHelper alloc] initWithDelegate:self];

    _dataDic = [[[(StartFirstView*)[AppDelegateInstance.startVC.viewArray objectAtIndex:0] dataArray] objectAtIndex:_row] copy];

    _imageView = [[SGFocusImageFrame alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * 2 / 3)];
//    UIImageView * imageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, ScreenWidth, _imageView.frame.size.height)];
//    imageView.image = [AppDelegateInstance load_image:[NSString stringWithFormat:@"%@%@",IMAGE_HEADER_URL,[_dataDic objectForKey:@"img_url"]]];
//    [_imageView addSubview:imageView];
    [self.view addSubview:_imageView];

    NSMutableArray *arr=[NSMutableArray array];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:AppDelegateInstance.shopStr,@"database", nil]];
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[_dataDic objectForKey:@"id"],@"id", nil]];
    NSString *soapMsg=[SoapHelper arrayToDefaultSoapMessage:arr methodName:@"GetGoodsDetail"];
    [_helper asynServiceMethod:@"GetGoodsDetail" soapMessage:soapMsg];

    [self.view setBackgroundColor:[UIColor colorWithWhite:235/255.0f alpha:1.0]];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _imageView.frame.origin.y + _imageView.frame.size.height + 20, ScreenWidth, 160 + 1)];
    CALayer * topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, ScreenWidth, 1.0f);
    topBorder.backgroundColor = [UIColor colorWithWhite:210/255.0f alpha:1.0f].CGColor;
    [_tableView.layer addSublayer:topBorder];
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];

    _joinShoppingButton = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight - 40 - HEIGHT_VIEW_IOS6, ScreenWidth / 3, 40)];
    [_joinShoppingButton setBackgroundColor:[UIColor colorWithRed:239/255.0 green:150/255.0 blue:26/255.0 alpha:1.0]];
    [_joinShoppingButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_joinShoppingButton addTarget:self action:@selector(joinShoppingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    _joinShoppingButton.layer.cornerRadius = 5.0f;
    [self.view addSubview:_joinShoppingButton];

    _direct_buyButton = [[UIButton alloc]initWithFrame:CGRectMake(_joinShoppingButton.frame.origin.x + _joinShoppingButton.frame.size.width, ScreenHeight - 40 - HEIGHT_VIEW_IOS6, ScreenWidth / 3, 40)];
    [_direct_buyButton setBackgroundColor:[UIColor colorWithRed:239/255.0 green:150/255.0 blue:26/255.0 alpha:1.0]];
    [_direct_buyButton setTitle:@"直接购买" forState:UIControlStateNormal];
    [_direct_buyButton addTarget:self action:@selector(direct_buyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    _direct_buyButton.layer.cornerRadius = 5.0f;
    [self.view addSubview:_direct_buyButton];
    
    _enterShoppingCar = [[UIButton alloc]initWithFrame:CGRectMake(_direct_buyButton.frame.origin.x + _direct_buyButton.frame.size.width, ScreenHeight - 40 - HEIGHT_VIEW_IOS6, ScreenWidth / 3, 40)];
    [_enterShoppingCar setBackgroundColor:[UIColor colorWithRed:239/255.0 green:150/255.0 blue:26/255.0 alpha:1.0]];
    [_enterShoppingCar setTitle:@"查看购物车" forState:UIControlStateNormal];
    [_enterShoppingCar addTarget:self action:@selector(checkShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_enterShoppingCar];

    _segmentedControl = [[UISegmentedControl alloc]initWithItems:AppDelegateInstance.tasteArray];
    [_segmentedControl setFrame:CGRectMake(100, 5, ScreenWidth - 100 - 50, 30)];
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = [UIColor colorWithRed:236/255.0 green:184/255.0 blue:2/255.0 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)joinShoppingButtonClicked {
    NSMutableDictionary * mutableDic = [NSMutableDictionary dictionaryWithDictionary:_dataDic];
    [mutableDic setObject:[NSString stringWithFormat:@"%li",(long)[_segmentedControl selectedSegmentIndex]] forKey:@"taste"];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:mutableDic];
    
    [self reAssignDate:dic];

    [[(StartSecondView*)[AppDelegateInstance.startVC.viewArray objectAtIndex:1]foodTableView]reloadData];

    [self.view.window showHUDWithText:@"已加入购物车" Type:ShowPhotoNo Enabled:YES];
}

- (void)direct_buyButtonClicked {
    NSMutableDictionary * mutableDic = [NSMutableDictionary dictionaryWithDictionary:_dataDic];
    [mutableDic setObject:[NSString stringWithFormat:@"%li",(long)[_segmentedControl selectedSegmentIndex]] forKey:@"taste"];
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:mutableDic];

    [self reAssignDate:dic];
    [[(StartSecondView*)[AppDelegateInstance.startVC.viewArray objectAtIndex:1]foodTableView]reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    UIButton * a = [[UIButton alloc]init];
    a.tag = 1;
    [AppDelegateInstance.startVC buttonClicked:a];
}

- (void)checkShoppingCar
{
    [self.navigationController popViewControllerAnimated:YES];
    
    UIButton * a = [[UIButton alloc]init];
    a.tag = 1;
    [AppDelegateInstance.startVC buttonClicked:a];
}

- (void)reAssignDate:(NSDictionary *)dic
{
    //对foodArray数据进行整理
    NSMutableArray *arrForFood = [(StartSecondView*)[AppDelegateInstance.startVC.viewArray objectAtIndex:1]foodArray];
    BOOL bIsFound = NO;
    int indexFound = 0;
    for (int i = 0; i < arrForFood.count; i++) {
        NSDictionary *subDic = arrForFood[i];
        if ([subDic[@"id"] isEqualToString:dic[@"id"]] &&
            [subDic[@"taste"] isEqualToString:dic[@"taste"]]) {
            indexFound = i;
            bIsFound = YES;
            break;
        }
    }
    
    if (bIsFound) {
        //同种商品，同种口味则放在一起
        NSInteger nCount = [AppDelegateInstance.foodNumberArray[indexFound] integerValue]+1;
        [AppDelegateInstance.foodNumberArray replaceObjectAtIndex:indexFound withObject:[NSString stringWithFormat:@"%d", nCount]];
    }else{
        [AppDelegateInstance.foodNumberArray addObject:@"1"];
        [arrForFood addObject:[dic copy]];
    }
}

#pragma mark - ServiceHelperDelegate
- (void)finishSuccessRequest:(NSString *)xml {
    NSData * data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _imageURLs = [NSArray arrayWithArray:[[[dataDic objectForKey:@"data"] objectAtIndex:0] objectForKey:@"albums"]];
    NSMutableArray * items = [NSMutableArray array];
    for (NSInteger i = 0; i < [_imageURLs count]; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenWidth * 2 / 3)];
//        imageView.image = [AppDelegateInstance load_image:[NSString stringWithFormat:@"%@%@",IMAGE_HEADER_URL,[[_imageURLs objectAtIndex:i] objectForKey:@"thumb_path"]]];
        UIImage * need_image = [UIImage imageNamed:@"loga.jpg"];
        if ([AppDelegateInstance.imageDic objectForKey:[NSString stringWithFormat:@"%@%@",IMAGE_HEADER_URL,[[_imageURLs objectAtIndex:i] objectForKey:@"thumb_path"]]]) {
            need_image = [UIImage imageWithData:[AppDelegateInstance.imageDic objectForKey:[NSString stringWithFormat:@"%@%@",IMAGE_HEADER_URL,[[_imageURLs objectAtIndex:i] objectForKey:@"thumb_path"]]]];
            imageView.image = need_image;
        }
        else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HEADER_URL,[[_imageURLs objectAtIndex:i] objectForKey:@"thumb_path"]]]];
                UIImage * image = [UIImage imageWithData:data];
                if (image) {
                    [AppDelegateInstance.imageDic setObject:data forKey:[NSString stringWithFormat:@"%@%@",IMAGE_HEADER_URL,[[_imageURLs objectAtIndex:i] objectForKey:@"thumb_path"]]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        imageView.image = image;
                    }
                    
                });
            });
        }
        [items addObject:imageView];
    }
    [_imageView setItems:items];
}

- (void)finishFailRequest:(NSError *)error {

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentify = @"defaultCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        if (indexPath.row == 0) {
            [cell.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
        }
        if (indexPath.row == 1) {
            [cell.textLabel setFont:[UIFont systemFontOfSize:12.0f]];
        }
        if (indexPath.row == 2) {
            [cell.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
            [_segmentedControl setFrame:CGRectMake(90, 7.5f, ScreenWidth - 95, 25)];
            [cell.contentView addSubview:_segmentedControl];
        }
        if (indexPath.row == 3) {
            [cell.textLabel setTextColor:[UIColor redColor]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:20.0f]];
        }
        CALayer * bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, 40, ScreenWidth, 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:210/255.0f alpha:1.0f].CGColor;
        [cell.contentView.layer addSublayer:bottomBorder];
    }

    NSString * text = [NSString stringWithFormat:@"%@%@",[_detailArray objectAtIndex:indexPath.row],[_dataDic objectForKey:[AppDelegateInstance.keyArray objectAtIndex:indexPath.row]]];
    if (indexPath.row == 2) {
        text = [NSString stringWithFormat:@"%@",[_detailArray objectAtIndex:indexPath.row]];
    }
    cell.textLabel.text = text;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
