//
//  NSData+SecurityUtil.h
//  LabaAssignment
//
//  Created by John on 13-11-4.
//  Copyright (c) 2013年 com.yiyu.co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SecurityUtil)

+(NSData *)AES128EncryptWithKey:(NSData *)key data:(NSData*)data;

+ (NSData *)dataWithBase64String:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *) md5_base64;

@end


@interface NSString (Base64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;
-(NSData*)MD5Data;

@end