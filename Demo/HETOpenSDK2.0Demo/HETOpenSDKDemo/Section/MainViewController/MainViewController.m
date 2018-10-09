//
//  MainViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 16/1/21.
//  Copyright © 2016年 mr.cao. All rights reserved.
//

#import "MainViewController.h"
#import "SVPullToRefresh.h"
#import "ScanWIFIViewController.h"
#import "AromaDiffuserViewController.h"
#import "HETChooseDeviceViewController.h"
#import "AllBindDeviceTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "BLEDeviceViewController.h"
#import "CYAlertView.h"
#import "TestH5BridgeViewController.h"
#import "TestH5DownloadViewController.h"
#import "HETMattressDeviceViewController.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_allDeviceDataSouce;
    
}
@property(strong,nonatomic)UITableView *allBindDeviceTableView;
@property(strong,nonatomic)UIButton    *addDeviceButton;
@property (nonatomic, strong) HETAuthorize *auth;

@property (nonatomic, strong) HETDeviceControlBusiness *business;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    if (IOS_IS_AT_LEAST_7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.allBindDeviceTableView];
    [self.view addSubview:self.addDeviceButton];
    [self.addDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.height.equalTo(@44);
        }
        else
        {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@44);
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    [self.allBindDeviceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }
        else
        {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.mas_topLayoutGuideBottom);
            make.bottom.equalTo(self.addDeviceButton.mas_top);
        }
    }];
    if(!self.auth)
    {
        self.auth = [[HETAuthorize alloc] init];
    }
    
    if ([self.auth isAuthenticated])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换账号" style:UIBarButtonItemStyleDone target:self action:@selector(loginBtnClick)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(loginBtnClick)];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改密码" style:UIBarButtonItemStyleDone target:self action:@selector(unBindBtnClick)];
    
    
        // accessToken失效  异地登陆
        [self stopObserveLoginNotification];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(presentLoginView:)
                                                     name: HETLoginOffNotification
                                                   object: nil];
    
}
- (void)stopObserveLoginNotification{
    
    // accessToken失效  异地登陆
     [[NSNotificationCenter defaultCenter] removeObserver:self
     name:HETLoginOffNotification
     object:nil];
    
    
    
    
    
}
- (void)presentLoginView: (NSNotification *)notification
{
    NSDictionary *loginStatusDic = notification.userInfo;
    if(!loginStatusDic)
    {
        [self loginBtnClick];
    }
    else
    {
        NSString *msgStr = [loginStatusDic objectForKey:NSLocalizedDescriptionKey];
        NSLog(@"--%@",msgStr);
        NSMutableArray *msgArr = [[NSMutableArray alloc]initWithArray:[msgStr componentsSeparatedByString:@"#"]];
        if (msgArr.count == 3) {
            NSString *utcTimeStr = msgArr[1];
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            [formatter setDateFormat:@"HH:mm"];
            NSDate * utcDate = [formatter dateFromString:utcTimeStr];
            NSDate * nowDate = [self getNowDateFromatAnDate:utcDate];
            NSString *nowStr = [formatter stringFromDate:nowDate];
            [msgArr replaceObjectAtIndex:1 withObject:nowStr];
        }
        
        NSString *msg = [msgArr componentsJoinedByString:@""];
        CYAlertView * _alerView=[[CYAlertView alloc]initWithTitle:nil message:msg clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            if(buttonIndex==0)
            {
                [self loginBtnClick];
            }
            
        } cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [_alerView show];
        
    }
}
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // [self setNavigationBarTitle:@"我的设备"];
    [self setLeftBarButtonItemHide:YES];
    WEAKSELF;
    [self.allBindDeviceTableView addPullToRefreshWithActionHandler:^{
        STRONGSELF;
        //获取绑定的设备列表
        [HETDeviceRequestBusiness fetchAllBindDeviceSuccess:^(NSArray<HETDevice *> *deviceArray) {
            _allDeviceDataSouce=[deviceArray copy];
            [strongSelf.allBindDeviceTableView reloadData];
            [strongSelf.allBindDeviceTableView.pullToRefreshView stopAnimating];
        } failure:^(NSError *error) {
            _allDeviceDataSouce=nil;
            [strongSelf.allBindDeviceTableView reloadData];
            [strongSelf.allBindDeviceTableView.pullToRefreshView stopAnimating];
        }];
        
    }];
    
    [self.allBindDeviceTableView triggerPullToRefresh];
    //检查SDK是否已经授权登录，否则不能使用
    if(!self.auth)
    {
        self.auth = [[HETAuthorize alloc] init];
    }
    
    if (![self.auth isAuthenticated]) {
        [self setNavigationBarTitle:@"未登录"];
        //self.allBindDeviceTableView.hidden=YES;
        //        [self.auth authorizeWithCompleted:^(HETAccount *account, NSError *error) {
        //            NSLog(@"%@,token:%@",account,account.accessToken);
        //            [self.allBindDeviceTableView triggerPullToRefresh];
        //        }];
        
    }
    else
    {
        [self setNavigationBarTitle:@"已登录"];
        // self.allBindDeviceTableView.hidden=NO;
        //[self.allBindDeviceTableView triggerPullToRefresh];
    }
    // [self.auth getUserInformationSuccess:^(id responseObject) {
    //
    // } failure:^(NSError *error) {
    //
    // }];
    
    
}

