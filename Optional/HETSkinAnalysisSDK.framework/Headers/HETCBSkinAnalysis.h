//
//  HETCBSkinAnalysis.h
//  HETSkinAnalysisSDK
//
//  Created by 袁云龙 on 2019/2/13.
//  Copyright © 2019年 袁云龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompleteBlock)(NSDictionary *dict ,NSError *error)  ;
typedef void(^UploadProcessBlock)(int64_t bytesSent , int64_t totalBytesSent , int64_t totalBytesExpectedToSend);

@interface HETCBSkinAnalysis : NSObject

+ (instancetype)shareInstance;

/** 初始化拍照测肤SDK
 *  @param complete 初始化拍照测肤SDK回调，失败了则回传error,成功error为nil
 *
 */

- (void)initHETSkinAnalysisWithComplete:(CompleteBlock)complete;

// 上传照片到服务器并且分析
/**
 *  @param img      拍照测肤的人脸照片
 *  @param distance 拍照测肤的人脸照片面部占屏幕的比例
 *  @param light    拍照测肤的人脸照片亮度
 *  @param sex      拍照测肤照片人的性别      1-男，2-女
 *  @param birthStr 拍照测肤照片人的生日字符串 yyyy-MM-dd
 *  @param takeType 拍照测肤测试类型 （1-测自己,2-测ta人）
 *  @param uploadProgressCB  拍照测肤照片上传进度
 *  @param completeBlock     拍照测肤分析结果回调，成功则返回字典，error为nil；失败则返回error.
 */
- (void)uploadImageToServer:(UIImage *)img distance:(CGFloat)distance light:(CGFloat)light sex:(NSInteger)sex birthStr:(NSString *)birthStr takeType:(NSInteger)takeType setSendProcessBlock:(UploadProcessBlock)uploadProgressCB analysisCompleteBlock:(CompleteBlock)completeBlock;

@end

NS_ASSUME_NONNULL_END
