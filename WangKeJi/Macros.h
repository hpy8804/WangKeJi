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

#define OUT_REG_STR @"<iq xmlns=\"jabber:client\" type=\"set\" id=\"iRVDg-0\"><query xmlns=\"jabber:iq:register\"><shopid>%@</shopid><username>%@</username><regip>%@</regip><password>%@</password><database>%@</database></query></iq>"

#define OUT_LOGIN_STR @"<iq xmlns=\"jabber:client\" type=\"get\" id=\"iRVDg-0\"><query xmlns=\"jabber:iq:auth\"><username>%@</username><password>%@@%@@%@@isios</password></query></iq>"

#define OUT_LOGIN_STR2 @"<iq xmlns=\"jabber:client\" type=\"set\" id=\"iRVDg-0\"><query xmlns=\"jabber:iq:auth\"><username>%@</username><password>%@@%@@%@@isios</password><resource>ios</resource></query></iq>"

#define OUT_ORDER_FROM_STR @"<message xmlns=\"jabber:client\" to=\"%@\" type=\"chat\" id=\"iRVDg-0\" from=\"%@@%@/%@@%@@%@\"><subject>有一个新订单需要确认！</subject><subject xml:lang=\"zh\">有一个新订单需要确认！</subject><body>确认订单号:%@</body><thread>%@</thread></message>"

#define GET_VC(self,vc) \
for (UIView * next = [self superview]; next; next = next.superview) {\
    UIResponder * nextResponder = [next nextResponder];\
    if ([nextResponder isKindOfClass:[UIViewController class]]) {\
        vc = (UIViewController *)nextResponder;\
        break;\
    }\
}