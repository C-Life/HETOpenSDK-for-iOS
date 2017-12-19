//
//  HETWIFIUpgradeViewController.h
//  HETOpenSDKDemo
//
//  Created by Newman on 15/8/10.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HETBaseViewController.h"
@interface HETWIFIUpgradeViewController : HETBaseViewController

@property (nonatomic,copy  ) NSString  * deviceId;
@property (nonatomic,copy  ) NSString  * versionType;
@property (nonatomic,copy  ) HETDeviceVersionModel *deviceVersionModel;
@property (nonatomic,assign) NSInteger deviceTypeId;

@end
