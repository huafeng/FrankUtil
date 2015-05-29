//
//  HFHttpProtocol.m
//  LaBaForB
//
//  Created by Admin on 15/2/3.
//  Copyright (c) 2015年 softlit. All rights reserved.
//

#import "HFHttpProtocol.h"
#import "GZIP.h"
#import "HFHttpRequest.h"


#define requestTimeOutInterval       30    //请求超时设置
#define cerFileName @"client"        //证书路径
#define cerPassword CFSTR("123456")   //证书密码

@implementation HFHttpProtocol

/**
 *  单例初始化
 *
 *  @return
 */
+ (id)defaultRequest
{
    static HFHttpProtocol *protocol=nil;
    if (!protocol) {
        protocol=[[[self class] alloc] init];
    }
    
    return protocol;
}

- (id)init
{
    self=[super init];
    if (self) {
        httpDataQue=dispatch_queue_create("com.http.requestThread", DISPATCH_QUEUE_SERIAL);
        NSMutableDictionary *packageDict=[[NSMutableDictionary alloc] init];
        self.sendPackages=packageDict;
#if !__has_feature(objc_arc)
        [packageDict release];
#endif
        
    }
    return self;
}

- (void)dealloc
{
    self.sendPackages=nil;
#if !__has_feature(objc_arc)
    dispatch_release(httpDataQue);
    [super dealloc];
#endif
}

/*取消当前所有正在发送的请求
 *@param
 *@return
 */
- (void)cancelAllRequest
{
    for (int i=0; i<[self.sendPackages allKeys].count; i++) {  //取消当前所有还在发起的请求
        NSString *tagStr=[[self.sendPackages allKeys] objectAtIndex:i];
        NSMutableDictionary *rDict=[self.sendPackages objectForKey:tagStr];
        HFURLConnection *urlConnection=[rDict objectForKey:@"reqConnection"];
        if (urlConnection) {
            [urlConnection cancel];
        }
    }
    [self.sendPackages removeAllObjects];
}

/*发起请求
 *@param   request   HFURLRequest请求的对象
 *@param   dict   请求参数
 *@param   className   请求类名
 */
- (void)sendSyncRequest:(HFURLRequest *)request
        successCallBack:(void (^)(id obj, NSInteger statusCode))successCallback
           failCallBack:(void (^)(id error))failCallback
{
    dispatch_async(httpDataQue, ^{
        NSHTTPURLResponse *response=nil;
        NSError *error=nil;
        NSData *retData=[HFURLConnection sendSynchronousRequest:request
                                              returningResponse:&response
                                                          error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failCallback(error);
            });
            return;
        }
        id retObj=[NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(retObj, response.statusCode);
        });
    });
}

/*发起请求
 *@param   request   HFURLRequest请求的对象
 *@param   dict   请求参数
 *@param   className   请求类名
 */
- (HFURLConnection *)sendAsyncRequest:(HFURLRequest *)request
                            reqParams:(NSDictionary *)dict
                            className:(NSString *)className
{
    [request setTimeoutInterval:requestTimeOutInterval];
    HFURLConnection *connection=[[HFURLConnection alloc] initWithRequest:request delegate:self];
    NSMutableDictionary *myDict=[[NSMutableDictionary alloc] init];
    [myDict setObject:connection forKey:@"reqConnection"];
    if (dict) {
        [myDict setObject:dict forKey:@"seq"];  //需要返回的参数
    }
    if (className) {
        [myDict setObject:className forKey:@"className"];  //类名
    }
    [self.sendPackages setObject:myDict forKey:connection.tag];
#if !__has_feature(objc_arc)
    [myDict release];
    return [connection autorelease];
#else
    return connection;
#endif
}

/*发起请求
 *@param   request   HFURLRequest请求的对象
 *@param   dict   请求参数
 *@param   object   请求对象
 *@param   callback   回调方法
 */
- (HFURLConnection *)sendAsyncRequest:(HFURLRequest *)request
                            reqParams:(NSDictionary *)dict
                               object:(id)object
                             callback:(SEL)callback
{
    [request setTimeoutInterval:requestTimeOutInterval];
    HFURLConnection *connection=[[HFURLConnection alloc] initWithRequest:request delegate:self];
    NSMutableDictionary *myDict=[[NSMutableDictionary alloc] init];
    [myDict setObject:connection forKey:@"reqConnection"];
    if (dict) {
        [myDict setObject:dict forKey:@"seq"];  //需要返回的参数
    }
    if (object) {
        [myDict setObject:object forKey:@"object"];  //类名
    }
    if (callback) {
        [myDict setObject:NSStringFromSelector(callback) forKey:@"callback"];
    }
    [self.sendPackages setObject:myDict forKey:connection.tag];
#if !__has_feature(objc_arc)
    [myDict release];
    return [connection autorelease];
#else
    return connection;
#endif
}

