//
//  ALLBleDeviceViewController.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 2017/4/11.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HETBaseViewController.h"
@interface bindBleDeviceViewController:HETBaseViewController
@property(nonatomic,strong)NSString *bindTypeStr;
@property(nonatomic,strong)NSString *deviceTypeStr;
@property(nonatomic,strong)NSString *deviceSubTypeStr;
@property(nonatomic,strong)NSString *moduleIdStr;
@property(nonatomic,strong)NSString *productIdStr;

@end
