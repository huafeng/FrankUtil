//
//  HFHttpRequest.m
//  FunTest
//
//  Created by aa on 14-8-28.
//  Copyright (c) 2014年 aa. All rights reserved.
//

#import "HFHttpRequest.h"
#import "HFURLRequest.h"
#import "HFHttpProtocol.h"


@implementation HFHttpRequest

//单例初始化
+ (id)shareRequest
{
    static HFHttpRequest *request=nil;
    if (request==nil) {
        request=[[[self class] alloc] init];
    }
    return request;
}

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
    
}

/**
 *  发起同步请求
 *
 *  @param url          请求URL
 *  @param urlParams    放在URL里面的参数
 *  @param method       请求方法
 *  @param headerParams 放在header里面的参数
 *  @param bodyParams   放在body里面的参数
 *  @param format       body数据格式(JSON等等）
 *  @param successCallback     成功回调
 *  @param failCallback     失败回调
 */
+ (void)sendSyncRequest:(NSString *)url
              urlParams:(NSMutableDictionary *)urlParams
                 method:(NSString *)method
           headerParams:(NSDictionary *)headerParams
             bodyParams:(NSDictionary *)bodyParams
             bodyFormat:(NSString *)format
        successCallback:(void (^)(id ret, NSInteger status))successCallback
           failCallback:(void (^)(id error))failCallback
{
    HFURLRequest *request=[[HFURLRequest alloc] initRequestWithUrl:url
                                                          urlParams:urlParams
                                                             method:method
                                                       headerParams:headerParams
                                                         bodyParams:bodyParams
                                                             format:format];
    
    [[HFHttpProtocol defaultRequest] sendSyncRequest:request
                                     successCallBack:successCallback
                                        failCallBack:failCallback];
#if !__has_feature(objc_arc)
    [request release];
#endif
}

/**
 *  发起异步请求
 *
 *  @param url          请求URL
 *  @param urlParams    放在URL里面的参数
 *  @param method       请求方法
 *  @param headerParams 放在header里面的参数
 *  @param bodyParams   放在body里面的参数
 *  @param format       body数据格式(JSON等等）
 *  @param className     类名
 *  @param reqParams    需要带回来的参数
 */
+ (void)sendAsyncRequest:(NSString *)url
               urlParams:(NSMutableDictionary *)urlParams
                  method:(NSString *)method
            headerParams:(NSDictionary *)headerParams
              bodyParams:(NSDictionary *)bodyParams
              bodyFormat:(NSString *)format
               className:(NSString *)className
               reqParams:(NSDictionary *)reqParams
{
    HFURLRequest *request=[[HFURLRequest alloc] initRequestWithUrl:url
                                                          urlParams:urlParams
                                                             method:method
                                                       headerParams:headerParams
                                                         bodyParams:bodyParams
                                                             format:format];
    NSString *cName=className;
    if (!cName) {
        cName=NSStringFromClass([self class]);
    }
    [[HFHttpProtocol defaultRequest] sendAsyncRequest:request
                                            reqParams:reqParams
                                            className:cName];
#if !__has_feature(objc_arc)
    [request release];
#endif
    
}

/**
 *  进度返回
 *
 *  @param object 返回的对象
 */
+ (void)requestProgressCallBack:(NSDictionary *)obj
{
//    NSDictionary *dict=obj;
//    float progress=[[dict objectForKey:@"progress"] floatValue];
}

/**
 *  请求结果返回
 *
 *  @param obj 返回的对象
 */
+ (void)requestResultCallBack:(NSDictionary *)obj
{
    
}




@end
