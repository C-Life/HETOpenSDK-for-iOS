//
//  MattressDeviceViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 17/1/11.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import "HETMattressDeviceViewController.h"
#import <HETMattressDeviceSDK/HETMattressDeviceSDK.h>
#import "HETCommonHelp.h"
@interface HETMattressDeviceViewController()
{
    HETBLEMattressDevice *_mattressDevice;
}
@property(nonatomic,strong)UIButton *fetchRealTimeDataBtn;
@property(nonatomic,strong)UIButton *fetchHistoryDataBtn;
@property(nonatomic,strong)UIButton *fetchSummaryDayDataBtn;
@property(nonatomic,strong)UIButton *fetchDayDataListBtn;



@end

@implementation HETMattressDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:@"睡眠带子设备"];

    int btnHeight=64;
    int xpadding=15;
    int ypadding=(CGRectGetHeight([UIScreen mainScreen].bounds)-btnHeight*4-64)/5;
    [self.view addSubview:self.fetchRealTimeDataBtn];
    [self.view addSubview:self.fetchHistoryDataBtn];
    [self.view addSubview:self.fetchSummaryDayDataBtn];
    [self.view addSubview:self.fetchDayDataListBtn];

    
    [self.fetchRealTimeDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(ypadding);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(xpadding);;
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-xpadding);;
            make.height.equalTo(@(btnHeight));
        }
        else
        {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(ypadding);
        make.left.equalTo(self.view.mas_left).offset(xpadding);
        make.right.equalTo(self.view.mas_right).offset(-xpadding);
        make.height.equalTo(@(btnHeight));
        }
    }];
    
    [self.fetchHistoryDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fetchRealTimeDataBtn.mas_bottom).offset(ypadding);
        make.centerX.equalTo(self.fetchRealTimeDataBtn.mas_centerX);
        make.width.equalTo(self.fetchRealTimeDataBtn.mas_width);
        make.height.equalTo(self.fetchRealTimeDataBtn.mas_height);
    }];
    
    [self.fetchSummaryDayDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fetchHistoryDataBtn.mas_bottom).offset(ypadding);
        make.centerX.equalTo(self.fetchHistoryDataBtn.mas_centerX);
        make.width.equalTo(self.fetchHistoryDataBtn.mas_width);
        make.height.equalTo(self.fetchHistoryDataBtn.mas_height);
    }];
    
    
    [self.fetchDayDataListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fetchSummaryDayDataBtn.mas_bottom).offset(ypadding);
        make.centerX.equalTo(self.fetchSummaryDayDataBtn.mas_centerX);
        make.width.equalTo(self.fetchSummaryDayDataBtn.mas_width);
        make.height.equalTo(self.fetchSummaryDayDataBtn.mas_height);
        
    }];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _mattressDevice=[[HETBLEMattressDevice alloc]init];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //断开蓝牙
    [_mattressDevice disconnect];
    _mattressDevice=nil;
}
-(void)fetchRealTimeDataBtnAction
{
    WEAKSELF;
     [HETCommonHelp showCustomHudtitle:@"正在获取蓝牙实时数据"];
    [_mattressDevice fetchRealTimeDataWithBLEBroadName:weakSelf.currentBroadName withDeviceId:weakSelf.deviceId successBlock:^(HETBLEMattressDeviceInfo *deviceInfo) {
        NSLog(@"deviceInfo:%@",deviceInfo);
        [HETCommonHelp HidHud];
        [HETCommonHelp showAutoDissmissAlertView:nil msg:@"蓝牙实时数据成功"];
    } failBlock:^(NSError *error) {
        NSLog(@"error:%@",error);
        [HETCommonHelp HidHud];
        [HETCommonHelp showAutoDissmissAlertView:nil msg:@"蓝牙实时数据失败"];
    }];
 
}
-(void)fetchHistoryDataBtnAction
{
     [HETCommonHelp showCustomHudtitle:@"正在获取蓝牙历史数据"];
   [_mattressDevice fetchHistoryDatawithBLEBroadName:self.currentBroadName withDeviceId:self.deviceId successBlock:^{
       NSLog(@"获取历史数据成功");
       [HETCommonHelp HidHud];
       [HETCommonHelp showAutoDissmissAlertView:nil msg:@"蓝牙历史数据成功"];
       
   } failBlock:^(NSError *error) {
       NSLog(@"获取历史数据失败:%@",error);
       [HETCommonHelp HidHud];
       [HETCommonHelp showAutoDissmissAlertView:nil msg:@"蓝牙历史数据失败"];

   } progressiveBlock:^(NSInteger totalBytesRead, NSInteger totalBytesExpected) {
       NSLog(@"获取历史数据进度%ld-%ld,%d%@",(long)totalBytesRead,(long)totalBytesExpected,totalBytesRead*100/totalBytesExpected,@"%");

   }];
}