- (BOOL)isResponseGZiped:(NSHTTPURLResponse *)response
{
    NSString *encoding = [[response allHeaderFields] objectForKey:@"Content-Encoding"];
    return encoding && [encoding rangeOfString:@"gzip"].location != NSNotFound;
}

#pragma mark-
#pragma ---------------------------connection delegate-------------------
#pragma mark-

- (void)connection:(HFURLConnection *)connection didFailWithError:(NSError *)error
{
    //失败
    [self httpRequestCallBack:nil withRequestTag:connection.tag responseCode:[connection.response statusCode] error:error];
}

- (void)connection:(HFURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    connection.response = response;
}

- (void)connection:(HFURLConnection *)connection didReceiveData:(NSData *)data
{
    [connection.data appendData:data];
}

- (void)connectionDidFinishLoading:(HFURLConnection *)connection
{
    NSData *responseData;
    if([self isResponseGZiped:connection.response])
    {
        responseData = [connection.data gunzippedData];
        
    }else{
        responseData = connection.data;
    }
    
    [self httpRequestCallBack:responseData withRequestTag:connection.tag responseCode:[connection.response statusCode] error:nil];
}

- (BOOL)connection:(HFURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    BOOL result = NO;
    if ([protectionSpace authenticationMethod] == NSURLAuthenticationMethodServerTrust) {
        result = YES;
    } else if([protectionSpace authenticationMethod] == NSURLAuthenticationMethodClientCertificate) {
        result = YES;
    }
    return result;
}

- (void)connection:(HFURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
        NSString *authMethod = [protectionSpace authenticationMethod];
        if(authMethod == NSURLAuthenticationMethodServerTrust ) {
            [[challenge sender] useCredential:[NSURLCredential credentialForTrust:[protectionSpace serverTrust]] forAuthenticationChallenge:challenge];
            [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
        }
        else if(authMethod == NSURLAuthenticationMethodClientCertificate ) {
            NSString *p12Path = [[NSBundle mainBundle] pathForResource:cerFileName ofType:@"dat"];
            NSData *p12data = [NSData dataWithContentsOfFile:p12Path];
            CFDataRef inP12data = (__bridge CFDataRef)p12data;
            
            CFStringRef password = cerPassword;
            const void *keys[] = { kSecImportExportPassphrase };
            const void *values[] = { password };
            CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
            CFArrayRef p12Items = nil;
            
            OSStatus result = SecPKCS12Import((CFDataRef)inP12data, optionsDictionary, &p12Items);
            
            if(result == noErr) {
                CFDictionaryRef identityDict = CFArrayGetValueAtIndex(p12Items, 0);
                SecIdentityRef identityApp =(SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
                
                SecCertificateRef certRef;
                SecIdentityCopyCertificate(identityApp, &certRef);
                
                SecCertificateRef certArray[1] = { certRef };
                CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
#if !__has_feature(objc_arc)
                CFRelease(certRef);
#endif
                
                NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identityApp certificates:(__bridge NSArray *)myCerts persistence:NSURLCredentialPersistencePermanent];
#if !__has_feature(objc_arc)
                CFRelease(myCerts);
#endif
                
                [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
            }
#if !__has_feature(objc_arc)
            CFRelease(optionsDictionary);
            CFRelease(p12Items);
#endif
        }
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        
    }
}

- (void)connection:(HFURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
        NSString *authMethod = [protectionSpace authenticationMethod];
        if(authMethod == NSURLAuthenticationMethodServerTrust ) {
            [[challenge sender] useCredential:[NSURLCredential credentialForTrust:[protectionSpace serverTrust]] forAuthenticationChallenge:challenge];
            [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
        }
        else if(authMethod == NSURLAuthenticationMethodClientCertificate ) {
            NSString *p12Path = [[NSBundle mainBundle] pathForResource:cerFileName ofType:@"dat"];
            NSData *p12data = [NSData dataWithContentsOfFile:p12Path];
            CFDataRef inP12data = (__bridge CFDataRef)p12data;
            
            CFStringRef password = cerPassword;
            const void *keys[] = { kSecImportExportPassphrase };
            const void *values[] = { password };
            CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
            CFArrayRef p12Items = nil;
            
            OSStatus result = SecPKCS12Import((CFDataRef)inP12data, optionsDictionary, &p12Items);
            
            if(result == noErr) {
                CFDictionaryRef identityDict = CFArrayGetValueAtIndex(p12Items, 0);
                SecIdentityRef identityApp =(SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
                
                SecCertificateRef certRef;
                SecIdentityCopyCertificate(identityApp, &certRef);
                
                SecCertificateRef certArray[1] = { certRef };
                CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
#if !__has_feature(objc_arc)
                CFRelease(certRef);
#endif
                
                NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identityApp certificates:(__bridge NSArray *)myCerts persistence:NSURLCredentialPersistencePermanent];
#if !__has_feature(objc_arc)
                CFRelease(myCerts);
#endif
                
                [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
            }
#if !__has_feature(objc_arc)
            CFRelease(optionsDictionary);
            CFRelease(p12Items);
#endif
        }
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        
    }
}

- (void)connection:(HFURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSString *tag = [connection tag];
    NSMutableDictionary *sendDict=[self.sendPackages objectForKey:tag];
    NSString *className=[sendDict objectForKey:@"className"];
    NSDictionary *seqDict=[sendDict objectForKey:@"seq"];  //需要返回的参数
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithFloat:totalBytesWritten] forKey:@"sentBytes"];
    [dict setObject:[NSNumber numberWithFloat:totalBytesExpectedToWrite] forKey:@"totalBytes"];
    float progress = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
    [dict setObject:[NSNumber numberWithFloat:progress] forKey:@"progress"];
    
    if (seqDict) {
        [dict setObject:seqDict forKey:@"seqDict"];
    }
    if ([NSClassFromString(className) respondsToSelector:@selector(requestProgressCallBack:)])
    {
        [NSClassFromString(className) requestProgressCallBack:dict];
    }
#if !__has_feature(objc_arc)
    [dict release];
#endif
}

