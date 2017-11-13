//
//  HETThirdCloudAuthorize.h
//  HETOpenSDK
//
//  Created by yuan yunlong on 2017/10/16.
//  Copyright © 2017年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface HETThirdCloudAuthorize : NSObject

+ (instancetype)shareInstance;
/**
 *  是否授权认证
 *
 *  @return   YES为已经授权登录
 */
- (BOOL)isAuthenticated;


/**
 *  获取授权码
 *
 *  @param completedBlock 获取授权码回调
 */
- (void)getAuthorizationCodeWithCompleted:(void(^)(NSDictionary *responseDic, NSError *error))completedBlock;


/**
 *  云授权
 *
 *  @param randomCode        随机码
 *  @param verificationCode  验证码,不提交则默认为二次授权
 *  @param completedBlock    授权成功返回
 */
- (void)autoAuthorizeWithRandomCode:(NSString *)randomCode verificationCode:(NSString *)verificationCode withCompleted:(void(^)(NSString *openId, NSError *error))completedBlock;

@end