-(void)fetchSummaryDayDataBtnAction
{
     [HETCommonHelp showCustomHudtitle:@"正在获取天报告数据"];
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    NSLog(@"locationString:%@", locationString);
    
    
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    
    NSString *lastlocationString = [dateformatter stringFromDate:yesterday];
    NSLog(@"lastlocationString:%@", lastlocationString);
    
    [HETBLEMattressDevice fetchMattressDeviceSummaryDayDataWithDeviceId:self.deviceId dataTime:lastlocationString successBlock:^(id responseObject) {
        NSLog(@"天报告详细:%@",responseObject);
        [HETCommonHelp HidHud];
        [HETCommonHelp showAutoDissmissAlertView:nil msg:@"天报告数据成功"];
    } failBlock:^(NSError *error) {
        NSLog(@"天报告详细:%@",error);
        [HETCommonHelp HidHud];
        [HETCommonHelp showAutoDissmissAlertView:nil msg:@"天报告数据失败"];
    }];
    

}


-(void)fetchDayDataListAction
{
     [HETCommonHelp showCustomHudtitle:@"正在获取统计报告数据"];
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    NSLog(@"locationString:%@", locationString);
    
    
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    
    NSString *lastlocationString = [dateformatter stringFromDate:yesterday];
    NSLog(@"lastlocationString:%@", lastlocationString);
    

    [HETBLEMattressDevice fetchMattressDeviceDayDataListWithDeviceId:self.deviceId startDate:lastlocationString endDate:locationString successBlock:^(id responseObject) {
      
        NSLog(@"统计报告:%@",responseObject);
        [HETCommonHelp HidHud];
        [HETCommonHelp showAutoDissmissAlertView:nil msg:@"统计报告数据成功"];
    } failBlock:^(NSError *error) {
        NSLog(@"统计报告:%@",error);
        [HETCommonHelp HidHud];
        [HETCommonHelp showAutoDissmissAlertView:nil msg:@"统计报告数据失败"];
    }];

}

-(UIButton *)fetchRealTimeDataBtn
{
    
    if(!_fetchRealTimeDataBtn)
    {
        _fetchRealTimeDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_fetchRealTimeDataBtn setTitle:@"获取睡眠带子实时数据" forState:UIControlStateNormal];
        [_fetchRealTimeDataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fetchRealTimeDataBtn addTarget:self action:@selector(fetchRealTimeDataBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _fetchRealTimeDataBtn.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
        
        
    }
    return _fetchRealTimeDataBtn;
}
-(UIButton *)fetchHistoryDataBtn
{
    if(!_fetchHistoryDataBtn)
    {
        UIButton *fetchHistoryDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fetchHistoryDataBtn setTitle:@"获取睡眠带子历史数据" forState:UIControlStateNormal];
        [fetchHistoryDataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [fetchHistoryDataBtn addTarget:self action:@selector(fetchHistoryDataBtnAction) forControlEvents:UIControlEventTouchUpInside];
        fetchHistoryDataBtn.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
        _fetchHistoryDataBtn=fetchHistoryDataBtn;
        
    }
    return _fetchHistoryDataBtn;
}







-(UIButton *)fetchDayDataListBtn
{
    if(!_fetchDayDataListBtn)
    {
        UIButton *fetchDayDataListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fetchDayDataListBtn setTitle:@"获取睡眠带子统计报告数据" forState:UIControlStateNormal];
        [fetchDayDataListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [fetchDayDataListBtn addTarget:self action:@selector(fetchDayDataListAction) forControlEvents:UIControlEventTouchUpInside];
        fetchDayDataListBtn.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
        _fetchDayDataListBtn=fetchDayDataListBtn;
        
    }
    return _fetchDayDataListBtn;
}
-(UIButton *)fetchSummaryDayDataBtn
{
    if(!_fetchSummaryDayDataBtn)
    {
        UIButton *fetchSummaryDayDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fetchSummaryDayDataBtn setTitle:@"获取睡眠带子天报告数据" forState:UIControlStateNormal];
        [fetchSummaryDayDataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [fetchSummaryDayDataBtn addTarget:self action:@selector(fetchSummaryDayDataBtnAction) forControlEvents:UIControlEventTouchUpInside];
        fetchSummaryDayDataBtn.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
        _fetchSummaryDayDataBtn=fetchSummaryDayDataBtn;
        
        
    }
    return _fetchSummaryDayDataBtn;
}
@end
