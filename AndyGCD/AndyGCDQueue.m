//
//  AndyGCDQueue.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2017/1/3.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyGCDQueue.h"
#import "AndyGCDGroup.h"
#import "AndyGCDConst.h"
#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>

#define MAX_QUEUE_COUNT 32

static inline qos_class_t NSQualityOfServiceToQOSClass(NSQualityOfService qos)
{
    switch (qos) {
        case NSQualityOfServiceUserInteractive: return QOS_CLASS_USER_INTERACTIVE;
        case NSQualityOfServiceUserInitiated: return QOS_CLASS_USER_INITIATED;
        case NSQualityOfServiceUtility: return QOS_CLASS_UTILITY;
        case NSQualityOfServiceBackground: return QOS_CLASS_BACKGROUND;
        case NSQualityOfServiceDefault: return QOS_CLASS_DEFAULT;
        default: return QOS_CLASS_UNSPECIFIED;
    }
}

typedef struct {
    void **queues;
    uint32_t queueCount;
    int32_t counter;
} AndyDispatchContext;

static AndyDispatchContext *AndyDispatchContextCreate(uint32_t queueCount, NSQualityOfService qos) {
    AndyDispatchContext *context = calloc(1, sizeof(AndyDispatchContext));
    if (!context) return NULL;
    context->queues =  calloc(queueCount, sizeof(void *));
    if (!context->queues)
    {
        free(context);
        return NULL;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
    {
        dispatch_qos_class_t qosClass = NSQualityOfServiceToQOSClass(qos);
        for (NSUInteger i = 0; i < queueCount; i++) {
            dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qosClass, 0);
            dispatch_queue_t queue = dispatch_queue_create(nil, attr);
            context->queues[i] = (__bridge_retained void *)(queue);
        }
    }
    context->queueCount = queueCount;
    return context;
}

static void AndyDispatchContextRelease(AndyDispatchContext *context) {
    if (!context) return;
    if (context->queues)
    {
        for (NSUInteger i = 0; i < context->queueCount; i++) {
            void *queuePointer = context->queues[i];
            dispatch_queue_t queue = (__bridge_transfer dispatch_queue_t)(queuePointer);
            queue = nil;
        }
        free(context->queues);
        context->queues = NULL;
    }
    free(context);
}

static dispatch_queue_t AndyDispatchContextGetQueue(AndyDispatchContext *context)
{
    uint32_t counter = (uint32_t)OSAtomicIncrement32(&context->counter);
    void *queue = context->queues[counter % context->queueCount];
    return (__bridge dispatch_queue_t)(queue);
}

static AndyDispatchContext *AndyDispatchContextGetForQOS(NSQualityOfService qos)
{
    static AndyDispatchContext *context[5] = {0};
    switch (qos) {
        case NSQualityOfServiceUserInteractive: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[0] = AndyDispatchContextCreate(count, qos);
            });
            return context[0];
        } break;
        case NSQualityOfServiceUserInitiated: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[1] = AndyDispatchContextCreate(count, qos);
            });
            return context[1];
        } break;
        case NSQualityOfServiceUtility: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[2] = AndyDispatchContextCreate(count, qos);
            });
            return context[2];
        } break;
        case NSQualityOfServiceBackground: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[3] = AndyDispatchContextCreate(count, qos);
            });
            return context[3];
        } break;
        case NSQualityOfServiceDefault:
        default: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[4] = AndyDispatchContextCreate(count, qos);
            });
            return context[4];
        } break;
    }
}

static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;

static AndyGCDQueue *mainQueue;
static AndyGCDQueue *globalQueue;
static AndyGCDQueue *highPriorityGlobalQueue;
static AndyGCDQueue *lowPriorityGlobalQueue;
static AndyGCDQueue *backgroundPriorityGlobalQueue;

@implementation AndyGCDQueue
{
    @public
    AndyDispatchContext *_dispatchContext;
}

+ (AndyGCDQueue *)mainQueue
{
    return mainQueue;
}

+ (AndyGCDQueue *)globalQueue
{
    return globalQueue;
}

