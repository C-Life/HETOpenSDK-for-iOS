//
//  HETChooseSubDeviceViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/8/8.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "HETChooseSubDeviceViewController.h"
#import "SVPullToRefresh.h"
#import "ScanWIFIViewController.h"
#import "bindBleDeviceViewController.h"
#import "ChooseSubDeviceTableViewCell.h"
#import <HETMattressDeviceSDK/HETMattressDeviceSDK.h>
#import "HETCommonHelp.h"
#import "MainViewController.h"

#define kCellHeight  70



@interface HETChooseSubDeviceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSArray *_arData;
     HETBLEMattressDevice *_mattressDevice;
    
}

@property(strong,nonatomic) UITableView *tableView;

@end

@implementation HETChooseSubDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarTitle:[self.deviceDic objectForKey:@"deviceTypeName"]];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }
        else
        {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    
    WEAKSELF;
    [self.tableView addPullToRefreshWithActionHandler:^{
        STRONGSELF;
        [strongSelf loadNewData];
    }];
    
    [self.tableView triggerPullToRefresh];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)loadNewData
{
    NSString *deviceTypeId=[NSString stringWithFormat:@"%@",self.deviceDic[@"deviceTypeId"]];
    [HETDeviceRequestBusiness fetchDeviceProductListWithDeviceTypeId:deviceTypeId success:^(id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code=[responseObject objectForKey:@"code"];
            NSArray *arrayValue=[responseObject objectForKey:@"data"];
            if(code.intValue==0)
            {
                _arData=arrayValue;
                [self.tableView reloadData];
            }
            
        }
        [self.tableView.pullToRefreshView stopAnimating];
        
    } failure:^(NSError *error) {
        [self.tableView.pullToRefreshView stopAnimating];
        
    }];
    
}
-(void)scanBleDeviceAction:(NSUInteger)productId{
    
    [HETCommonHelp showCustomHudtitle:@"正在扫描蓝牙设备"];
    _mattressDevice=nil;
    _mattressDevice=[[HETBLEMattressDevice alloc]init];
    WEAKSELF;
    [_mattressDevice scanBleDevicesProductId:productId timeOut:10 scanBleDevices:^(NSArray<LGPeripheral *> *deviceArray, NSError *error) {
        if(error)
        {
            NSLog(@"蓝牙扫描失败:%@",error);
            [HETCommonHelp HidHud];
            [HETCommonHelp showAutoDissmissAlertView:nil msg:@"蓝牙扫描失败"];
            [_mattressDevice disconnect];
            _mattressDevice=nil;
        }
        else
        {
            [HETCommonHelp HidHud];
            [HETCommonHelp showCustomHudtitle:@"正在绑定蓝牙设备"];
            LGPeripheral *per=[deviceArray firstObject];
            
            [_mattressDevice bindBleDevice:per deviceProductId:productId successBlock:^(NSString *deviceId){
                [_mattressDevice disconnect];
                _mattressDevice=nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HETCommonHelp HidHud];
                    [HETCommonHelp showAutoDissmissAlertView:nil msg:@"蓝牙绑定成功"];
                    for (UIViewController *tempCon in self.navigationController.viewControllers) {
                        if([tempCon isKindOfClass:[MainViewController class]])
                        {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popToViewController:tempCon animated:YES];
                            });
                            
                        }
                    }
                });
                
            } failBlock:^(NSError *error) {
                NSLog(@"绑定失败");
                [_mattressDevice disconnect];
                _mattressDevice=nil;
                [HETCommonHelp HidHud];
                [HETCommonHelp showAutoDissmissAlertView:nil msg:@"蓝牙绑定失败"];
            }];
            
        }
        
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(!_arData.count)
    {
        return 1;
    }
    
    return _arData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!_arData.count)
    {
        static NSString * CellIdentifier = @"UITableViewCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.backgroundColor =[UIColor whiteColor];
        UIImage *pullTipsImage=[UIImage imageNamed:@"pulltips"];
        UIImageView *pullTipsImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        pullTipsImageView.image=pullTipsImage;
        [cell.contentView addSubview:pullTipsImageView];
        [pullTipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.centerY.equalTo(cell.contentView.mas_centerY).offset(-pullTipsImage.size.height)
            ;
            make.width.equalTo(@(pullTipsImage.size.width));
            make.height.equalTo(@(pullTipsImage.size.height));
        }];
        
        UIImage *pullImage=[UIImage imageNamed:@"pull"];
        UIImageView *pullImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        pullImageView.image=pullImage;
        [cell.contentView addSubview:pullImageView];
        [pullImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.centerY.equalTo(cell.contentView.mas_centerY).offset(pullImage.size.height/2.0)
            ;
            make.width.equalTo(@(pullImage.size.width));
            make.height.equalTo(@(pullImage.size.height));
        }];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        
        static NSString * CellIdentifier = @"ChooseSubDeviceTableViewCell";
        ChooseSubDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[ChooseSubDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSDictionary *dic=[_arData objectAtIndex:indexPath.row];
        cell.deviceModelLabel.text=[dic objectForKey:@"deviceSubtypeName"];
        NSString *str=[dic objectForKey:@"productCode"];
        if([str isKindOfClass:[NSNull class]])
        {
            cell.deviceNameLabel.text=[dic objectForKey:@"deviceSubtypeName"];
        }
        else
        {
            
            if([str isEqualToString:@"CC-1001"])
            {
                NSString *productNameStr=[dic objectForKey:@"productName"];
                if(productNameStr.length)
                {
                    cell.deviceNameLabel.text=productNameStr;
                }
                else
                {
                    cell.deviceNameLabel.text=[dic objectForKey:@"deviceSubtypeName"];
                }
                
            }
            else
            {
                cell.deviceNameLabel.text=[dic objectForKey:@"productCode"];
            }
        }
        
        return cell;
        
        
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_arData.count)
    {
        return tableView.frame.size.height;
    }
    
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!_arData.count){
        return;
    }
    
    NSDictionary *dic=[_arData objectAtIndex:indexPath.row];
    NSLog(@"dic:%@",dic);
    if(!dic)
    {
        return;
    }
    NSString *bindTypeStr=[NSString stringWithFormat:@"%@", [dic objectForKey:@"moduleType"]];
    NSString *deviceTypeStr=[NSString stringWithFormat:@"%@", [dic objectForKey:@"deviceTypeId"]];
    NSString *deviceSubTypeStr=[NSString stringWithFormat:@"%@", [dic objectForKey:@"deviceSubtypeId"]];
    NSString *moduleIdStr=[NSString stringWithFormat:@"%@", [dic objectForKey:@"moduleId"]];
    NSString *productId=[NSString stringWithFormat:@"%@", [dic objectForKey:@"productId"]];
    if(bindTypeStr.intValue==1)//wifi绑定
    {
        
        ScanWIFIViewController *vc=[[ScanWIFIViewController alloc]init];
        vc.bindTypeStr=bindTypeStr;
        vc.deviceTypeStr=deviceTypeStr;
        vc.deviceSubTypeStr=deviceSubTypeStr;
        vc.moduleIdStr=moduleIdStr;
        vc.productIdStr=productId;
        vc.radiocastName=dic[@"radiocastName"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (bindTypeStr.intValue==2)//蓝牙绑定
    {
        if(deviceTypeStr.integerValue==6)
        {
            [self scanBleDeviceAction:productId.integerValue];
            return;
        }
        bindBleDeviceViewController *vc=[[bindBleDeviceViewController alloc]init];
        vc.bindTypeStr=bindTypeStr;
        vc.deviceTypeStr=deviceTypeStr;
        vc.deviceSubTypeStr=deviceSubTypeStr;
        vc.moduleIdStr=moduleIdStr;
        vc.productIdStr=productId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    
}
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark tableView
-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor=self.view.backgroundColor;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}


@end
