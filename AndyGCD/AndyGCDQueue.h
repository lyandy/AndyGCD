//
//  AndyGCDQueue.h
//  AndyGCD_Test
//
//  Created by 李扬 on 2017/1/3.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AndyGCDGroup;

@interface AndyGCDQueue : NSObject

@property (strong, readwrite, nonatomic, nonnull) dispatch_queue_t dispatchQueue;

+ (nonnull AndyGCDQueue *)mainQueue;
+ (nullable AndyGCDQueue *)globalQueue;
+ (nullable AndyGCDQueue *)highPriorityGlobalQueue;
+ (nullable AndyGCDQueue *)lowPriorityGlobalQueue;
+ (nullable AndyGCDQueue *)backgroundPriorityGlobalQueue;

#pragma mark - 便利的构造方法
+ (void)executeInMainQueue:(dispatch_block_t __nonnull)block;
+ (void)executeInGlobalQueue:(dispatch_block_t __nonnull)block;
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t __nonnull)block;
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t __nonnull)block;
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t __nonnull)block;
+ (void)executeInMainQueue:(dispatch_block_t __nonnull)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInGlobalQueue:(dispatch_block_t __nonnull)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t __nonnull)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t __nonnull)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t __nonnull)block afterDelaySecs:(NSTimeInterval)sec;

#pragma 初始化
- (nullable instancetype)init;
- (nullable instancetype)initSerial;
- (nullable instancetype)initSerialWithLabel:(NSString * __nullable)label;
- (nullable instancetype)initConcurrent;
- (nullable instancetype)initConcurrentWithLabel:(NSString * __nullable)label;
- (nullable instancetype)initWithQOS:(NSQualityOfService)qos queueCount:(NSUInteger)queueCount;

#pragma mark - 用法
- (void)execute:(dispatch_block_t __nonnull)block;
- (void)execute:(dispatch_block_t __nonnull)block afterDelay:(int64_t)delta;
- (void)execute:(dispatch_block_t __nonnull)block afterDelaySecs:(float)delta;
- (void)waitExecute:(dispatch_block_t __nonnull)block;
- (void)barrierExecute:(dispatch_block_t __nonnull)block;
- (void)waitBarrierExecute:(dispatch_block_t __nonnull)block;
- (void)suspend;
- (void)resume;

#pragma mark - 与GCDGroup相关
- (void)execute:(dispatch_block_t __nonnull)block inGroup:(AndyGCDGroup * __nonnull)group;
- (void)notify:(dispatch_block_t __nonnull)block inGroup:(AndyGCDGroup * __nonnull)group;

#pragma mark - 与GCDApply相关
- (void)applyExecute:(size_t)iterations block:(DISPATCH_NOESCAPE void (^ __nonnull)(size_t index))block;

@end
