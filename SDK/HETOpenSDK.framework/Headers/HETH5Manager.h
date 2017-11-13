//
//  HETH5Manager.h
//  HETPublicSDK_HETH5DeviceControl
//
//  Created by tl on 16/4/11.
//  Copyright © 2016年 HET. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface HETH5Manager : NSObject
/**
 *  请在程序启动时调用
 *
 *  @param appSign 包签名,与H5商量决定
 */
+(void)launchWithAppSign:(NSString *)appSign;


/*
 为方便H5开发人员本地调试H5，结合现有iOS家电方案，现统一如下方案：
 
 1. 通过在手机浏览器中输入特定url打开app时，仅限本次app的生命周期内，H5地址变为联调地址，App关闭即结束联调。
 
 2. 联调仅限于测试包、开发包；上应用市场的App不开放通道。
 
 3. url规范为："App Scheme" + "://h5testurl/" + "H5地址(写到page上一层)" + "?productId=(产品id)",
 
 例如：
 `HETcappliances://h5testurl/10.8.5.148/app-h5-dev2/household/airpurifier-ds?productId=11`
 */

/**
 支持替换H5地址为联调地址

 @param url - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url 中的url
 @param schemeStr app的scheme
 @return 是否支持联调打开
 */
+(BOOL)handleOpenURL:(NSURL *)url scheme:(NSString *)schemeStr;

/**
 *  单个设备初始化，productId必须传
 */
+(instancetype)deviceId:(nullable NSString *)deviceId productId:(NSString*)productId;
/**
 *  单个设备初始化(虚拟设备时使用)
 *
 *  @param deviceSign 设备sign 格式为：包签名.h5.XXX      请与H5沟通
 *
 *  @return
 */
+(instancetype)deviceWithSign:(NSString*)deviceSign;

/**
 解决WK框架的bug，http://stackoverflow.com/questions/24882834/wkwebview-not-loading-local-files-under-ios-8
 如果有引用WKWebView并在iOS8上调用，请在上面方法后追加下面的方法。
 */
-(instancetype)useForWKFor8;


/**
 *  必须通过此方法来获取设备控制所需的h5
 *
 *  @param vc      在哪个页面需要推入到设备控制页面
 *  @param controllers 需要各个app自行去构造导航栏的层级，因为涉及到下载配置页面的跳转。
 *
 *  @waring ！！！！！
 *  @waring ！！！！！
 *  注意：不要用removeLastObject来调整导航栏navigationController.viewControllers的层级（无法知道是否还有配置页面）
 *  @waring ！！！！！
 *  @waring ！！！！！
 */
-(void)configWithController:(UIViewController *)vc controllers:(NSArray<UIViewController *>* (^)(NSString *h5PagePath))success;


/**
 *  当用户点击返回首页的方法，default：popToRootController
 */
@property (nonatomic,copy)void (^backToHome)();


/**
 当H5报错时，需要修复（清空本地存储数据，并调用 configWithController:controllers: 方法）
 */
-(void)needFixH5;
@end
NS_ASSUME_NONNULL_END
