//
//  WKJUtil.h
//  WangKeJi
//
//  Created by sven on 3/17/15.
//  Copyright (c) 2015 wzzyinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKJUtil : NSObject
+ (NSString *)returnOrderStatusWithStatus:(NSString *)status payment_status:(NSString *)payment_status express_status:(NSString *)express_status;

+ (NSString *)obtainValueFromString:(NSString *)strRespond withIdentifier:(NSString *)strIndntifier;
@end
