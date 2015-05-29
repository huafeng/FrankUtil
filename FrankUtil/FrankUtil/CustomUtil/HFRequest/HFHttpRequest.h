//
//  HFHttpRequest.h
//  FunTest
//
//  Created by aa on 14-8-28.
//  Copyright (c) 2014年 aa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFHttpRequest : NSObject


//单例初始化
+ (id)shareRequest;



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
           failCallback:(void (^)(id error))failCallback;

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
               reqParams:(NSDictionary *)reqParams;


#pragma mark-----为了子类继承使用，方便回调-------------

/**
 *  进度返回
 *
 *  @param obj 返回的对象
 */
+ (void)requestProgressCallBack:(NSDictionary *)obj;

/**
 *  请求结果返回
 *
 *  @param obj 返回的对象
 */
+ (void)requestResultCallBack:(NSDictionary *)obj;


@end
