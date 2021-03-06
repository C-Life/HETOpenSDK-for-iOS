//
//  ALLWIFIDeviceViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 15/6/25.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "ALLWIFIDeviceViewController.h"
#import "MainViewController.h"
#import "HETCommonHelp.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HETCircleLoader.h"
#import "CYAlertView.h"

@interface ALLWIFIDeviceViewController ()
{
    
        int                 _progress;
}
@property(strong,nonatomic) HETCircleLoader         *hub;
@end

@implementation ALLWIFIDeviceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.hub = [[HETCircleLoader alloc]init];
    [self.hub showInView:self.view];
    WEAKSELF;
    weakSelf.hub.cancelBind= ^{
        STRONGSELF;
        CYAlertView * _alerViewtFail=[[CYAlertView alloc]initWithTitle:@"取消绑定" message:@"您确定要取消绑定?" clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            if(buttonIndex==1)
            {
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
            
        } cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        
        [_alerViewtFail show];
        
    };


   
    
}
-(void)updataProgress
{
    _progress++;
    
    if(_progress<=100)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.hub.progressStr = [NSString stringWithFormat:@"绑定中...%d%@",_progress,@"%"];
            [self performSelector:@selector(updataProgress) withObject:nil afterDelay:1];
            
        });
    }
    else
    {
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _progress=0;
    
    [self updataProgress];
 
    if (self.moduleIdStr.integerValue==70)//AP模式设备
    {
        [self updateCurrentWiFiState];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0)
            {
                NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
                if ([[UIApplication sharedApplication] canOpenURL:url])
                {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
            else
            {
                NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
                if ([[UIApplication sharedApplication] canOpenURL:url])
                {
                    [[UIApplication sharedApplication] openURL:url];
                }
                
            }
            
            
        });
        
        return;
    }

    [[HETWIFIBindBusiness sharedInstance]startSmartLinkBindDeviceWithProductId:self.productId  withSSID:self.wifiSsid withPassWord:self.wifiPassword withTimeOut:100 bindHandler:^(HETWiFiDeviceBindState state, HETDevice *deviceObj, NSError *error) {
        NSLog(@"设备mac地址:%@,%@,绑定的状态:%d",deviceObj.macAddress,error,state);
        if(state==HETWiFiDeviceBinding)
        {
            NSLog(@"11111111:%@",deviceObj);
        }
      
       if(state==HETWiFiDeviceBindFail)
       {
           [HETCommonHelp HidHud];
           [self.navigationController popViewControllerAnimated:YES];
       }
        else if(state==HETWiFiDeviceBindSuccess)
        {
            [HETCommonHelp HidHud];
            for (UIViewController *tempCon in self.navigationController.viewControllers) {
                if([tempCon isKindOfClass:[MainViewController class]])
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToViewController:tempCon animated:YES];
                    });
                    
                }
            }
        }
    }];
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止扫描
    [[HETWIFIBindBusiness sharedInstance] stop];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)APBindAction
{
    [[HETWIFIBindBusiness sharedInstance]startAPBindDeviceWithProductId:self.productId
                                                       withDeviceTypeId:self.deviceTypeStr
                                                    withDeviceSubtypeId:self.deviceSubTypeStr
                                                               withSSID:self.wifiSsid
                                                           withPassWord:self.wifiPassword
                                                            withTimeOut:100
                                                      bindHandler:^(HETWiFiDeviceBindState state, HETDevice *deviceObj, NSError *error) {
                                                          NSLog(@"设备mac地址:%@,%@",deviceObj.macAddress,error);
                                                          if(state==HETWiFiDeviceBindFail)
                                                          {
                                                              
                                                              NSLog(@"绑定失败");
                                                              // 绑定失败
                                                              CYAlertView * _alerViewtFail=[[CYAlertView alloc]initWithTitle:@"绑定失败" message:@"绑定失败,是否重新绑定?" clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                                  
                                                              } cancelButtonTitle:@"退出" otherButtonTitles:@"重新绑定", nil];
                                                              
                                                              [_alerViewtFail show];
                                                              
                                                          }
                                                          else if(state==HETWiFiDeviceBindSuccess)
                                                          {
                                                              for (UIViewController *tempCon in self.navigationController.viewControllers) {
                                                                  if([tempCon isKindOfClass:[MainViewController class]])
                                                                  {
                                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                          [self.navigationController popToViewController:tempCon animated:YES];
                                                                      });
                                                                      
                                                                  }
                                                              }
                                                              
                                                          }
                                                          
                                                      }];
    
}
- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        //        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}
- (void)updateCurrentWiFiState
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *currentSsid =[[self fetchNetInfo] objectForKey:@"SSID"];
        if(self.radiocastName.length!=0 &&[[currentSsid uppercaseString] rangeOfString:[self.radiocastName uppercaseString]].length==0)
        {
            
            [self performSelector:@selector(updateCurrentWiFiState) withObject:nil afterDelay:1.0f];
        }
        else
        {
            NSString* srcSSID = [[self fetchNetInfo] valueForKey:@"SSID"];
            if([srcSSID rangeOfString:[self.radiocastName uppercaseString]].length)//判断当前所连AP设备的ssid
            {
                NSArray *separateSrcSSID = [srcSSID componentsSeparatedByString:@"_"];
                NSInteger srcDeviceTypeId = [self  hexStrToInt:[[separateSrcSSID objectAtIndex:1] substringWithRange:NSMakeRange(0, 4)]];
                NSInteger srcDeviceSubTypeId = [self  hexStrToInt:[[separateSrcSSID objectAtIndex:1] substringWithRange:NSMakeRange(4, 2)]];
                
                if((self.deviceTypeStr.integerValue == srcDeviceTypeId)&&(self.deviceSubTypeStr.integerValue == srcDeviceSubTypeId))
                {
                    
                    [self APBindAction];
                    
                }
                else
                {
                    [self performSelector:@selector(updateCurrentWiFiState) withObject:nil afterDelay:1.0f];
                }
            }
            else
            {
                [self performSelector:@selector(updateCurrentWiFiState) withObject:nil afterDelay:1.0f];
            }
        }
        // NSLog(@"当前SSID:%@",[[self fetchNetInfo] valueForKey:@"SSID"]);
    });
}
//10进制转16进制
+(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i =0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

// 将16进制字符串转换为10进制数字
- (NSInteger)hexStrToInt:(NSString *)str
{
    const char *hexChar = [str cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    //    NSLog(@"%ld",(NSInteger)hexNumber);
    return (NSInteger)hexNumber;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
