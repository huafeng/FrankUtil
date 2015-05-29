//
//  HFHttpProt.h
//  LaBaForB
//
//  Created by Admin on 15/2/2.
//  Copyright (c) 2015年 softlit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HFRequestForamtJson    @"json"

@interface HFURLRequest : NSMutableURLRequest

@property (nonatomic) BOOL isAuthentication;

- (void)acceptGZip;
- (void)notAcceptGZip;
- (BOOL)isAcceptGZip;
- (void)sendGZip;
- (BOOL)isSendGZip;


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
                  format:(NSString *)format;

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
                      fileFormat:(NSString *)format;

@end
