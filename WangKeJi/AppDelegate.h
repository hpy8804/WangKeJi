//
//  AppDelegate.h
//  WangKeJi
//
//  Created by wzzyinqiang on 14-12-29.
//  Copyright (c) 2014年 wzzyinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"
#import "AsyncSocket.h"
#import "ServiceHelper.h"

@class StartVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate,AsyncSocketDelegate>

@property (strong, nonatomic) StartVC * startVC;
@property (strong, nonatomic) UIWindow * window;
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) NSArray * placeArray;
@property (strong, nonatomic) NSMutableDictionary * imageDic;
@property (strong, nonatomic) NSArray * keyArray;
@property (strong, nonatomic) NSArray * tasteArray;
@property (strong, nonatomic) NSString * shopStr;
@property (strong, nonatomic) NSString * shopID;
@property (strong, nonatomic) NSMutableArray * foodNumberArray;
@property (strong, nonatomic) NSString * user_id;
@property (strong, nonatomic) NSString * password;
@property (strong, nonatomic) NSString *user_ip;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (strong, nonatomic) NSString *order_no;
//@property (nonatomic, readonly) XMPPStream * xmppStream;
//@property (nonatomic, strong) XMPPOutgoingFileTransfer * xmppSend;
@property (strong, nonatomic) AsyncSocket * socket;
//@property (strong, nonatomic) GCDAsyncSocket * gcdSocket;
@property (assign, nonatomic) BOOL isLogined;
@property(nonatomic,assign)BOOL isRegisterUser;
//@property(nonatomic,strong,readonly)XMPPvCardTempModule * xmppvCardModule;
//@property(nonatomic,strong,readonly)XMPPvCardAvatarModule * xmppvCardAvatarModule;
//@property(nonatomic,strong,readonly)XMPPRoster * xmppRoster;
//@property(nonatomic,strong,readonly)XMPPRosterCoreDataStorage * xmppRosterCoreDataStorage;

//@property(nonatomic,strong,readonly)XMPPMessageArchiving * xmppMessageArchiving;
//@property(nonatomic,strong,readonly)XMPPMessageArchivingCoreDataStorage * xmppMessageArchivingCoreDataStorage;

- (UIImage*)load_image:(NSString*)imageURL;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

