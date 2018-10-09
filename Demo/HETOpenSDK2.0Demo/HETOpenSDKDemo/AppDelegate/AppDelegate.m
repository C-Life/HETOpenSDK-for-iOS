//
//  AppDelegate.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/1/21.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"


NSString *const ktestAPPID =@"30765";
NSString *const ktestAPPSECRET =@"5f699a78c319444cb8a291296049572c";

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    // Override point for customization after application launch.
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 
    [HETOpenSDK registerAppId:ktestAPPID appSecret:ktestAPPSECRET];
    [HETOpenSDK setNetWorkConfig:HETNetWorkConfigType_PE];
    [HETOpenSDK openLog:YES];
    // 微信
    [HETOpenSDK setPlaform:HETAuthPlatformType_Wechat
                    appKey:@"wxdc1e388c3822c80b"
                 appSecret:@"3baf1193c85774b3fd9d18447d76cab0"
               redirectURL:nil];
    
    // 新浪微博
    [HETOpenSDK setPlaform:HETAuthPlatformType_Weibo
                    appKey:@"3921700954"
                 appSecret:nil
               redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    // QQ
    [HETOpenSDK setPlaform:HETAuthPlatformType_QQ
                    appKey:@"1105821097"
                 appSecret:nil
               redirectURL:nil];


    MainViewController *rootvc=[[MainViewController alloc]init];
    
    UINavigationController * rootNav = [[UINavigationController alloc] initWithRootViewController:rootvc];
    self.window.rootViewController = rootNav;
    [self.window makeKeyAndVisible];
    [UINavigationBar appearance].barTintColor =[UIColor colorWithRed:255.f/255.f green:115.f/255.f blue:181.f/255.f alpha:1];
    [UINavigationBar appearance].translucent=NO;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                         NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 17]};
    [HETH5Manager launch];
    


    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
    
    BOOL result = [HETOpenSDK application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他SDK回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [HETOpenSDK handleOpenURL:url];
    if (!result) {
        // 其他SDK回调
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
