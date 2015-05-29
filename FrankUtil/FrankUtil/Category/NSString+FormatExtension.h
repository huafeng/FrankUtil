//
//  NSString+FormatExtension.h
//  LabaAssignment
//
//  Created by John on 4/29/14.
//  Copyright (c) 2014 com.yiyu.co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FormatExtension)

-(BOOL)isAllLetters;
- (BOOL)isChineseCharactStrings;
- (BOOL)hasChineseCharacter;
- (BOOL)isValidURL;
- (NSString *)stringByPaddingEachCharctorWithString:(NSString *)paddingChar;
- (BOOL)isNullOrEmpty;
+ (NSString *)formateDistance:(double)distance;
/**
 *  格式化字符串人民币值
 *
 *  @param yuan 字符串人民币值
 *
 *  @return eg.3.1 or 2 or 2.21
 */
- (NSString *)formateAsCNY;
+ (NSString *)formateTimeLeftAsHrAndSec:(NSString *)beginDate period:(NSInteger)period;
@end
