//
//  ScanViewController.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 15/6/25.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//  WiFi扫描的界面

#import <UIKit/UIKit.h>
#import "HETBaseViewController.h"

@interface ScanWIFIViewController :HETBaseViewController
@property(nonatomic,strong)NSString *bindTypeStr;
@property(nonatomic,strong)NSString *deviceTypeStr;
@property(nonatomic,strong)NSString *deviceSubTypeStr;
@property(nonatomic,strong)NSString *moduleIdStr;
@property(nonatomic,strong)NSString *productIdStr;
@property(nonatomic,strong)NSString  *radiocastName;
@end
