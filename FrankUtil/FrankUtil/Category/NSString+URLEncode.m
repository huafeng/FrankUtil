//
//  NSString+URLEncode.m
//  YouJia
//
//  Created by aa on 14-3-5.
//
//

#import "NSString+URLEncode.h"
#import <Foundation/Foundation.h>

@implementation NSString (URLEncodeString)

+ (NSString *)encodeString:(NSString*)unescapedString
{
    NSString* escapedUrlString= (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)unescapedString, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return escapedUrlString;
}

@end
