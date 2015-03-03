//
//  March.h
//  fnsq
//
//  Created by wzzyinqiang on 14-12-5.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "AppDelegate.h"

#define AppDelegateInstance	                        ((AppDelegate*)([UIApplication sharedApplication].delegate))
#define ScreenWidth ([[UIScreen mainScreen]bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen]bounds].size.height)
#define SYSTEMVERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
//#define HEADER_URL @"http://120.27.28.178/WebInterface/WebService.asmx"
#define HEADER_URL @"http://www.wangkeji.com.cn/WebInterface/WebService.asmx"
#define IMAGE_HEADER_URL @"http://www.wangkeji.com.cn/"

#define OUT_LOGIN_STR ([NSString stringWithFormat:@"<iq xmlns=\"jabber:client\" type=\"get\" id=\"arPFa-21\"><query xmlns=\"jabber:iq:auth\"><username>%@</username><password>1234@%@@%@@isClient</password></query></iq>",AppDelegateInstance.user_id,AppDelegateInstance.shopID,AppDelegateInstance.shopStr])

#define OUT_ORDER_FROM_STR(bossname,order_number) ([NSString stringWithFormat:@"<message xmlns=\"jabber:client\" to=\"%@\" type=\"chat\" id=\"ck026-38\"><subject>有一个新订单需要确认！</subject><subject xml:lang=\"zh\">有一个新订单需要确认！</subject><body>确认订单号:%@</body><thread>%@</thread></message>",bossname,order_number,AppDelegateInstance.shopID])

#define GET_VC(self,vc) \
for (UIView * next = [self superview]; next; next = next.superview) {\
    UIResponder * nextResponder = [next nextResponder];\
    if ([nextResponder isKindOfClass:[UIViewController class]]) {\
        vc = (UIViewController *)nextResponder;\
        break;\
    }\
}