+ (AndyGCDQueue *)highPriorityGlobalQueue
{
    return highPriorityGlobalQueue;
}

+ (AndyGCDQueue *)lowPriorityGlobalQueue
{
    return lowPriorityGlobalQueue;
}

+ (AndyGCDQueue *)backgroundPriorityGlobalQueue
{
    return backgroundPriorityGlobalQueue;
}

+ (void)initialize
{
    if (self == [AndyGCDQueue self])
    {
        mainQueue = [[AndyGCDQueue alloc] init];
        globalQueue = [[AndyGCDQueue alloc] init];
        highPriorityGlobalQueue = [[AndyGCDQueue alloc] init];
        lowPriorityGlobalQueue = [[AndyGCDQueue alloc] init];
        backgroundPriorityGlobalQueue = [[AndyGCDQueue alloc] init];
        
        mainQueue.dispatchQueue  = dispatch_get_main_queue();
        globalQueue.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        highPriorityGlobalQueue.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        lowPriorityGlobalQueue.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        backgroundPriorityGlobalQueue.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
}

- (instancetype)init
{
    return [self initSerial];
}

- (instancetype)initSerial
{
    self = [super init];
    
    if (self)
    {
        self.dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
        
        dispatch_queue_set_specific(self.dispatchQueue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
    }
    
    return self;
}

- (instancetype)initSerialWithLabel:(NSString *)label
{
    
    self = [super init];
    if (self)
    {
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(self.dispatchQueue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
    }
    
    return self;
}

- (instancetype)initConcurrent
{
    self = [super init];
    
    if (self)
    {
        self.dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_set_specific(self.dispatchQueue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
    }
    
    return self;
}

- (instancetype)initConcurrentWithLabel:(NSString *)label
{
    self = [super init];
    if (self)
    {
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_set_specific(self.dispatchQueue, kDispatchQueueSpecificKey, (__bridge void *)self, NULL);
    }
    return self;
}

- (instancetype)initWithContext:(AndyDispatchContext *)context
{
    self = [super init];
    if (!context) return nil;
    self->_dispatchContext = context;
    return self;
}

- (instancetype)initWithQOS:(NSQualityOfService)qos queueCount:(NSUInteger)queueCount
{
    if (queueCount == 0 || queueCount > MAX_QUEUE_COUNT) return nil;
    self = [super init];
    _dispatchContext = AndyDispatchContextCreate((uint32_t)queueCount, qos);
    if (!_dispatchContext) return nil;
    return self;
}

- (dispatch_queue_t)contextQueue
{
    return AndyDispatchContextGetQueue(_dispatchContext);
}

+ (instancetype)defaultPoolForQOS:(NSQualityOfService)qos
{
    switch (qos) {
        case NSQualityOfServiceUserInteractive: {
            static AndyGCDQueue *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[AndyGCDQueue alloc] initWithContext:AndyDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceUserInitiated: {
            static AndyGCDQueue *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[AndyGCDQueue alloc] initWithContext:AndyDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceUtility: {
            static AndyGCDQueue *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[AndyGCDQueue alloc] initWithContext:AndyDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceBackground: {
            static AndyGCDQueue *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[AndyGCDQueue alloc] initWithContext:AndyDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceDefault:
        default: {
            static AndyGCDQueue *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[AndyGCDQueue alloc] initWithContext:AndyDispatchContextGetForQOS(NSQualityOfServiceDefault)];
            });
            return pool;
        } break;
    }
}

- (void)execute:(dispatch_block_t)block
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_async(self.dispatchQueue, block);
}

- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), self.dispatchQueue, block);
}

- (void)execute:(dispatch_block_t)block afterDelaySecs:(float)delta
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta * NSEC_PER_SEC), self.dispatchQueue, block);
}

/*
 * 作为一个建议,这个方法尽量在当前线程池中调用.
 */
- (void)waitExecute:(dispatch_block_t)block
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    [self dispatchSync:block];
}

/*
 * 使用的线程池应该是你自己创建的并发线程池.如果你传进来的参数为串行线程池
 * 或者是系统的并发线程池中的某一个,这个方法就会被当做一个普通的async操作
 */
