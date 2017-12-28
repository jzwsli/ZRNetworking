

//
//  ZRURLRequest.m
//  ZRNetworkingDemo
//
//  Created by Lzr on 2017/12/25.
//  Copyright © 2017年 Lzr. All rights reserved.
//  ( https://github.com/jzwsli )
//

#import "ZRURLRequest.h"

@interface ZRURLRequest()
/**
 *  离线下载栏目url容器
 */
@property (nonatomic,strong) NSMutableArray *channelUrlArray;

/**
 *  离线下载栏目名字容器
 */
@property (nonatomic,strong) NSMutableArray *channelKeyArray;

@end


@implementation ZRURLRequest

- (void)dealloc{
    ZRLog(@"%s",__func__);
}

+ (ZRURLRequest *)sharedInstance {
    static ZRURLRequest *request=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[ZRURLRequest alloc] init];
    });
    return request;
}

- (void)setValue:(NSString *)value forHeaderField:(NSString *)field{
    if (value) {
        [self.mutableHTTPRequestHeaders setValue:value forKey:field];
    }
    else {
        [self removeHeaderForkey:field];
    }
}

- (NSString *)objectHeaderForKey:(NSString *)key{
    return  [self.mutableHTTPRequestHeaders objectForKey:key];
}

- (void)removeHeaderForkey:(NSString *)key{
    if(!key)return;
    [self.mutableHTTPRequestHeaders removeObjectForKey:key];
}

- (NSMutableArray *)offlineUrlArray{
    return self.channelUrlArray;
}

- (NSMutableArray *)offlineKeyArray{
    return self.channelKeyArray;
}

- (void)addObjectWithUrl:(NSString *)urlString{
    [self addObjectWithForKey:urlString isUrl:YES];
}

- (void)removeObjectWithUrl:(NSString *)urlString{
    [self removeObjectWithForkey:urlString isUrl:YES];
}

- (void)addObjectWithKey:(NSString *)key{
    [self addObjectWithForKey:key isUrl:NO];
}

- (void)removeObjectWithKey:(NSString *)key{
    [self removeObjectWithForkey:key isUrl:NO];
}

- (void)removeOfflineArray{

    [self.offlineUrlArray removeAllObjects];
    [self.offlineKeyArray removeAllObjects];
}


- (BOOL)isAddForKey:(NSString *)key isUrl:(BOOL)isUrl{
    
    if (isUrl==YES) {
        @synchronized (self.channelUrlArray) {
            return  [self.channelUrlArray containsObject: key];
        }
    }else{
        @synchronized (self.channelKeyArray) {
            return  [self.channelKeyArray containsObject: key];
        }
    }
}

- (void)addObjectWithForKey:(NSString *)key isUrl:(BOOL)isUrl{
    if (isUrl==YES) {
        
        if ([self isAddForKey:key isUrl:isUrl]==1) {
            ZRLog(@"已经包含该栏目URL");
        }else{
            @synchronized (self.channelUrlArray) {
                [self.channelUrlArray addObject:key];
            }
        }
    }else{
        
        if ([self isAddForKey:key isUrl:isUrl]==1) {
            ZRLog(@"已经包含该栏目名字");
        }else{
            @synchronized (self.channelKeyArray ) {
                [self.channelKeyArray addObject:key];
            }
        }
    }
}

- (void)removeObjectWithForkey:(NSString *)key isUrl:(BOOL)isUrl{
    if (isUrl==YES) {
        if ([self isAddForKey:key isUrl:isUrl]==1) {
            @synchronized (self.channelUrlArray) {
                [self.channelUrlArray removeObject:key];
            }
        }else{
            ZRLog(@"已经删除该栏目URL");
        }
        
    }else{
        
        if ([self isAddForKey:key isUrl:isUrl]==1) {
            @synchronized (self.channelKeyArray) {
                [self.channelKeyArray removeObject:key];
            }
        }else{
            ZRLog(@"已经删除该栏目名字");
        }
    }
}

- (void)setRequestObject:(id)obj forkey:(NSString *)key{
    
    if (obj) {
        @synchronized (self.requestDic){
            [self.requestDic setObject:obj forKey:key];
        }
    }
}

- (void)removeRequestForkey:(NSString *)key{
    
    if(!key)return;
        @synchronized (self.requestDic){
          [self.requestDic removeObjectForKey:key];
        }
}

- (NSString *)stringUTF8Encoding:(NSString *)urlString{
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlString:(NSString *)urlString appendingParameters:(id)parameters{
    if (parameters==nil) {
        return urlString;
    }else{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *key in parameters) {
            id obj = [parameters objectForKey:key];
            NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
            [array addObject:str];
        }
        
        NSString *parametersString = [array componentsJoinedByString:@"&"];
        return  [urlString stringByAppendingString:[NSString stringWithFormat:@"?%@",parametersString]];
    }
}

- (NSMutableDictionary *)requestDic{
    
    if (!_requestDic) {
        _requestDic  = [[NSMutableDictionary alloc]init];
    }
    return _requestDic;
}

- (NSMutableArray *)channelUrlArray{
    
    if (!_channelUrlArray) {
        _channelUrlArray=[[NSMutableArray alloc]init];
    }
    return _channelUrlArray;
}

- (NSMutableArray *)channelKeyArray{
    
    if (!_channelKeyArray) {
        _channelKeyArray=[[NSMutableArray alloc]init];
    }
    return _channelKeyArray;
}

- (NSMutableDictionary *)mutableHTTPRequestHeaders{
    
    if (!_mutableHTTPRequestHeaders) {
        _mutableHTTPRequestHeaders  = [[NSMutableDictionary alloc]init];
    }
    return _mutableHTTPRequestHeaders;
}

- (NSMutableData *)responseObj {
    if (!_responseObj) {
        _responseObj=[[NSMutableData alloc]init];
    }
    return _responseObj;
}

@end
