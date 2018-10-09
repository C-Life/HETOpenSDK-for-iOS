//
//  HETDevice.h
//  HETOpenSDK
//
//  Created by mr.cao on 16/12/29.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HETDevice : NSObject
/*********** 用户设备信息 deviceModel 小类列表接口需要用到 ***********/
@property (nonatomic, copy) NSString *authUserId;//授权设备用户标识
@property (nonatomic, strong) NSNumber *controlType;//控制类型（1-原生，2-插件，3-H5插件）
@property (nonatomic, copy) NSString *bindTime;//绑定时间
@property (nonatomic, strong) NSNumber *onlineStatus;//在线状态（1-正常，2-异常）
@property (nonatomic, strong) NSNumber *roomId;//房间标识
@property (nonatomic, copy) NSString *roomName;//房间名称
@property (nonatomic, strong) NSNumber *share;//设备分享（1-是，2-否，3-扫描分享）
@property (nonatomic, copy) NSString *userKey;//MAC与设备ID生成的KEY
@property (nonatomic, copy) NSString *deviceIcon;//设备图标
@property (nonatomic, copy) NSString *deviceModel;//设备型号
@property (nonatomic, copy) NSString *developerId;//客户代码
@property (nonatomic, copy) NSString *deviceId;//设备标识
@property (nonatomic, copy) NSString *deviceName;//设备名称
/*********** 产品信息 ***********/
@property (nonatomic, strong) NSNumber *deviceBrandId;//产品品牌标识
@property (nonatomic, copy) NSString *deviceBrandName;//产品品牌名称
@property (nonatomic, copy) NSString *deviceCode;//设备编码
@property (nonatomic, strong) NSNumber *deviceSubtypeId;//设备子分标识
@property (nonatomic, copy) NSString *deviceSubtypeName;//设备子分类名称
@property (nonatomic, strong) NSNumber *deviceTypeId;//设备大分类标识
@property (nonatomic, copy) NSString *deviceTypeName;//设备大分类名称
@property (nonatomic, copy) NSString *macAddress;//MAC地址
@property (nonatomic, strong) NSNumber *moduleId;//设备模组ID
@property (nonatomic, copy) NSString *moduleName;//设备模组名字
@property (nonatomic, copy) NSString *productCode;//产品型号
@property (nonatomic, copy) NSString *productIcon;//产品型号图标
@property (nonatomic, strong) NSNumber *productId;//产品型号标识
@property (nonatomic, copy) NSString *productName;//产品名字
@property (nonatomic, strong) NSNumber *bindType;//设备绑定类型（1-WiFi，2-蓝牙，3-音频，4-GSM，5-红外）
@property (nonatomic, copy) NSString *ssid;//设备AP热点名
@property (nonatomic, copy) NSString *ssidPassword;//设备AP热点密码
@property (nonatomic, copy) NSString *barCode;//产品条形码
@property (nonatomic, copy) NSString *remark;//产品条形码
/*********** 新增的产品信息(radiocastName 跟ssid 重复，guideUrl 平台没有地方录入，moduleType跟bindType重复) ***********/
@property (nonatomic, copy) NSString *radiocastName;//设备广播名
@property (nonatomic, copy) NSString *guideUrl;//引导页URL
@property (nonatomic, strong) NSNumber *moduleType;//模块类型（1-WiFi，2-蓝牙，3-音频，4-GSM，5-红外，6-直连，8-zigbee，9-ap模式）
@end
