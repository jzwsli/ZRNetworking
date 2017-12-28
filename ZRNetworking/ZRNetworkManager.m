//
//  ZRNetworkManager.m
//  ZRNetworkingDemo
//
//  Created by Lzr on 2017/12/25.
//  Copyright © 2017年 Lzr. All rights reserved.
//  ( https://github.com/jzwsli )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//


#import "ZRNetworkManager.h"
#import "ZRCacheManager.h"
#import <AFNetworkActivityIndicatorManager.h>

@interface ZRNetworkManager()
@property (nonatomic, strong) AFHTTPSessionManager *AFmanager;

@property AFNetworkReachabilityStatus netStatus;
@end

@implementation ZRNetworkManager

+ (ZRNetworkManager *)sharedInstance {
    static ZRNetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZRNetworkManager alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        self.request.timeoutInterval=15;
    }
    return self;
}
#pragma mark - GET/POST 配置请求
+ (void)requestWithConfig:(requestConfig)config  success:(requestSuccess)success failed:(requestFailed)failed{
    [[ZRNetworkManager sharedInstance]requestWithConfig:config success:success failed:failed];
}

+ (void)requestWithConfig:(requestConfig)config  progress:(progressBlock)progress success:(requestSuccess)success failed:(requestFailed)failed{
    [[ZRNetworkManager sharedInstance]requestWithConfig:config progress:progress success:success failed:failed];
}

- (void)requestWithConfig:(requestConfig)config success:(requestSuccess)success failed:(requestFailed)failed{
    return [self requestWithConfig:config progress:nil success:success failed:failed];
}

- (void)requestWithConfig:(requestConfig)config progress:(progressBlock)progress success:(requestSuccess)success failed:(requestFailed)failed{
    
    config ? config(self.request) : nil;
    if (self.request.methodType==POST) {
        [self POST:self.request.urlString parameters:self.request.parameters progress:progress success:success failed:failed];
    }else{
        if (self.request.apiType==ZRRequestTypeOffline) {
            [self offlineDownload:self.request.urlArray apiType:self.request.apiType success:success failed:failed];
        }else{
            [self GET:self.request.urlString parameters:self.request.parameters apiType:self.request.apiType progress:progress success:success failed:failed];
        }
    }
}

- (void)offlineDownload:(NSMutableArray *)downloadArray apiType:(apiType)type success:(requestSuccess)success failed:(requestFailed)failed{
    if (downloadArray.count==0)return;
    [downloadArray enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger idx, BOOL *stop) {
        [self GET:urlString parameters:nil apiType:type progress:nil success:success failed:failed ];
    }];
}

#pragma mark - GET 请求
- (void)GET:(NSString *)urlString success:(requestSuccess)success failed:(requestFailed)failed{
    [ZRNetworkManager GET:urlString success:success failed:failed];
}

- (void)GET:(NSString *)urlString parameters:(id)parameters success:(requestSuccess)success failed:(requestFailed)failed{
    [ZRNetworkManager GET:urlString parameters:parameters success:success failed:failed];
}

- (void)GET:(NSString *)urlString parameters:(id)parameters progress:(progressBlock)progress success:(requestSuccess)success failed:(requestFailed)failed{
    [ZRNetworkManager GET:urlString parameters:parameters progress:progress success:success failed:failed];
}

- (void)GET:(NSString *)urlString parameters:(id)parameters apiType:(apiType)type progress:(progressBlock)progress success:(requestSuccess)success failed:(requestFailed)failed{
    [ZRNetworkManager GET:urlString parameters:parameters apiType:type progress:progress success:success failed:failed];
}

+ (ZRNetworkManager *)GET:(NSString *)urlString success:(requestSuccess)success failed:(requestFailed)failed{
   return [ZRNetworkManager GET:urlString parameters:nil success:success failed:failed];
}

+ (ZRNetworkManager *)GET:(NSString *)urlString parameters:(id)parameters success:(requestSuccess)success failed:(requestFailed)failed{
   return [ZRNetworkManager GET:urlString parameters:parameters progress:nil success:success failed:failed];
}

+ (ZRNetworkManager *)GET:(NSString *)urlString parameters:(id)parameters progress:(progressBlock)progress success:(requestSuccess)success failed:(requestFailed)failed{
  return [ZRNetworkManager GET:urlString parameters:parameters apiType:ZRRequestTypeDefault progress:progress success:success failed:failed];
}

