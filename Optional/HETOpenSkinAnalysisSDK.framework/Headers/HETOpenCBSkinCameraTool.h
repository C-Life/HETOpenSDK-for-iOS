//
//  HETOpenCBSkinCameraTool.h
//  HETOpenSkinAnalysisSDK
//
//  Created by 袁云龙 on 2019/3/4.
//  Copyright © 2019 袁云龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,HETCBCameraStatus) {
    CBCAMERASTATUS_NORMAL = 1,  //正常，可以拍照
    CBCAMERASTATUS_FAR,         //太远
    CBCAMERASTATUS_NEAR,        //太近
    CBCAMERASTATUS_DARK,        //太暗
    CBCAMERASTATUS_BRIGHT,      //太亮
    CBCAMERASTATUS_NOPERSON,    //没有检测到人脸
    CBCAMERASTATUS_MULPERSON,    //检测到多个人脸
    CBCAMERASTATUS_OUTBOUNDS,    //超过边界
    CBCAMERASTATUS_PHONESUCCESS,  //拍照成功
    CBCAMERASTATUS_NOAUTHORITY    //没有权限
};
typedef void (^cameraRunningBlock) (HETCBCameraStatus cameraStatus,CGFloat distance,CGFloat light);

@interface HETOpenCBSkinCameraTool : NSObject

/**
 * 修改图片大小(等比例缩)
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;

// 通过抽样缓存数据创建一个UIImage对象
+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;

/**
 *  用来处理图片翻转90度
 *  @param aImage
 *
 *  @return
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;


+(void)fixImageWithOrientation:(UIImage *)aImage :(void(^)(UIImage *))test;

// 前置摄像头拍照做镜像处理
+(UIImage *)fixImage:(UIImage *)aImage;//

/**识别脸部*/
+ (NSArray *)detectFaceWithImage:(UIImage *)faceImag;

// 压缩图片小于1M
+ (NSData *)judgeImageSizeWithImageData:(NSData *)data fixedImage:(UIImage *)fixedImage compressionQuality:(CGFloat)compressionQuality;
// yuv转RGB格式
+ (UIImage *)RGBImageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;
/*!
 @method getYUVLight
 
 @param data
 照片数据字节流
 @param rect
 人脸框
 @param width
 图片宽度
 */
+ (NSInteger )getYUVLight:(Byte *)bytes rect:(CGRect )rect witdh:(NSInteger )width;
//获取设备方向的方法，配置图片输出的时候使用
+ (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation;
/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
+(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position;
// 判断相机像素是否满足条件
+ (BOOL) isPixelCondition;
// 判断是否是模拟器
+ (BOOL)isSimulator;
// videooutput代理方法
+ (void )cameraRunning:(CMSampleBufferRef)sampleBuffer result:(cameraRunningBlock)resultBlock;
@end

NS_ASSUME_NONNULL_END
