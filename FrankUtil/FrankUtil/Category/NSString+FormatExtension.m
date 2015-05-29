//
//  NSString+FormatExtension.m
//  LabaAssignment
//
//  Created by John on 4/29/14.
//  Copyright (c) 2014 com.yiyu.co.Ltd. All rights reserved.
//

#import "NSString+FormatExtension.h"

@implementation NSString (FormatExtension)

-(BOOL)isAllLetters{
    if ([self length]==0) {
        return NO;
    }
    NSString *regex = @"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[C] %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isChineseCharactStrings {
    BOOL allZH = YES;
    for (int i = 0, len = (int)self.length; i < len; i++) {
        unichar ch = [self characterAtIndex:i];
        if ((0x4e00 < ch  && ch < 0x9fff)||((int)ch>127)){
        } else {
            allZH = NO;
            break;
        }
    }
    return allZH;
}

- (BOOL)hasChineseCharacter {
    if ([self isNullOrEmpty]) {
        return NO;
    }
    BOOL hasZH = NO;
    for (int i = 0, len = (int)self.length; i < len; i++) {
        unichar ch = [self characterAtIndex:i];
        if ((0x4e00 < ch  && ch < 0x9fff)||((int)ch>127)){
            hasZH = YES;
            break;
        }
    }
    return hasZH;
}

- (BOOL)isValidURL {
    if ([self length] == 0) {
        return NO;
    }
//    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
//    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
//    return [urlTest evaluateWithObject:self];
    NSURL *url = [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *scheme = [url scheme];
    if ([scheme length] > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)stringByPaddingEachCharctorWithString:(NSString *)paddingChar {
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    NSInteger total = [self length];
    for (int i = 0; i < total; i++) {
        NSRange ran;
        ran.length = 1;
        ran.location = i;
        if (i < total - 1) {
            NSString *ch = [NSString stringWithFormat:@"%@%@",[self substringWithRange:ran],paddingChar];
            [str appendString:ch];
        } else {
            NSString *ch = [NSString stringWithFormat:@"%@",[self substringWithRange:ran]];
            [str appendString:ch];
        }
    }
    return str;
}

- (BOOL)isNullOrEmpty {
    BOOL retVal = YES;
    
    if( self != nil )
    {
        if( [self isKindOfClass:[NSString class]] )
        {
            retVal = self.length == 0;
        }
        //else ... isNullOrEmpty, value not a string
    }
    return retVal;
}


+ (NSString *)formateDistance:(double)distance {
    if (distance<0) {
        return @"";
    }
    if (distance<20) {
        return NSLocalizedString(@"附近", @"");
    }
    if (distance<100) {
        return [NSString stringWithFormat:@"%.0f%@",[[NSString stringWithFormat:@"%.1f",distance/100.0] floatValue]*100,NSLocalizedString(@"m", @"")];
    }
    if (distance<1000) {
        return [NSString stringWithFormat:@"%.0f%@",[[NSString stringWithFormat:@"%.1f",distance/1000.0] floatValue]*1000,NSLocalizedString(@"m", @"")];
    }
    if (distance<10000) {
        return [NSString stringWithFormat:@"%.1f%@",distance/1000.0,NSLocalizedString(@"km", @"")];
    }
    return [NSString stringWithFormat:@"%.0f%@",distance/1000.0,NSLocalizedString(@"km", @"")];
}

- (NSString *)formateAsCNY {
    float f_yuan = [self floatValue];
    NSInteger i_yuan = [self integerValue];
    if (f_yuan == i_yuan) {
        return [NSString stringWithFormat:@"%ld",i_yuan];
    }
    float decile_yuan = [[NSString stringWithFormat:@"%.1f",f_yuan] floatValue];
    float percentile_yuan = [[NSString stringWithFormat:@"%.2f",f_yuan] floatValue];
    if (decile_yuan == f_yuan) {
        return [NSString stringWithFormat:@"%f",decile_yuan];
    }
    return [NSString stringWithFormat:@"%f",percentile_yuan];
}

+ (NSString *)formateTimeLeftAsHrAndSec:(NSString *)beginDate period:(NSInteger)period {
    if ([beginDate isNullOrEmpty]) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *beginDate_ = [formatter dateFromString:beginDate];
#if !__has_feature(objc_arc)
    [formatter release];
#endif
    NSDate *endDate = [NSDate dateWithTimeInterval:period * 3600 sinceDate:beginDate_];
    NSTimeInterval interal = [endDate timeIntervalSinceNow];
    if (interal > 0) {
        NSInteger hr = fabs(interal) / 3600;
        NSInteger sec = (fabs(interal) - hr * 3600) / 60;
        if (hr > 0 && sec > 0) {
            return [NSString stringWithFormat:@"%ld%@%ld%@",hr,NSLocalizedString(@"小时", @""),sec,NSLocalizedString(@"分钟", @"")];
        } else if (hr > 0 && sec == 0) {
            return [NSString stringWithFormat:@"%ld%@",hr,NSLocalizedString(@"小时", @"")];
        } else if (hr == 0 && sec > 0) {
            return [NSString stringWithFormat:@"%ld%@",sec,NSLocalizedString(@"分钟", @"")];
        } else {
            return @"";
        }
    } else {//已结束
        return @"";
    }
}

@end