#pragma mark ------登录
- (void)loginBtnClick {
    [self setNavigationBarTitle:@"未登录"];
    [self.auth unauthorize];
    [self.auth authorizeWithCompleted:^(NSString *openId, NSError *error) {
        NSLog(@"\n****************************************************\n\
              openId: %@\
              \n****************************************************\n",openId);
        if(!error)
        {
            [self setNavigationBarTitle:@"已登录"];
            // self.allBindDeviceTableView.hidden=NO;
            [self.allBindDeviceTableView triggerPullToRefresh];
            
        }
        else
        {
            //self.allBindDeviceTableView.hidden=YES;
        }
    }];
}

- (void)unBindBtnClick {
    
    [self.auth changePasswordSuccess:^(id responseObject) {
        NSLog(@"修改密码成功");
    } failure:^(NSError *error) {
        NSString *errString = [NSString stringWithFormat:@"%@",error];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
}


- (void)addDeviceAction
{
    HETChooseDeviceViewController *vc=[[HETChooseDeviceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}







/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allDeviceDataSouce.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"UITableViewCell";
    AllBindDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[AllBindDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    HETDevice *deviceModel=[_allDeviceDataSouce objectAtIndex:indexPath.row];
    
    NSString *imageUrl=deviceModel.productIcon;
    NSString *deviceName=deviceModel.deviceName;
    NSString *deviceMac=deviceModel.macAddress;
    NSNumber *deviceOnOff=deviceModel.onlineStatus;
    cell.deviceNameLabel.text=deviceName;
    cell.deviceMacLabel.text=deviceMac;
    if(deviceOnOff.intValue==1)
    {
        cell.deviceOnoffLabel.text=@"在线";
        cell.deviceOnoffLabel.textColor=[UIColor blueColor];
    }
    else if(deviceOnOff.intValue==2)
    {
        cell.deviceOnoffLabel.text=@"离线";
        cell.deviceOnoffLabel.textColor=[UIColor grayColor];
    }
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          placeholderImage:[UIImage imageNamed:@"refrigerator"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HETDevice *deviceModel=[_allDeviceDataSouce objectAtIndex:indexPath.row];
    NSNumber *deviceBindType=deviceModel.moduleType;
    NSNumber *deviceTypeId=deviceModel.deviceTypeId;
    NSNumber *deviceOnOff=deviceModel.onlineStatus;
    if (deviceBindType.integerValue==2&&deviceOnOff.integerValue==1&&deviceTypeId.integerValue==6)//睡眠带子并且在线
    {
        
        HETMattressDeviceViewController *vc=[[HETMattressDeviceViewController alloc]init];
        vc.currentBroadName=[NSString stringWithFormat:@"%@-%@-%@-%@",@"HET",[deviceModel.macAddress substringFromIndex:deviceModel.macAddress.length-6],deviceModel.deviceTypeId,deviceModel.deviceSubtypeId ];//@"HET-3ACDE6-6-1";
        vc.deviceId=deviceModel.deviceId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
        
    }
    
    //    NSString *url = @"/v1/user/uploadAvatar";
    //    //NSData转换为UIImage
    //    NSString *path=[[NSBundle mainBundle]pathForResource:@"refrigerator@2x" ofType:@"png"];
    //    NSData *imageData =[NSData dataWithContentsOfFile:path];
    // //UIImageJPEGRepresentation([UIImage imageNamed:@"refrigerator"], 0.75); //
    //
    //
    //     HETFileInfo *fileInfo=[[HETFileInfo alloc]initWithKey:@"avatar" filename:@"avatar1234.png" mimeType:@"image/png" data:imageData];
    //
    //     [HETDeviceRequestBusiness startMultipartFormDataRequestWithRequestUrl:url processParams:nil uploadFileInfo:[[NSArray alloc]initWithObjects:fileInfo, nil] BlockWithSuccess:^(id responseObject) {
    //     NSLog(@"%@", responseObject);
    //
    //
    //     } failure:^(NSError *error) {
    //     NSLog(@"%@", error);
    //     }];
    if(deviceBindType.integerValue==1)
    {
        TestH5DownloadViewController*h5vc = [[TestH5DownloadViewController alloc]init];
        h5vc.deviceModel=deviceModel;
        [[HETH5Manager shareInstance]getH5Path:^(NSString *h5Path, BOOL needRefresh, NSString *h5ConfigLibVersion, NSError *error) {
            NSLog(@"%@..%@",h5Path,@(needRefresh));
            NSLog(@"h5PagePath--->:%@",h5Path);
            NSString *desPath  = [NSString stringWithFormat:@"%@/index.html",h5Path];
            h5vc.h5Path = desPath;
            [h5vc.wkWebView reload];
            [self.navigationController pushViewController:h5vc animated:YES];
        } downloadProgressBlock:^(NSProgress *progress) {
            
        } productId:[NSString stringWithFormat:@"%@", deviceModel.productId]];
//        [[HETH5Manager shareInstance]getH5Path:^(NSString *h5Path, BOOL needRefresh,NSError *error) {
//            NSLog(@"%@..%@",h5Path,@(needRefresh));
//            NSLog(@"h5PagePath--->:%@",h5Path);
//            NSString *desPath  = [NSString stringWithFormat:@"%@/index.html",h5Path];
//            h5vc.h5Path = desPath;
//            [h5vc.wkWebView reload];
//            [self.navigationController pushViewController:h5vc animated:YES];
//
//        } productId:[NSString stringWithFormat:@"%@", deviceModel.productId]];
    }
    else if (deviceBindType.integerValue==2)
    {
        BLEDeviceViewController *vc=[[BLEDeviceViewController alloc]init];
        vc.macAddress=deviceModel.macAddress;
        vc.productId=deviceModel.productId.integerValue;
        vc.deviceType=deviceModel.deviceTypeId.integerValue;
        vc.deviceSubType=deviceModel.deviceSubtypeId.integerValue;
        vc.deviceId=deviceModel.deviceId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    return;
    if(deviceBindType.integerValue==1&&deviceTypeId.integerValue==11&&deviceOnOff.integerValue==1)//WIFI设备,香薰机设备并且在线
    {
        
        AromaDiffuserViewController *vc=[[AromaDiffuserViewController alloc]init];
        vc.hetDeviceModel=deviceModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



-(void)viewDidLayoutSubviews {
    
    if ([self.allBindDeviceTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.allBindDeviceTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.allBindDeviceTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.allBindDeviceTableView setLayoutMargins:UIEdgeInsetsZero];
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

#pragma mark 初始化UITableView
-(UITableView *)allBindDeviceTableView
{
    if(!_allBindDeviceTableView)
    {
        _allBindDeviceTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _allBindDeviceTableView.delegate = self;
        _allBindDeviceTableView.dataSource = self;
        _allBindDeviceTableView.backgroundColor = [UIColor clearColor];
        _allBindDeviceTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _allBindDeviceTableView.tableFooterView=[UIView new];
    }
    return _allBindDeviceTableView;
}

#pragma mark-----绑定设备按钮
-(UIButton *)addDeviceButton
{
    if(!_addDeviceButton)
    {
        _addDeviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addDeviceButton setTitle:@"绑定设备" forState:UIControlStateNormal];
        [_addDeviceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addDeviceButton addTarget:self action:@selector(addDeviceAction) forControlEvents:UIControlEventTouchUpInside];
        _addDeviceButton.backgroundColor=[self colorFromHexRGB:@"2E7BD3"];
        
    }
    return _addDeviceButton;
    
}

@end