- (void)barrierExecute:(dispatch_block_t)block
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_barrier_async(self.dispatchQueue, block);
}

/*
 * 使用的线程池应该是你自己创建的并发线程池.如果你传进来的参数为串行线程池
 * 或者是系统的并发线程池中的某一个,这个方法就会被当做一个普通的sync操作
 * 作为一个建议,这个方法尽量在当前线程池中调用.
 */

- (void)waitBarrierExecute:(dispatch_block_t)block
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    [self dispatchBarrierSync:block];
}

- (void)suspend
{
    dispatch_suspend(self.dispatchQueue);
}

- (void)resume
{
    dispatch_resume(self.dispatchQueue);
}

- (void)execute:(dispatch_block_t)block inGroup:(AndyGCDGroup *)group
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    AndyGCDAssert(group != nil, @"group can not be nil");
    dispatch_group_async(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)notify:(dispatch_block_t)block inGroup:(AndyGCDGroup *)group
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    AndyGCDAssert(group != nil, @"group can not be nil");
    dispatch_group_notify(group.dispatchGroup, self.dispatchQueue, block);
}

- (void)applyExecute:(size_t)iterations block:(void (^)(size_t))block
{
     dispatch_apply(iterations, self.dispatchQueue, block);
}

- (dispatch_queue_t)dispatchQueue
{
    return _dispatchContext != nil ? [self contextQueue] : _dispatchQueue;
}

#pragma mark - 便利的构造方法
+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), mainQueue.dispatchQueue, block);
}

+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), globalQueue.dispatchQueue, block);
}

+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), highPriorityGlobalQueue.dispatchQueue, block);
}

+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), lowPriorityGlobalQueue.dispatchQueue, block);
}

+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), backgroundPriorityGlobalQueue.dispatchQueue, block);
}

+ (void)executeInMainQueue:(dispatch_block_t)block
{
    AndyGCDAssert(block != nil, @"block can not be nil");;
    dispatch_async(mainQueue.dispatchQueue, block);
}

+ (void)executeInGlobalQueue:(dispatch_block_t)block
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_async(globalQueue.dispatchQueue, block);
}

+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_async(highPriorityGlobalQueue.dispatchQueue, block);
}

+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_async(lowPriorityGlobalQueue.dispatchQueue, block);
}

+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block
{
    AndyGCDAssert(block != nil, @"block can not be nil");
    dispatch_async(backgroundPriorityGlobalQueue.dispatchQueue, block);
}

- (void)dispatchSync:(dispatch_block_t)block {
    AndyGCDQueue *currentSyncQueue = (__bridge id)dispatch_get_specific(kDispatchQueueSpecificKey);
    
    AndyGCDAssert(currentSyncQueue != self, @"dispatchSync: was called reentrantly on the same queue, which would lead to a deadlock");
    
    if (currentSyncQueue == self) {
        block();
    } else {
        dispatch_sync(self.dispatchQueue, block);
    }
}

- (void)dispatchBarrierSync:(dispatch_block_t)block {
    AndyGCDQueue *currentSyncQueue = (__bridge id)dispatch_get_specific(kDispatchQueueSpecificKey);
    
    AndyGCDAssert(currentSyncQueue != self, @"dispatchBarrierSync: was called reentrantly on the same queue, which would lead to a deadlock");
    
    if (currentSyncQueue == self) {
        block();
    } else {
        dispatch_barrier_sync(self.dispatchQueue, block);
    }
}

- (void)dealloc
{
    if (_dispatchContext)
    {
        AndyDispatchContextRelease(_dispatchContext);
        _dispatchContext = NULL;
    }
}

//- (void)dispatchAsync:(dispatch_block_t)block {
//    AndyGCDQueue *currentQueue = (__bridge id)dispatch_get_specific(kDispatchQueueSpecificKey);
//    if (currentQueue == self) {
//        block();
//    } else {
//        dispatch_async(self.dispatchQueue, block);
//    }
//}

@end
