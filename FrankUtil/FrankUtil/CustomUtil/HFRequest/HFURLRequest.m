//
//  HFURLRequest.m
//  LaBaForB
//
//  Created by Admin on 15/2/2.
//  Copyright (c) 2015年 softlit. All rights reserved.
//

#import "HFURLRequest.h"

@implementation HFURLRequest

- (void)acceptGZip
{
    [self setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
}

- (void)notAcceptGZip
{
    [self setValue:nil forHTTPHeaderField:@"Accept-Encoding"];
}

- (BOOL)isAcceptGZip
{
    NSString *encoding = [[self allHTTPHeaderFields] objectForKey:@"Accept-Encoding"];
    return encoding && [encoding rangeOfString:@"gzip"].location != NSNotFound;
}

- (void)sendGZip
{
    [self setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
}

- (BOOL)isSendGZip
{
    NSString *encoding = [[self allHTTPHeaderFields] objectForKey:@"Content-Encoding"];
    return encoding && [encoding rangeOfString:@"gzip"].location != NSNotFound;
}

#pragma mark-
#pragma mark-----------------request method(对外开放）-----------------------
#pragma mark-

/*
 *@param    dict      参数词典
 *@param    urlStr    网址
 *@param    method    请求方法
 *@param    headerDict      http请求头
 *@param    format  http请求数据格式，josn或者nil
 *@param    urlParams    拼接在url的参数
 *@return
 */
- (id)initRequestWithUrl:(NSString *)urlStr
               urlParams:(NSMutableDictionary *)urlParams
                  method:(NSString *)method
            headerParams:(NSDictionary *)headerParams
              bodyParams:(NSDictionary *)bodyParams
                  format:(NSString *)format
{
    self=[super init];
    if (self) {
        NSMutableDictionary *header=[[NSMutableDictionary alloc] initWithDictionary:headerParams];  //请求的header
        NSURL *reqUrl=nil;  //请求的url
        NSData *bodyData=nil; //请求的body
        //拼接url
        if ([urlParams count]>0) {
            NSMutableString *urlParamString=[[NSMutableString alloc] init];
            NSArray *formKeys = [urlParams allKeys];
            for (int i=0; i < [formKeys count]; i++) {
                if (i==0) {
                    [urlParamString appendFormat:@"%@=%@",[formKeys objectAtIndex:i],[urlParams valueForKey:[formKeys objectAtIndex:i]]];
                }
                else {
                    [urlParamString appendFormat:@"&%@=%@",[formKeys objectAtIndex:i],[urlParams valueForKey:[formKeys objectAtIndex:i]]];
                }
            }
            NSString *urlString=[NSString stringWithFormat:@"%@?%@",urlStr,urlParamString];
#if !__has_feature(objc_arc)
            [urlParamString release];
#endif
            //考虑到中文不能直接在url中传到服务器，所以需要转码
            reqUrl = [NSURL URLWithString:[[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] relativeToURL:nil];
        }
        else{
            reqUrl=[NSURL URLWithString:urlStr];
        }
        
        //生成body数据
        if ([bodyParams count]>0) {
            if ([format isEqualToString:HFRequestForamtJson]) {
                NSData *jsonData=[NSJSONSerialization dataWithJSONObject:bodyParams options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"jsonStr=%@",jsonStr);
                bodyData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
#if !__has_feature(objc_arc)
                [jsonStr release];
#endif
                
                //NSString *content=@"application/json;charset=UTF-8";
                NSString *content=@"application/json";
                [header setObject:content forKey:@"Content-Type"];
                
            }
            else{
                NSMutableString *bodyString=[[NSMutableString alloc] init];
                NSArray *formKeys = [bodyParams allKeys];
                for (int i=0; i < [formKeys count]; i++) {
                    if (i==0) {
                        [bodyString appendFormat:@"%@=%@",[formKeys objectAtIndex:i],[bodyParams valueForKey:[formKeys objectAtIndex:i]]];
                    }
                    else {
                        [bodyString appendFormat:@"&%@=%@",[formKeys objectAtIndex:i],[bodyParams valueForKey:[formKeys objectAtIndex:i]]];
                    }
                }
                bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
#if !__has_feature(objc_arc)
                [bodyString release];
#endif
                
                NSString *content=@"application/x-www-form-urlencoded";
                [header setObject:content forKey:@"Content-Type"];
            }
        }
        
        [self setURL:reqUrl];
        [self setHTTPMethod:method];
        [self setHTTPBody:bodyData];
        
        for (NSString *key in [header allKeys]) {
            [self setValue:[header objectForKey:key] forHTTPHeaderField:key];
        }
#if !__has_feature(objc_arc)
        [header release];
#endif
    }
    return self;
}

/**
 *  上传资源
 *
 *  @param url          请求url
 *  @param urlParams    请求URL参数
 *  @param method       请求方法，默认为POST
 *  @param headerParams 请求header参数
 *  @param fileData     资源数据
 *  @param format       资源格式 默认为jpeg
 *
 *  @return
 */
- (id)initResourceRequestWithUrl:(NSString *)url
                       urlParams:(NSMutableDictionary *)urlParams
                          method:(NSString *)method
                    headerParams:(NSDictionary *)headerParams
                        fileData:(NSData *)fileData
                      fileFormat:(NSString *)format
{
    self=[super init];
    if (self) {
        NSMutableDictionary *header=[[NSMutableDictionary alloc] initWithDictionary:headerParams];  //请求的header
        NSURL *reqUrl=nil;  //请求的url
        NSData *bodyData=nil; //请求的body
        //拼接url
        if ([urlParams count]>0) {
            NSMutableString *urlParamString=[[NSMutableString alloc] init];
            NSArray *formKeys = [urlParams allKeys];
            for (int i=0; i < [formKeys count]; i++) {
                if (i==0) {
                    [urlParamString appendFormat:@"%@=%@",[formKeys objectAtIndex:i],[urlParams valueForKey:[formKeys objectAtIndex:i]]];
                }
                else {
                    [urlParamString appendFormat:@"&%@=%@",[formKeys objectAtIndex:i],[urlParams valueForKey:[formKeys objectAtIndex:i]]];
                }
            }
            NSString *urlString=[NSString stringWithFormat:@"%@?%@",url,urlParamString];
#if !__has_feature(objc_arc)
            [urlParamString release];
#endif
            //考虑到中文不能直接在url中传到服务器，所以需要转码
            reqUrl = [NSURL URLWithString:[[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] relativeToURL:nil];
        }
        else{
            reqUrl=[NSURL URLWithString:[[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] relativeToURL:nil];
        }
        
        bodyData=fileData;
        
        if (format) {
            [header setObject:[NSString stringWithFormat:@"image/%@;charset=UTF-8",format] forKey:@"Content-Type"];
        }
        else{
            [header setObject:@"image/jpeg" forKey:@"Content-Type"];
        }
        
        [header setObject:[NSString stringWithFormat:@"%lu",fileData.length] forKey:@"Content-Length"];
        
        [self setURL:reqUrl];
        [self setHTTPMethod:method];
        [self setHTTPBody:bodyData];
        
        for (NSString *key in [header allKeys]) {
            [self setValue:[header objectForKey:key] forHTTPHeaderField:key];
        }
#if !__has_feature(objc_arc)
        [header release];
#endif
    }
    return self;
}

@end
