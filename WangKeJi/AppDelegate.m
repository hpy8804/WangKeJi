//
//  AppDelegate.m
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import "AppDelegate.h"
#import "StartVC.h"
#import "MLNavigationController.h"
#import "SoapHelper.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "WKJUtil.h"
#import "ThirdDetailVC.h"
#import "UIDevice+IdentifierAddition.h"


#define HOST_NAME @"121.42.153.54"
//#define HOST_NAME @"127.0.0.1"
//#define HOST_NAME @"120.27.28.178"
#define kDefaultPassword @"123456"

@interface AppDelegate ()
{
    NSTimer *timeLogin;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];

    _isLogined = NO;

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]) {
        _user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    }
    else {
        _user_id = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        [[NSUserDefaults standardUserDefaults] setObject:_user_id forKey:@"user_id"];
    }

    _socket = [[AsyncSocket alloc]initWithDelegate:self];
    [_socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    NSError *err = nil; 
    if(![_socket connectToHost:HOST_NAME onPort:60000 error:&err])
    {
        NSLog(@"Error: %@", err);
    }
    
    timeLogin = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(sendLoginData:) userInfo:nil repeats:YES];

    _foodNumberArray = [[NSMutableArray alloc]init];

    _tasteArray = [NSArray arrayWithObjects:@"不辣", @"微辣", @"中辣", @"重辣", nil];

    _keyArray = [NSArray arrayWithObjects:@"title", @"zhaiyao", @"", @"sell_price", nil];

    _imageDic = [[NSMutableDictionary alloc]init];
    _titleArray = [NSMutableArray arrayWithObjects:@"江苏大学店", @"购物车", @"我的订单", @"设置", nil];

    _placeArray = [NSArray array];

    _shopStr = nil;
    _user_ip = [self getIPAddress];

    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [_window setBackgroundColor:[UIColor whiteColor]];

    _startVC = [[StartVC alloc] init];
    MLNavigationController * nav = [[MLNavigationController alloc]initWithRootViewController:_startVC];
    _window.rootViewController = nav;

    if (SYSTEMVERSION >= 7.0f) {
        [nav.navigationBar setBarTintColor:[UIColor colorWithRed:236/255.0 green:184/255.0 blue:2/255.0 alpha:1.0]];
    }
    else {
        nav.navigationBar.layer.contents = (id)[self imageWithColor:[UIColor redColor]].CGImage;
    }

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(0, 0, ScreenWidth, 45);
    _titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [nav.navigationBar addSubview:_titleLabel];

    [_window makeKeyAndVisible];

    return YES;
}

- (UIImage*)load_image:(NSString*)imageURL {
    __block UIImage * need_image = [UIImage imageNamed:@"loga.jpg"];
    if ([_imageDic objectForKey:imageURL]) {
        need_image = [UIImage imageWithData:[_imageDic objectForKey:imageURL]];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            UIImage * image = [UIImage imageWithData:data];
            if (image) {
                [_imageDic setObject:data forKey:imageURL];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    need_image = image;
                }

            });
        });
    }
    return need_image;
}

- (UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

-(int)getRandomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if (timeLogin && [timeLogin isValid]) {
        [timeLogin invalidate];
        timeLogin = nil;
    }
    [_socket disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if (timeLogin && [timeLogin isValid]) {
        [timeLogin invalidate];
        timeLogin = nil;
    }
    _socket = [[AsyncSocket alloc]initWithDelegate:self];
    [_socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    NSError *err = nil;
    if(![_socket connectToHost:HOST_NAME onPort:60000 error:&err])
    {
        NSLog(@"Error: %@", err);
    }
    
    timeLogin = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(sendLoginData:) userInfo:nil repeats:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

- (void)sendLoginData:(NSTimer *)time{
    [self registerUser];
    [self sendData:time];
}

- (void)registerUser{
    if (_shopStr && _shopID) {
        NSString *strSend = [NSString stringWithFormat:OUT_REG_STR, _shopID, _user_id, _user_ip, kDefaultPassword, _shopStr];
        NSData *sendData = [strSend dataUsingEncoding:NSUTF8StringEncoding];
        [_socket writeData:sendData withTimeout:-1 tag:202];
    }
}

- (void)sendData:(NSTimer *)timer {
    if (_shopID && _shopStr)
    {
        NSString *strSend = [NSString stringWithFormat:OUT_LOGIN_STR, _user_id, kDefaultPassword, _shopID,_shopStr];
        NSData * outgoingData = [strSend dataUsingEncoding:NSUTF8StringEncoding];

        [_socket writeData:outgoingData
               withTimeout:-1
                       tag:202];
        
        NSString *strSend2 = [NSString stringWithFormat:OUT_LOGIN_STR2, _user_id, kDefaultPassword, _shopID,_shopStr];
        NSData * outgoingData2 = [strSend2 dataUsingEncoding:NSUTF8StringEncoding];
        
        [_socket writeData:outgoingData2
               withTimeout:-1
                       tag:202];
    }
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "wzz.com.WangKeJi" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WangKeJi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WangKeJi.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - AsyncSocketDelegate
// 已连接
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
     [sock readDataWithTimeout:-1 tag:202];
    NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"thread(%@),onSocket:%p didWriteDataWithTag:%ld",[[NSThread currentThread] name],sock,tag);
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket {
    NSLog(@"didAcceptNewSocket");
}

-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    [sock readDataToData:[AsyncSocket CRLFData] withTimeout:0 tag:tag];
    
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *subject = [WKJUtil obtainValueFromString:aStr withIdentifier:@"subject"];
    NSString *order = [WKJUtil obtainValueFromString:aStr withIdentifier:@"body"];
    NSRange orderRange = [order rangeOfString:@"订单号:"];
    if (orderRange.location != NSNotFound) {
        _order_no = [order substringFromIndex:orderRange.location+orderRange.length];
    }

    if (subject.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:subject delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
        [alertView show];
    }
    
    
    [sock readDataWithTimeout:-1 tag:tag];
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    NSManagedObjectContext * managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - UIAlertView delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //查看详细订单
        NSLog(@"查看订单:%@", _order_no);
        ThirdDetailVC * thirdDetailVC = [[ThirdDetailVC alloc] init];
        thirdDetailVC.order_id = _order_no;
        [self.startVC.navigationController pushViewController:thirdDetailVC animated:YES];
    }
}

@end
