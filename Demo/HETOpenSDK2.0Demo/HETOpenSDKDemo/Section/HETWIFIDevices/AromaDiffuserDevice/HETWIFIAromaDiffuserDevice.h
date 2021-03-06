//
//  HETWIFIAromaDiffuserDevice.h
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/2/29.
//  Copyright © 2016年 mr.cao. All rights reserved.
//  香薰机设备控制类

#import <Foundation/Foundation.h>
#import "YYModel.h"
//#import "HETOpenSDK.h"
#import <HETOpenSDK/HETOpenSDK.h>
@interface AromaDiffuserDeviceConfigModel :NSObject

@property(nonatomic,copy) NSString *mist;//MIST键设置
@property(nonatomic,copy) NSString *light;//LIGHT键设置

@property(nonatomic,copy) NSString *timeClose;//定时关机(单位分钟)

@property(nonatomic,copy) NSString *presetStartupTime;//预约开机(单位分钟)

@property(nonatomic,copy) NSString *presetShutdownTime;//预约关机(单位分钟)
@property(nonatomic,copy) NSString *color;//颜色
@property(nonatomic,copy) NSString *updateFlag;//用户行为



/**
 *  updateFlag说明
 
 这个修改标记位是为了做统计和配置下发的时候设备执行相应的功能。
 
 例如，空气净化器（广磊K180）配置信息协议：
 
 紫外线(1)、负离子(2)、臭氧(3)、儿童锁(4)、开关(5)、WiFi(6)、过滤网(7)、模式(8)、定时(9)、风量(10)
 上面一共上10个功能，那么updateFlag就2个字节，没超过8个功能为1个字节，超过8个为2个字节，超过16个为3个字节，以此类推。
 
 打开负离子，2个字节，每一个bit的值为下：
 
 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
 
 
 
 
 参数名称	是否必须	字段类型	标记位	参数说明
 mist	是	number	1	雾（1-开机，2-停止）
 light	是	number	2	灯（1-高亮，2-暗亮，3-熄灭）
 color	是	number	4	颜色（0-熄灭，1-红色，2-橙色，3-黄色，4-绿色，5-青色，6-蓝色，7-紫色，8-白色）
 timeClose	是	number	5	定时关机(单位分钟)
 presetStartupTime	是	number	6	预约开机(单位分钟)
 presetShutdownTime	是	number	7	预约关机(单位分钟)
 updateFlag	是	number		修改标记（每bit中1表示修改）
 */
@end



@interface AromaDiffuserDeviceRunModel :NSObject

@property(nonatomic,copy) NSString *workMode;//工作键设置
@property(nonatomic,copy) NSString *workStatus;//工作状态
@property(nonatomic,copy) NSString *setTimeH;//设定工作时间小时
@property(nonatomic,copy) NSString *setTimeM;//设定工作时间分钟
@property(nonatomic,copy) NSString *remainingTimeH;//剩余时间小时
@property(nonatomic,copy) NSString *remainingTimeM;//剩余时间分钟
@property(nonatomic,copy) NSString *warningStatus1;//报警状态1
@property(nonatomic,copy) NSString *warningStatus2;//报警状态2
@property(nonatomic,copy) NSString *presetStartupTimeH;//预约开机时间小时
@property(nonatomic,copy) NSString *presetStartupTimeM;//预约开机时间分钟
@property(nonatomic,copy) NSString *presetStartupTimeLeftH;//预约开机剩余时间小时
@property(nonatomic,copy) NSString *presetStartupTimeLeftM;//预约开机剩余时间分钟
@property(nonatomic,copy) NSString *presetShutdownTimeH;//预约关机时间设置小时
@property(nonatomic,copy) NSString *presetShutdownTimeM;//预约关机时间设置分钟
@property(nonatomic,copy) NSString *presetShutdownTimeLeftH;//预约关机剩余时间小时
@property(nonatomic,copy) NSString *presetShutdownTimeLeftM;//预约关机剩余时间分钟
@property(nonatomic,copy) NSString *light;//灯
@property(nonatomic,copy) NSString *color;//七彩灯的颜色选择
@property(nonatomic,copy) NSString *outputLoad1;//输出负载状态1
@property(nonatomic,copy) NSString *outputLoad2;//输出负载状态2
@property(nonatomic,copy) NSString *mist;//雾
@property(nonatomic,copy) NSString *cumulativeTime1;//累积工作时间高位小时
@property(nonatomic,copy) NSString *cumulativeTime2;//累积工作时间中位小时
@property(nonatomic,copy) NSString *cumulativeTime3;//累积工作时间低位小时
@property(nonatomic,copy) NSString *cumulativeTime4;//累积工作时间分钟
@property(nonatomic,copy) NSString *cumulativeWorkTimes1;//累积工作次数高位
@property(nonatomic,copy) NSString *cumulativeWorkTimes2;//累积工作次数中位
@property(nonatomic,copy) NSString *cumulativeWorkTimes3;//累积工作次数低位


@end









@interface HETWIFIAromaDiffuserDevice : NSObject

/**
 *
 *
 *  @param userKey               设备控制的key
 *  @param deviceId              设备ID号
 *  @param deviceMac             设备mac地址
 *  @param deviceTypeId          设备主类型
 *  @param deviceSubtypeId       设备子类型
 *  @param runDataSuccessBlock   设备运行数据成功block回调
 *  @param runDataFailBlock      设备运行数据失败block回调
 *  @param cfgDataSuccessBlock   设备配置数据成功block回调
 *  @param cfgDataFailBlock      设备配置数据失败block回调
 */


- (instancetype)initWithHetDeviceModel:(HETDevice *)device
                  deviceRunDataSuccess:(void(^)(AromaDiffuserDeviceRunModel *model))runDataSuccessBlock
                     deviceRunDataFail:(void(^)(NSError *error))runDataFailBlock
                  deviceCfgDataSuccess:(void(^)(AromaDiffuserDeviceConfigModel *model))cfgDataSuccessBlock
                     deviceCfgDataFail:(void(^)(NSError *error))cfgDataFailBlock;




//启动服务
- (void)start;
//停止服务
- (void)stop;

//是否是小循环

-(BOOL)isLittleLoop;

/**
 *  设备控制
 *
 *  @param model   设备控制的HumidifierDeviceConfigModel模型
 *  @param successBlock 控制成功的回调
 *  @param failureBlock 控制失败的回调
 */
- (void)deviceControlRequestWithModel:(AromaDiffuserDeviceConfigModel *)model withSuccessBlock:(void(^)(id responseObject))successBlock withFailBlock:(void(^)( NSError *error))failureBlock;


@end
