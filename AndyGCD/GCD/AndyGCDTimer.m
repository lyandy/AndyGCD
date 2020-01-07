//
//  AndyGCDTimer.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2017/1/3.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyGCDTimer.h"
#import "AndyGCDQueue.h"
#import "AndyGCDConst.h"

@interface AndyGCDTimer ()

@property (nonatomic, assign, getter=isSuspend) BOOL suspend;

@end

@implementation AndyGCDTimer

- (instancetype)init
{
    return [self initInQueue:nil];
}

- (instancetype)initInQueue:(AndyGCDQueue *)queue
{
    self = [super init];
    
    if (self)
    {
        if (queue == nil) queue = [AndyGCDQueue globalQueue];
        self.dispatchSource = \
        dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue.dispatchQueue);
        self.suspend = YES; // 默认创建的timer都是挂起的
    }
    
    return self;
}

- (void)timerExecute:(dispatch_block_t)block timeInterval:(uint64_t)interval
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)timerExecute:(dispatch_block_t)block timeInterval:(uint64_t)interval delay:(uint64_t)delay
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delay), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)timerExecute:(dispatch_block_t)block timeIntervalWithSecs:(float)secs
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)timerExecute:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delaySecs * NSEC_PER_SEC), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

// resume 必须从 挂起中 恢复
- (void)resume
{
    if (self.isSuspend == YES)
    {
        AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
        dispatch_resume(self.dispatchSource);
        self.suspend = NO;
    }
}

// suspend 必须从 恢复中 挂起
- (void)suspend
{
    if (self.isSuspend == NO)
    {
        AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
        dispatch_suspend(self.dispatchSource);
        self.suspend = YES;
    }
}

// 多次无条件的resume会crash
- (void)start
{
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_resume(self.dispatchSource);
    self.suspend = NO;
}

// cancel 必须从 resume 状态下取消
- (void)destroy
{
    [self resume];
    
    AndyGCDAssert(self.dispatchSource != nil, @"self.dispatchSource can not be nil");
    dispatch_source_cancel(self.dispatchSource);
}

@end
