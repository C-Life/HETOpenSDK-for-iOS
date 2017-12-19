//
//  TestH5ViewController.m
//  HETOpenSDKDemo
//
//  Created by mr.cao on 2017/10/24.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import "TestH5DownloadViewController.h"

#import <WebKit/WebKit.h>
@interface TestH5DownloadViewController ()<WKNavigationDelegate,HETWKWebViewJavascriptBridgeDelegate>
@property(nonatomic, strong) HETWKWebViewJavascriptBridge* bridge;
@property(nonatomic, strong) NSURL *requestURL;
@property(nonatomic, strong) NSURLCredential *credential;
@property(nonatomic,strong)HETDeviceControlBusiness *communicationManager;
@end

@implementation TestH5DownloadViewController
-(void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    _wkWebView=webView;
    _bridge = [HETWKWebViewJavascriptBridge bridgeForWebView:webView];
    _bridge.delegate=self;
    [_bridge setNavigationDelegate:self];
    [self loadRequest];
    _communicationManager=[[HETDeviceControlBusiness alloc]initWithHetDeviceModel:self.deviceModel deviceRunData:^(id responseObject) {
        [_bridge webViewRunDataRepaint:responseObject];
    } deviceCfgData:^(id responseObject) {
         [_bridge webViewConfigDataRepaint:responseObject];
    } deviceErrorData:^(id responseObject) {
         [_bridge webViewRunDataRepaint:responseObject];
    } deviceState:^(HETWiFiDeviceState state) {
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        [infoDic setObject:@(state) forKey:@"onlineStatus"];
        [_bridge webViewRunDataRepaint:infoDic];
       
    } failBlock:^(NSError *error) {
        NSLog(@"失败了:%@",error);
    }];

     //[_communicationManager start];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [_communicationManager start];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.communicationManager)
    {
        [self.communicationManager stop];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  js调用的配置接口
 *
 *  @param data
 */
-(void)config:(id)data
{
    [_bridge webViewReady:nil];
    if(self.communicationManager.deviceCfgData)
    {
     [_bridge webViewConfigDataRepaint:self.communicationManager.deviceCfgData];
    }
}


/**
 *  js调用的发送数据接口
 *
 *  @param data 将发送给app的数据，一般是完整的控制数据(json字符串)
 *  @param successCallback  app方数据处理成功时将调用该方法
 *  @param errorCallback    app方数据处理失败时将调用该方法
 */
-(void)send:(id)data successCallback:(id)successCallback errorCallback:(id)errorCallback
{
    //[_bridge updateDataSuccess:nil successCallBlock:successCallback];
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *olddic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSMutableDictionary *responseObject=[[NSMutableDictionary alloc]initWithDictionary:olddic];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic=responseObject;
    NSError * err;
    NSData * tempjsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    NSString * json = [[NSString alloc] initWithData:tempjsonData encoding:NSUTF8StringEncoding];
    [self.communicationManager deviceControlRequestWithJson:json withSuccessBlock:^(id responseObject) {
        [_bridge updateDataSuccess:responseObject successCallBlock:successCallback];
    } withFailBlock:^(NSError *error) {
        [_bridge updateDataError:responseObject errorCallBlock:errorCallback];
    }];

    
}


/**
 *  js调用的设置页面标题接口(该方法用于将标题发送给app，以供app进行标题更新。)
 *
 *  @param data  将设置的标题
 */
-(void)title:(id)data
{
    self.title=data;
}



/**
 *  js调用的系统toast接口(方法用于调用系统toast，以便app方统一toast风格)
 *
 *  @param data 将要弹出的提示信息
 */
-(void)toast:(id)data
{
    
}

/**
 *  H5调用config接口后需要APP调用此方法，告知js准备好了(注意此方法调用之后，一般需要紧接着调用webViewConfigDataRepaint传配置数据给H5初始化界面)
 *
 *  @param dic
 */
-(void)relProxyHttp:(id)url data:(id)data httpType:(id) type sucCallbackId:(id) sucCallbackId errCallbackId:(id) errCallbackId needSign:(id) needSign
{
    
}

/**
 *  H5调用config接口后需要APP调用此方法，告知js准备好了(注意此方法调用之后，一般需要紧接着调用webViewConfigDataRepaint传配置数据给H5初始化界面)
 *
 *  @param dic
 */
-(void)absProxyHttp:(id)url data:(id)data httpType:(id) type sucCallbackId:(id) sucCallbackId errCallbackId:(id) errCallbackId
{
    
}

/**
 *  加载H5页面失败
 *
 *  @param errCode  错误码
 *  @param errMsg   错误信息
 */
-(void)onLoadH5Failed:(id)errCode errMsg:(id)errMsg
{
    
}

/**
 *  H5调用config接口后需要APP调用此方法，告知js准备好了(注意此方法调用之后，一般需要紧接着调用webViewConfigDataRepaint传配置数据给H5初始化界面)
 *
 *  @param dic
 */
-(void)h5SendDataToNative:(id) routeUrl data:(id) data successCallbackId:(id)successCallbackId failedCallbackId:(id) failedCallbackId
{
     [_bridge webViewNativeResponse:@{@"h5SendDataToNative":routeUrl} callBackId:successCallbackId];
}

/**
 *  H5调用config接口后需要APP调用此方法，告知js准备好了(注意此方法调用之后，一般需要紧接着调用webViewConfigDataRepaint传配置数据给H5初始化界面)
 *
 *  @param dic
 */
-(void)h5GetDataFromNative:(id)routeUrl successCallbackId:(id)successCallbackId failedCallbackId:(id)failedCallbackId
{
    [_bridge webViewNativeResponse:@{@"h5GetDataFromNative":routeUrl} callBackId:successCallbackId];
}

- (void)loadRequest
{
     if (self.h5Path&&self.h5Path.length>0) {
 
    if ([self.h5Path hasPrefix:@"http"]) {
        
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.h5Path]]];
    }else{
        NSRange webRange = [_h5Path rangeOfString:@"web"];
        NSRange locationRange = [_h5Path rangeOfString:@"household"];
        NSString *directory;
        if (webRange.length>0) {
            directory = [_h5Path substringWithRange:NSMakeRange(0, webRange.length+webRange.location+1)];
        }
        if (locationRange.length>0) {
            directory = [_h5Path substringWithRange:NSMakeRange(0, locationRange.length+locationRange.location+1)];
        }
        
        if (NSFoundationVersionNumber>NSFoundationVersionNumber_iOS_8_x_Max) {
            @try {
                [_wkWebView loadFileURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",[self.h5Path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] allowingReadAccessToURL:[NSURL fileURLWithPath:directory]];
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            } @finally {
                
            }
            
            
        }else{
            
            [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",[self.h5Path  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]]];
        }
    }
     }

}





        
   

- (void)updateWebOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        //[_webView stringByEvaluatingJavaScriptFromString:
        // @"document.body.setAttribute('orientation', 90);"];
        [_wkWebView evaluateJavaScript:@"document.body.setAttribute('orientation', 90);" completionHandler:nil];
    } else {
        //[_webView stringByEvaluatingJavaScriptFromString:
        // @"document.body.removeAttribute('orientation');"];
        [_wkWebView evaluateJavaScript:@"document.body.removeAttribute('orientation');" completionHandler:nil];
    }
}

