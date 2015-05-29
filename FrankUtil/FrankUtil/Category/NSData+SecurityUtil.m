//
//  NSData+SecurityUtil.m
//  LabaAssignment
//
//  Created by John on 13-11-4.
//  Copyright (c) 2013年 com.yiyu.co.Ltd. All rights reserved.
//

#import "NSData+SecurityUtil.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (SecurityUtil)

- (NSString *) md5_base64
{
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], [self length], digest);
    NSData *data = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    return [data base64EncodedString];
}

+(NSData *)AES128EncryptWithKey:(NSData *)key data:(NSData*)data
{
    //    NSString *iv = @"1a2b3c4d5e6f7890";
    //    char ivPtr[kCCKeySizeAES128 + 1];
    //    bzero(ivPtr, sizeof(ivPtr));
    //
    //    // fetch iv data
    //    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    
    //    char keyPtr[kCCKeySizeAES128 + 1]; // room for terminator (unused)
    //    bzero( keyPtr, sizeof( keyPtr ) ); // fill with zeroes (for padding)
    //    [key getCString:keyPtr maxLength:sizeof( keyPtr ) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCEncrypt,         kCCAlgorithmAES128,kCCOptionPKCS7Padding,
                                          [key bytes], kCCKeySizeAES128,
                                          NULL ,[data bytes], dataLength, buffer,   bufferSize, &numBytesEncrypted );
    if( cryptStatus == kCCSuccess )
    {
        
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free( buffer );
    return nil;
    
}



+ (NSData *)dataWithBase64String:(NSString *)string
{
    const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSUInteger inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    NSUInteger maxOutputLength = (inputLength / 4 + 1) * 3;
    NSMutableData *outputData = [NSMutableData dataWithLength:maxOutputLength];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    NSUInteger accumulator = 0;
    NSUInteger outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (NSUInteger i = 0; i < inputLength; i++)
    {
        unsigned char decoded = lookup[inputBytes[i] & 0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength? outputData: nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    NSUInteger inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];
    
    NSUInteger maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) * 2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
    
    NSUInteger i;
    NSUInteger outputLength = 0;
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] =   '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    if (outputLength >= 4)
    {
        //truncate data to match actual output length
        outputBytes = realloc(outputBytes, outputLength);
        return [[NSString alloc] initWithBytesNoCopy:outputBytes
                                              length:outputLength
                                            encoding:NSASCIIStringEncoding
                                        freeWhenDone:YES];
    }
    else if (outputBytes)
    {
        free(outputBytes);
    }
    return nil;
}

- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithWrapWidth:0];
}



@end



@implementation NSString (Base64)

-(NSData*)MD5Data{
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([[self dataUsingEncoding:NSUTF8StringEncoding] bytes], [self length], result);
    
    NSData *data = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    
    return data;
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData dataWithBase64String:string];
    if (data)
    {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedString];
}

- (NSString *)base64DecodedString
{
    return [NSString stringWithBase64EncodedString:self];
}

- (NSData *)base64DecodedData
{
    return [NSData dataWithBase64String:self];
}

@end
