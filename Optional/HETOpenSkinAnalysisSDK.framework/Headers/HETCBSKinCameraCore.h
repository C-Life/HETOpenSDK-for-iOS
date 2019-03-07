//
//  HETCBSKinCameraCore.h
//  DemoSkinAnalysis
//
//  Created by 袁云龙 on 2019/3/1.
//  Copyright © 2019 袁云龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HETOpenCBSkinCameraTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface HETCBSKinAnalysisResultModule : NSObject

@property (nonatomic, strong) NSData *imageData; //照片数据

@property (nonatomic, strong) UIImage *image; //修正后的照片数据

@property (nonatomic, assign) CGFloat light;  //亮度

@property (nonatomic, assign) CGFloat distance; //距离

@end


@protocol HETCBSKinCameraCoreDelegate <NSObject>

// 开始拍照
@optional
- (void)startTakePhoto;

// 拍照成功
@required
- (void)takePhotoSuccess:(NSData * __nullable)imageData
                   error:(NSError * __nullable)error;
// 分析照片
- (void)analysisPhotoSuccess:(HETCBSKinAnalysisResultModule * __nullable)module
                       error:(NSError * __nullable)error;

@end

@interface HETCBSKinCameraCore : NSObject

@property (nonatomic, assign) HETCBCameraStatus cameraStatus;// 拍照状态

@property (nonatomic, readonly) BOOL          isTakingPictures;    //是否正在拍照
@property (nonatomic, readonly) NSInteger     currentCamera;      // 当前是前置1还是后置2

@property (nonatomic, assign) BOOL          enableVoice;        // 是否开启语言提示

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层

@property (nonatomic, weak) id<HETCBSKinCameraCoreDelegate> delegate;  // 拍照代理

// 初始化拍照对象，获取单例数据
+ (instancetype)shareInstance;

// 初始化相机
- (void)initCameraSession;

// 修改摄像头
- (void)changeCameraWithComplete:(void(^)(BOOL success, NSError *error))completed;

// 释放 视频 音频session
- (void)releaseSession;

// 视频 音频 session stop
- (void)stopSession;

// 视频 音频 session start
- (void)startSession;
@end



NS_ASSUME_NONNULL_END