// param data参数 NSDictionary、NSString
-(void)updateDataSuccess:(id)data :(id)successCallBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *messageJSON = @"";
        if ([data isKindOfClass:[NSDictionary class]]) {
            messageJSON=[self DataTOjsonString:data];
            
        } else if ([data isKindOfClass:[NSString class]]){
            messageJSON = data;
        }
        // [_webView stringByEvaluatingJavaScriptFromString:[NSString  stringWithFormat:@"webInterface.nativeResponse('%@','%@')",messageJSON,successCallBlock]];
        [_wkWebView evaluateJavaScript:[NSString  stringWithFormat:@"webInterface.nativeResponse('%@','%@')",messageJSON,successCallBlock] completionHandler:nil];
    });
}

-(NSString*)DataTOjsonString:(id)object
{
    if([object isKindOfClass:[NSNull class]]||!object)
    {
        return @"";
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    return jsonString;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge.protectionSpace.host isEqualToString:self.requestURL.host]) {
            //NSLog(@"trusting connection to host %@", challenge.protectionSpace.host);
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } else
        {
            //NSLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
        }
    }
    else {
        if ([challenge previousFailureCount] == 0) {
            if (self.credential) {
                [[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
            } else {
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        } else {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }
    
    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}
#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //    self.authed = YES;
    //webview 重新加载请求。
    //    [_webView loadRequest:originRequest];
    [connection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

#pragma mark -----WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // 类似 UIWebView 的- webView:didFailLoadWithError:
    // 102 == WebKitErrorFrameLoadInterruptedByPolicyChange
    // -999 == "Operation could not be completed", note -999 occurs when the user clicks away before
    // the page has completely loaded, if we find cases where we want this to result in dialog failure
    // (usually this just means quick-user), then we should add something more robust here to account
    // for differences in application needs
    if (!(([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
          ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102))) {
      
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { // 类似 UIWebView 的 －webViewDidFinishLoad:
    if(self.communicationManager.deviceCfgData)
    {
        [_bridge webViewConfigDataRepaint:self.communicationManager.deviceCfgData];
    }
  
    //[self updateWebOrientation];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
    
    NSString *requestString =[[navigationAction.request URL]absoluteString];
    
    NSLog(@"requestString:%@",requestString);
    if([requestString hasPrefix:@"http"]||[requestString hasPrefix:@"file://"])
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation { // 类似UIWebView的 -webViewDidStartLoad:
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    completionHandler();
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
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
