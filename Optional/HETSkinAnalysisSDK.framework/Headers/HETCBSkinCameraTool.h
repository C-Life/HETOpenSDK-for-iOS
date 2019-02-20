//
//  HETCBSkinCameraTool.h
//  HETSkinAnalysisSDK
//
//  Created by 袁云龙 on 2019/2/13.
//  Copyright © 2019年 袁云龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,CameraStatus) {
    CAMERASTATUS_NORMAL = 1,  //正常，可以拍照
    CAMERASTATUS_FAR,         //太远
    CAMERASTATUS_NEAR,        //太近
    CAMERASTATUS_DARK,        //太暗
    CAMERASTATUS_BRIGHT,      //太亮
    CAMERASTATUS_NOPERSON,    //没有检测到人脸
    CAMERASTATUS_MULPERSON,    //检测到多个人脸
    CAMERASTATUS_OUTBOUNDS,    //超过边界
    CAMERASTATUS_PHONESUCCESS,  //拍照成功
    CAMERASTATUS_NOAUTHORITY    //没有权限
};
typedef void (^cameraRunningBlock) (CameraStatus cameraStatus,CGFloat distance,CGFloat light);

@interface HETCBSkinCameraTool : NSObject


// 压缩图片小于1.5M
+ (NSData *)judgeImageSizeWithImageData:(NSData *)data fixedImage:(UIImage *)fixedImage compressionQuality:(double)compressionQuality;


// - (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
// 在该代理方法中处理图片数据流，获取照片中人脸比例和图片亮度
+ (void )cameraRunning:(CMSampleBufferRef)sampleBuffer result:(cameraRunningBlock)resultBlock ;


// 判断相机像素是否满足条件
+ (BOOL) isPixelCondition;

@end

NS_ASSUME_NONNULL_END
