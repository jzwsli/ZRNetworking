//
//  ZRCacheManager.h
//  ZRURLSessionManager
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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ZRCacheIsSuccessBlock)(BOOL isSuccess);
typedef void(^ZRCacheValueBlock)(id responseObj,NSString *filePath);
typedef void(^ZRCacheCompletedBlock)();

/**
 *  文件管理类:管理文件的路径,创建,存储,编码,显示,删除等功能.
 */
@interface ZRCacheManager : NSObject

/**
 * The maximum "total cost" of the in-memory image cache. The cost function is the number of pixels held in memory.
 * 设置缓存占用的内存大小，并不是一个严格的限制，当总数超过了totalCostLimit设定的值，系统会清除一部分缓存，直至总消耗低于totalCostLimit的值。
 */
@property (assign, nonatomic) NSUInteger memoryTotalCost;

/**
 * The maximum number of objects the cache should hold.
 * 设置内存对象的大小，这也不是一个严格的限制。
 */
@property (assign, nonatomic) NSUInteger memoryCountLimit;

//返回单例对象
+ (ZRCacheManager *)sharedInstance;

/**
 获取沙盒Home的文件目录

 @return Home           路径
 */
- (NSString *)homePath;

/**
  获取沙盒Document的文件目录

 @return Document       路径
 */
- (NSString *)documentPath;

/**
  获取沙盒Library的文件目录
 
 @return Document       路径
 */
- (NSString *)libraryPath;

/**
 获取沙盒Library/Caches的文件目录
 
 @return Library/Caches 路径
 */
- (NSString *)cachesPath;

/**
 获取沙盒tmp的文件目录
 
 @return tmp路径
 */
- (NSString *)tmpPath;

/**
 获取沙盒自创建的ZRKit文件目录
 
 @return Library/Caches/ZRKit路径
 */
- (NSString *)ZRKitPath;

/**
 获取沙盒默认创建的AppCache文件目录
 
 @return Library/Caches/ZRKit/AppCache路径
 */
- (NSString *)ZRAppCachePath;

/**
 创建沙盒文件夹

 @param path            路径
 */
- (void)createDirectoryAtPath:(NSString *)path;

/**
 把内容,存储到文件
 
 @param content         数据
 @param key             url
 */
- (void)storeContent:(NSObject *)content forKey:(NSString *)key;

/**
 把内容,存储到文件
 
 @param content         数据
 @param key             url
 @param isSuccess       是否存储成功
 */
- (void)storeContent:(NSObject *)content forKey:(NSString *)key isSuccess:(ZRCacheIsSuccessBlock)isSuccess;

/**
 把内容,存储到文件
 
 @param content         数据
 @param key             url
 @param path            路径
 */
- (void)storeContent:(NSObject *)content forKey:(NSString *)key path:(NSString *)path;

/**
 把内容,存储到文件
 
 @param content         数据
 @param key             url
 @param path            路径
 @param isSuccess       是否存储成功
 */
- (void)storeContent:(NSObject *)content forKey:(NSString *)key path:(NSString *)path isSuccess:(ZRCacheIsSuccessBlock)isSuccess;

/**
 把内容,写入到文件
 
 @param content         数据
 @param path            路径
 */
- (BOOL)setContent:(NSObject *)content writeToFile:(NSString *)path;

/**
 判断沙盒是否对应的值
 
 @param key             url
 
 @return YES/NO
 */
- (BOOL)diskCacheExistsWithKey:(NSString *)key;

/**
 判断沙盒是否对应的值
 
 @param key             url
 @param path            沙盒路径
 @return YES/NO
 */
- (BOOL)diskCacheExistsWithKey:(NSString *)key path:(NSString *)path;

/**
 *  返回数据及路径
 *  @param  key         存储的文件的url
 *  @param  value       返回在本地的数据及存储文件路径
 */
- (void)getCacheDataForKey:(NSString *)key value:(ZRCacheValueBlock)value;

/**
 *  返回数据及路径
 *  @param  key         存储的文件的url
 *  @param  path        存储的文件的路径
 *  @param  value       返回在本地的数据及存储文件路径
 */
- (void)getCacheDataForKey:(NSString *)key path:(NSString *)path value:(ZRCacheValueBlock)value;

/**
 *返回某个路径下的所有数据文件
 * @param path          路径
 * @return array        所有数据
 */
- (NSArray *)getDiskCacheFileWithPath:(NSString *)path;

/**
 *  返回缓存文件的属性     
 * @param path          路径
 *  @param key          缓存文件
 */
-(NSDictionary* )getDiskFileAttributes:(NSString *)key path:(NSString *)path;

/**
 *  查找存储的文件         默认缓存路径/Library/Caches/ZRKit/AppCache
 *  @param  key         存储的文件
 *
 *  @return 根据存储的文件，返回在本地的存储路径
 */
- (NSString *)diskCachePathForKey:(NSString *)key;

