//
//  BLEDeviceViewController.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 2017/4/15.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HETBaseViewController.h"


@interface BLEDeviceViewController : HETBaseViewController
@property(nonatomic,strong)CBPeripheral *blePeripheral;
@property(nonatomic,strong)NSString  *macAddress;
@property(nonatomic,assign)NSUInteger deviceType;
@property(nonatomic,assign)NSUInteger deviceSubType;
@property(nonatomic,assign)NSUInteger productId;
@property(nonatomic,assign)NSString  *deviceId;
@end
