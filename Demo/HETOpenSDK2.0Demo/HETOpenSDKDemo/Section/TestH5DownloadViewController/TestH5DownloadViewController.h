//
//  TestH5ViewController.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 2017/10/24.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HETBaseViewController.h"
#import <WebKit/WebKit.h>

@interface TestH5DownloadViewController : HETBaseViewController
/** 设备信息 **/
@property (nonatomic, strong)  HETDevice *deviceModel;
/** H5资源路径 **/
@property(nonatomic,copy) NSString *h5Path;

/** 加载H5webView **/
@property (nonatomic,strong) WKWebView *wkWebView;
@end