/**
 拼接路径与编码后的文件

 @param key             文件
 @param path            自定义路径

 @return 完整的文件路径
 */
- (NSString *)cachePathForKey:(NSString *)key path:(NSString *)path;

/**
 * 显示data文件缓存大小 默认缓存路径/Library/Caches/ZRKit/AppCache
 * Get the size used by the disk cache
 */
- (NSUInteger)getCacheSize;

/**
 * 显示data文件缓存个数 默认缓存路径/Library/Caches/ZRKit/AppCache
 * Get the number of file in the disk cache
 */
- (NSUInteger)getCacheCount;

/**
 显示文件大小

 @param path            自定义路径

 @return size           大小
 */
- (NSUInteger)getFileSizeWithpath:(NSString *)path;

/**
 显示文件个数
 
 @param  path           自定义路径
 
 @return count          数量
 */
- (NSUInteger)getFileCountWithpath:(NSString *)path;

/**
 显示文件的大小单位
 
 @param size            得到的大小
 
 @return 显示的单位 GB/MB/KB
 */
- (NSString *)fileUnitWithSize:(float)size;

/**
  磁盘总空间大小
 
 @return size           大小
 */
- (NSUInteger)diskSystemSpace;

/**
 磁盘空闲系统空间

 @return size           大小
 */
- (NSUInteger)diskFreeSystemSpace;

/**
 *  设置过期时间 清除路径下的全部过期缓存文件 默认路径/Library/Caches/ZRKit/AppCache
 *  Remove all expired cached file from disk
 *  @param time         时间
 *  @param completion   block 后续操作
 */
- (void)clearCacheWithTime:(NSTimeInterval)time completion:(ZRCacheCompletedBlock)completion;

/** 
 *  设置过期时间 清除路径下的全部过期缓存文件 自定义路径
 *  Remove all expired cached file from disk
 *  @param time         时间
 *  @param path         路径
 *  @param completion   block 后续操作
 */
- (void)clearCacheWithTime:(NSTimeInterval)time path:(NSString *)path completion:(ZRCacheCompletedBlock)completion;

/**
 *  接收到进入后台通知，后台清理缓存方法
 *  @param path         自定义路径
 */
- (void)backgroundCleanCacheWithPath:(NSString *)path;

/**
 *  清除某一个缓存文件      默认路径/Library/Caches/ZRKit/AppCache
 *  @param key          请求的协议地址
 */
- (void)clearCacheForkey:(NSString *)key;

/**
 *  清除某一个缓存文件      默认路径/Library/Caches/ZRKit/AppCache
 *
 *  @param key          请求的协议地址
 *  @param completion   block 后续操作
 */
- (void)clearCacheForkey:(NSString *)key completion:(ZRCacheCompletedBlock)completion;

/**
 *  清除某一个缓存文件     自定义路径
 *  @param key          请求的协议地址
 *  @param path         自定义路径
 *  @param completion   block 后续操作
 */
- (void)clearCacheForkey:(NSString *)key path:(NSString *)path completion:(ZRCacheCompletedBlock)completion;

/** 
 *  设置过期时间 清除某一个缓存文件  默认路径/Library/Caches/ZRKit/AppCache
 *  @param key          请求的协议地址
 *  @param time         时间 注:时间前要加 “-” 减号
 */
- (void)clearCacheForkey:(NSString *)key time:(NSTimeInterval)time;

/**
 *  设置过期时间 清除某一个缓存文件  默认路径/Library/Caches/ZRKit/AppCache
 *  @param key          请求的协议地址
 *  @param time         时间 注:时间前要加 “-” 减号
 *  @param completion   block 后续操作
 */
- (void)clearCacheForkey:(NSString *)key time:(NSTimeInterval)time completion:(ZRCacheCompletedBlock)completion;

/**
 *  设置过期时间 清除某一个缓存文件  自定义路径
 *  Remove all expired cached file from disk
 *  @param key          请求的协议地址
 *  @param time         时间 注:时间前要加 “-” 减号
 *  @param path         路径
 *  @param completion   block 后续操作
 */
- (void)clearCacheForkey:(NSString *)key time:(NSTimeInterval)time path:(NSString *)path completion:(ZRCacheCompletedBlock)completion;

/**
 *  清除磁盘缓存 /Library/Caches/ZRKit/AppCache
 *  Clear AppCache disk cached
 */
- (void)clearCache;

/**
 *  清除磁盘缓存 /Library/Caches/ZRKit/AppCache
 *  @param completion   block 后续操作
 */
- (void)clearCacheOnCompletion:(ZRCacheCompletedBlock)completion;

/**
 清除某一磁盘路径下的文件

 @param path 路径
 */
- (void)clearDiskWithpath:(NSString *)path;

/**
 清除某一磁盘路径下的文件

 @param path            路径
 @param completion      block 后续操作
 */
- (void)clearDiskWithpath:(NSString *)path completion:(ZRCacheCompletedBlock)completion;



@end



