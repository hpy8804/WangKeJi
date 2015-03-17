//
//  WKJUtil.m
//  WangKeJi
//
//  Created by sven on 3/17/15.
//  Copyright (c) 2015 wzzyinqiang. All rights reserved.
//

#import "WKJUtil.h"

@implementation WKJUtil
+ (NSString *)returnOrderStatusWithStatus:(NSString *)status payment_status:(NSString *)payment_status express_status:(NSString *)express_status{
    NSString *orderStatus = nil;
    switch ([status intValue]) {
        case 1:
        {
            if ([payment_status intValue] > 0) {
                orderStatus = @"待付款";
            }else{
                orderStatus = @"待确认";
            }
        }
            break;
        case 2:
        {
            if ([express_status intValue] > 1) {
                orderStatus = @"已派送";
            }else {
                orderStatus = @"待派送";
            }
        }
            break;
        case 3:
        {
            orderStatus = @"交易完成";
        }
            break;
        case 4:
        {
            orderStatus = @"已取消";
        }
            break;
        case 5:
        {
            orderStatus = @"已作废";
        }
            break;
            
        default:
            break;
    }
    
    return orderStatus;
}

+ (NSString *)obtainValueFromString:(NSString *)strRespond withIdentifier:(NSString *)strIndntifier
{
    NSError *error = nil;
    NSString *regExContent = [NSString stringWithFormat:@"<%@>(.*?)</%@>", strIndntifier, strIndntifier];
    NSRegularExpression *regularexpress = [[NSRegularExpression alloc] initWithPattern:regExContent
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
    
    NSArray *matches = [regularexpress matchesInString:strRespond
                                               options:NSMatchingReportCompletion
                                                 range:NSMakeRange(0, [strRespond length])];
    
    NSString *strResult = nil;
    
    for (NSTextCheckingResult *match in matches)
    {
        NSRange resultRange = [match range];
        if (resultRange.length > 0)
        {
            NSString *strResultRsp = [strRespond substringWithRange:resultRange];
            
            //获取“>”和“</”之间的string
            NSRange rangeStart = [strResultRsp rangeOfString:@">"];
            NSRange rangeStop = [strResultRsp rangeOfString:@"</"];
            NSRange strRange = NSMakeRange(rangeStart.location + 1, rangeStop.location - rangeStart.location - 1);
            
            strResult = [[strResultRsp substringWithRange:strRange] stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            return strResult;
        }
    }
    
    return @"";
}
@end
