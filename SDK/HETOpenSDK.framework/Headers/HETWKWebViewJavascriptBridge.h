//
//  HETWKWebViewJavascriptBridge.h
//  HETOpenSDK
//
//  Created by mr.cao on 2017/10/19.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@protocol HETWKWebViewJavascriptBridgeDelegate<NSObject>

@optional
/**
 *  js调用的配置接口
 *
 *  @param data
 */
-(void)config:(id)data;


/**
 *  js调用的发送数据接口
 *
 *  @param data 将发送给app的数据，一般是完整的控制数据(json字符串)
 *  @param successCallback  app方数据处理成功时将调用该方法
 *  @param errorCallback    app方数据处理失败时将调用该方法
 */
-(void)send:(id)data successCallback:(id)successCallback errorCallback:(id)errorCallback;


/**
 *  js调用的设置页面标题接口(该方法用于将标题发送给app，以供app进行标题更新。)
 *
 *  @param data  将设置的标题
 */
-(void)title:(id)data;



/**
 *  js调用的系统toast接口(方法用于调用系统toast，以便app方统一toast风格)
 *
 *  @param data 将要弹出的提示信息
 */
-(void)toast:(id)data;

/**
 *  相对网络请求
 *
 *  @param url    请求地址。如用相对地址，必须“/” 开头（如：/v1/app/get）
 *  @param data   发送数据。形式为：{"name": "张三", "age": 21, ...}
 *  @param type   HTTP请求类型，如Get,Post请求
 *  @param sucCallbackId   接口调用成功的回调函数
 *  @param errCallbackId    接口调用失败的回调函数
 *  @param needSign        接口是否需要签名（相对地址时有效),1代表需要签名，0代表不需要签名|
 */
-(void)relProxyHttp:(id)url data:(id)data httpType:(id) type sucCallbackId:(id) sucCallbackId errCallbackId:(id) errCallbackId needSign:(id) needSign;

/**
 *  绝对网络请求
 *
 *  @param url    请求地址。如用绝对地址（如：https://baidu.com/v1/app/get）
 *  @param data   发送数据。形式为：{"name": "张三", "age": 21, ...}
 *  @param type   HTTP请求类型，如Get,Post请求
 *  @param sucCallbackId   接口调用成功的回调函数
 *  @param errCallbackId    接口调用失败的回调函数
 */
-(void)absProxyHttp:(id)url data:(id)data httpType:(id) type sucCallbackId:(id) sucCallbackId errCallbackId:(id) errCallbackId;

/**
 *  加载H5页面失败
 *
 *  @param errCode  错误码
 *  @param errMsg   错误信息
 */
-(void)onLoadH5Failed:(id)errCode errMsg:(id)errMsg;

/**
 *  h5传数据给native指h5传递相关数据给native端，比如设置页面标题，当前版本信息等
 *
 *  @param routeUrl   路由方法名
 *  @param data   数据内容
 *  @param successCallbackId   接口调用成功的回调函数
 *  @param failCallbackId    接口调用失败的回调函数

 */
-(void)h5SendDataToNative:(id) routeUrl data:(id) data successCallbackId:(id)successCallbackId failedCallbackId:(id) failedCallbackId;

/**
 *  h5从native端获取数据，比如定位信息，蓝牙是否开启等
 *
 *  @param routeUrl   路由方法名
 *  @param successCallbackId   接口调用成功的回调函数
 *  @param failCallbackId    接口调用失败的回调函数
 
 */
-(void)h5GetDataFromNative:(id)routeUrl successCallbackId:(id)successCallbackId failedCallbackId:(id)failedCallbackId;

@end


@interface HETWKWebViewJavascriptBridge : NSObject

@property (nonatomic,weak) id<HETWKWebViewJavascriptBridgeDelegate>delegate;

+ (instancetype)bridgeForWebView:(WKWebView*)webView;

- (void)setNavigationDelegate:(id<WKNavigationDelegate>)navigationDelegate;


/**
 *  H5调用config接口后需要APP调用此方法，告知js准备好了(注意此方法调用之后，一般需要紧接着调用webViewConfigDataRepaint传配置数据给H5初始化界面)
 *
 *  @param dic
 */
-(void)webViewReady:(NSDictionary *)dic;


/**
 *  传配置数据给js
 *
 *  @param dic
 */
-(void)webViewConfigDataRepaint:(NSDictionary *)dic;

/**
 *  传运行数据给js
 *
 *  @param dic
 */
-(void)webViewRunDataRepaint:(NSDictionary *)dic;

/**
 *  设备控制的时候下发成功，将事件告知js
 *
 *  @param data             需要传递的参数，可填nil
 *  @param successCallBlock 成功的回调，这个回调是从webview那边获取的
 */
- (void)updateDataSuccess:(NSDictionary *)dic successCallBlock:(id)successCallBlock;


/**
 *  设备控制的时候下发失败，将事件告知js
 *
 *  @param data            需要传递的参数，可填nil
 *  @param errorCallBlock  失败的回调，这个回调是从webview那边获取的
 */
- (void)updateDataError:(NSDictionary *)dic errorCallBlock:(id)errorCallBlock;



/**
 *  APP将网络请求的成功结果回传给js
 *
 *  @param dic              请求的结果
 *  @param successCallBlock
 */

-(void)webViewHttpResponseSuccessResponse:(NSDictionary *)dic  successCallBlock:(id)successCallBlock;

/**
 *  APP将网络请求的失败结果回传给js
 *
 *  @param dic              请求的结果
 *  @param errorCallBlock
 */

-(void)webViewHttpResponseErrorResponse:(NSDictionary *)dic  errorCallBlock:(id)errorCallBlock;




/**
 *  APP将通用接口请求的结果回传给js
 *
 *  @param dic              请求的结果
 *  @param callBackId  需与h5SendDataToNative接口返回的callBackId保持一致
 */

-(void)webViewNativeResponse:(NSDictionary *)dic  callBackId:(id)callBackId;
@end