- (void)connection:(HFURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
    NSString *tag = [connection tag];
    NSMutableDictionary *sendDict=[self.sendPackages objectForKey:tag];
    NSString *className=[sendDict objectForKey:@"className"];
    NSDictionary *seqDict=[sendDict objectForKey:@"seq"];  //需要返回的参数
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithFloat:totalBytesWritten] forKey:@"sentBytes"];
    [dict setObject:[NSNumber numberWithFloat:expectedTotalBytes] forKey:@"totalBytes"];
    float progress = (float)totalBytesWritten/(float)expectedTotalBytes;
    [dict setObject:[NSNumber numberWithFloat:progress] forKey:@"progress"];
    
    if (seqDict) {
        [dict setObject:seqDict forKey:@"seqDict"];
    }
    
    if ([NSClassFromString(className) respondsToSelector:@selector(requestProgressCallBack:)])
    {
        [NSClassFromString(className) requestProgressCallBack:dict];
    }
#if !__has_feature(objc_arc)
    [dict release];
#endif
}

#pragma mark-
#pragma mark----------------request callback------------------------
#pragma mark-

- (void)httpRequestCallBack:(NSData *)retData withRequestTag:(NSString *)tag responseCode:(NSInteger)code error:(NSError *)error
{
    NSMutableDictionary *sendDict=[self.sendPackages objectForKey:tag];
    NSString *className=[sendDict objectForKey:@"className"];
    id object = [sendDict objectForKey:@"object"];
    NSString *callback = [sendDict objectForKey:@"callback"];
    
    NSDictionary *seqDict=[sendDict objectForKey:@"seq"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    if (!error) {  //如果不成功，就不需要做josn数据解析
        id retDict=[NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:nil];
        if (retDict) {
            [dict setObject:retDict forKey:@"data"];
        }
        
        [dict setObject:[NSNumber numberWithInteger:code] forKey:@"statusCode"];
        
    }
    else {
        [dict setObject:error forKey:@"error"];
    }
    
    if (seqDict) {
        [dict setObject:seqDict forKey:@"seq"];
    }
    
    if (className) {
        if ([NSClassFromString(className) respondsToSelector:@selector(requestResultCallBack:)])
        {
            [NSClassFromString(className) requestResultCallBack:dict];
        }
    }
    
    if (object && callback) {
        SEL resultCallBack = NSSelectorFromString(callback);
        if ([object respondsToSelector:resultCallBack]) {
            [object performSelector:resultCallBack withObject:dict afterDelay:0.0];
        }
    }
    
#if !__has_feature(objc_arc)
    [dict release];
#endif
    
    //从下载列表中移除
    [self.sendPackages removeObjectForKey:tag];
}

@end
