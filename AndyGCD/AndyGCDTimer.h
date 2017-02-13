//
//  AndyGCDTimer.h
//  AndyGCD_Test
//
//  Created by 李扬 on 2017/1/3.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AndyGCDQueue;

@interface AndyGCDTimer : NSObject

@property (strong, readwrite, nonatomic, nullable) dispatch_source_t dispatchSource;

#pragma 初始化
- (nullable instancetype)init;
- (nullable instancetype)initInQueue:(AndyGCDQueue * __nullable)queue;

#pragma mark - 用法
- (void)timerExecute:(dispatch_block_t __nonnull)block timeInterval:(uint64_t)interval;
- (void)timerExecute:(dispatch_block_t __nonnull)block timeInterval:(uint64_t)interval delay:(uint64_t)delay;
- (void)timerExecute:(dispatch_block_t __nonnull)block timeIntervalWithSecs:(float)secs;
- (void)timerExecute:(dispatch_block_t __nonnull)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs;
- (void)start;
- (void)destroy;

@end
