//
//  UIDevice+Extension.h
//  LabaAssignment
//
//  Created by John on 3/20/14.
//  Copyright (c) 2014 com.yiyu.co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Extension)
/**
 *  设备是否越狱
 *
 *  @return YES 越狱; NO 未越狱
 */
+ (BOOL)isJailbroken;
/**
 *  设备是否破解
 *
 *  @return YES 破解; NO 未破解
 */
+ (BOOL)isPirated;
/**
 *  获取运营商名称
 *
 *  @return eg:中国联通 ...
 */
+ (NSString *)carrierName;
/**
 *  获取设备MacAddress
 *
 *  @return Ios 7.0之前版本成功获取,Ios 7.0之后的版本获取到无效的MacAddress
 */
+(NSString *)macAddress;

+ (NSString*)devicePlatform;
@end
