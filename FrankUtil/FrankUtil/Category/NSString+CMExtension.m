//
//  NSString+CMExtension.m
//  LabaAssignment
//
//  Created by John on 12-12-13.
//  Copyright (c) 2012年 John. All rights reserved.
//

#import "NSString+CMExtension.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (CMExtension)


-(NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}





+(NSString*)formateDistance:(float)distance{
    
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

-(BOOL)isValidPhoneNumber{//@"^((13[0-9])|(15[0-9])|(18[0-9]))\\d{8}$"

    NSError *error = NULL;
    NSRegularExpression *phoneRegex = [NSRegularExpression regularExpressionWithPattern:@"^1\\d{10}$"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:&error];

    if (self.length != 11) {
        
        return NO;
        
    }else {
        
        NSRange rangeOfFirstMatch = [phoneRegex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
        if (NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
            return NO;
        }
    }
    
    return YES;
}


-(BOOL)isValidEmailAddress{

    NSError *error = NULL;
    NSRegularExpression *emailRegex = [NSRegularExpression regularExpressionWithPattern:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:&error];
    
    if ([self length]==0) {
        
        return NO;
        
    }
    
    NSRange rangeOfFirstMatch = [emailRegex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if (NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        
        return NO;
    }
    
    return YES;
}


+(NSString*)formateDateStringWithYearAndMonth:(NSString*)year month:(NSString*)month{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    NSArray *monthSymbols=[formatter standaloneMonthSymbols];
    int i=0;
    BOOL found=NO;
    for (; i<[monthSymbols count]; i++) {
        
        if ([month isEqualToString:[monthSymbols objectAtIndex:i]]) {
            found=YES;
            break;
        }
    }
    
    if (!found) {
        
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@-%@",year,[NSString stringWithFormat:@"0%d",i+1]];
    
}


-(BOOL)isAllNumbers{
    
    if ([self length]==0) {
        
        return NO;
        
    }
    
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return  [predicate evaluateWithObject:self];

}

-(BOOL)isAllLetters{

    if ([self length]==0) {
        
        return NO;
        
    }

    NSString *regex = @"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[C] %@", regex];
    return [predicate evaluateWithObject:self];
}




@end
