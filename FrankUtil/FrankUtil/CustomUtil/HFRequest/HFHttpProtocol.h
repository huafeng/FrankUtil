//
//  HFHttpProtocol.h
//  LaBaForB
//
//  Created by Admin on 15/2/3.
//  Copyright (c) 2015年 softlit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFURLConnection.h"
#import "HFURLRequest.h"

@interface HFHttpProtocol : NSObject<NSURLConnectionDelegate>
{
    dispatch_queue_t httpDataQue;
}

@property(nonatomic, retain) NSMutableDictionary *sendPackages;  //正在发起的请求

/**
 *  单例初始化
 *
 *  @return
 */
+ (id)defaultRequest;

/*取消当前所有正在发送的请求
 *@param
 *@return
 */
- (void)cancelAllRequest;

/*发起请求
 *@param   request   HFURLRequest请求的对象
 *@param   dict   请求参数
 *@param   className   请求类名
 */
- (void)sendSyncRequest:(HFURLRequest *)request
        successCallBack:(void (^)(id obj, NSInteger statusCode))successCallback
           failCallBack:(void (^)(id error))failCallback;

/*发起请求
 *@param   request   HFURLRequest请求的对象
 *@param   dict   请求参数
 *@param   className   请求类名
 */
- (HFURLConnection *)sendAsyncRequest:(HFURLRequest *)request
                            reqParams:(NSDictionary *)dict
                            className:(NSString *)className;

/*发起请求
 *@param   request   HFURLRequest请求的对象
 *@param   dict   请求参数
 *@param   object   请求对象
 *@param   callback   回调方法
 */
- (HFURLConnection *)sendAsyncRequest:(HFURLRequest *)request
                            reqParams:(NSDictionary *)dict
                               object:(id)object
                             callback:(SEL)callback;

@end