+ (ZRNetworkManager *)GET:(NSString *)urlString parameters:(id)parameters apiType:(apiType)type  progress:(progressBlock)progress success:(requestSuccess)success failed:(requestFailed)failed{

    if([urlString isEqualToString:@""]||urlString==nil)return nil;
    
    if (![urlString isKindOfClass:NSString.class]) {
        urlString = nil;
    }
    ZRNetworkManager *manager = [[ZRNetworkManager alloc] init];
    manager.request.urlString=urlString;
    manager.request.parameters=parameters;
    manager.request.apiType=type;
    manager.success=success;
    manager.failed=failed;
    manager.progres=progress;
    
    NSString *key = [manager.request stringUTF8Encoding:[manager.request urlString:urlString appendingParameters:parameters]];
    
    if ([[ZRCacheManager sharedInstance]diskCacheExistsWithKey:key]&&type!=ZRRequestTypeRefresh&&type!=ZRRequestTypeOffline){
        
        [[ZRCacheManager sharedInstance]getCacheDataForKey:key value:^(id responseObj,NSString *filePath) {
            [manager.request.responseObj appendData:responseObj];
            success ? success(manager.request.responseObj ,type) : nil;
        }];
        
    }else{
        //传urlString 不传key
        [manager GETRequest:urlString parameters:parameters progress:progress success:success failed:failed];
    }
    return manager;
}

- (void)GETRequest:(NSString *)urlString parameters:(id)parameters progress:(progressBlock)progress success:(requestSuccess)success failed:(requestFailed)failed{
    
    [self.AFmanager GET:[self.request stringUTF8Encoding:urlString] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress ? progress(downloadProgress) : nil;
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject) {
        
        NSString * key= [self.request stringUTF8Encoding:[self.request urlString:urlString appendingParameters:parameters]];

       [[ZRCacheManager sharedInstance] storeContent:responseObject forKey:key];
        
        success ? success(responseObject,self.request.apiType) : nil;
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        failed ? failed(error) : nil;
    }];    
}
#pragma mark - POST 请求
- (void)POST:(NSString *)urlString parameters:(id)parameters success:(requestSuccess)success failed:(requestFailed)failed{
    [ZRNetworkManager POST:urlString parameters:parameters success:success failed:failed];
}

- (void)POST:(NSString *)urlString parameters:(id)parameters progress:(progressBlock)progress success:(requestSuccess)success failed:(requestFailed)failed{
    [ZRNetworkManager POST:urlString parameters:parameters progress:progress success:success failed:failed];
}

+ (ZRNetworkManager *)POST:(NSString *)urlString parameters:(NSDictionary*)parameters success:(requestSuccess)success failed:(requestFailed)failed{
    
    return  [ZRNetworkManager POST:urlString parameters:parameters progress:nil success:success failed:failed];
}

+ (ZRNetworkManager *)POST:(NSString *)urlString parameters:(NSDictionary*)parameters progress:(progressBlock)progress success:(requestSuccess)success failed:(requestFailed)failed{
    
    ZRNetworkManager *manager  = [[ZRNetworkManager alloc] init];
    manager.request.urlString = urlString;
    manager.request.parameters=parameters;
    manager.success=success;
    manager.failed=failed;
     manager.progres=progress;
    [manager POSTRequest:urlString parameters:parameters progress:progress success:success failed:failed];
    return  manager;
}

- (void)POSTRequest:(NSString *)urlString parameters:(id)parameters progress:(progressBlock)progress success:(requestSuccess)success failed:(requestFailed)failed{
    if(!urlString)return;
    [self.AFmanager POST:[self.request stringUTF8Encoding:urlString] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress ? progress(uploadProgress) : nil;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success ? success(responseObject,self.request.apiType) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed ? failed(error) : nil;
    }];
    
}

#pragma mark - 其他配置
+ (void)requestToCancel:(BOOL)cancelPendingTasks{
    [[ZRNetworkManager sharedInstance].AFmanager invalidateSessionCancelingTasks:cancelPendingTasks];
}

+ (NSInteger)startNetWorkMonitoring{
    [ZRNetworkManager sharedInstance].netStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
   
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
         [ZRNetworkManager sharedInstance].netStatus=status;
        switch ( [ZRNetworkManager sharedInstance].netStatus)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return  [ZRNetworkManager sharedInstance].netStatus;
}

- (AFHTTPSessionManager*)AFmanager{
    if (!_AFmanager) {
        _AFmanager=[AFHTTPSessionManager manager];
        //和urlsession类 公用一个chche容器 返回类型全部是二进制
        _AFmanager.requestSerializer  = [AFHTTPRequestSerializer serializer];// 设置请求格式
        _AFmanager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 设置返回格式
        
        [[self.request mutableHTTPRequestHeaders] enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
            [_AFmanager.requestSerializer setValue:value forHTTPHeaderField:field];
        }];
        [_AFmanager.requestSerializer setTimeoutInterval:self.request.timeoutInterval];
        _AFmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json", @"text/plain",@"text/javascript",nil];
        //如果你用的是自签名的证书
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        _AFmanager.securityPolicy = securityPolicy;
    }
    
    return _AFmanager;
}

- (ZRURLRequest*)request{
    if (!_request) {
        _request=[[ZRURLRequest alloc]init];
    }
    return _request;
}

@end
