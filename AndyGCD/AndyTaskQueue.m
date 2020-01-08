//
//  AndyTaskQueue.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2019/7/9.
//  Copyright © 2019 李扬. All rights reserved.
//

#import "AndyTaskQueue.h"
#import "AndyTask.h"

@interface AndyTask ()

@property (nonatomic, strong) id obj;

- (void)doTaskWithError:(NSError *)error params:(id)obj callNextTask:(callNextTaskBlock)cntb;

@end

@interface AndyTaskQueue ()
{
    BOOL _executing;
}

@property (nonatomic, strong) NSMutableArray<__kindof AndyTask *> *tasksArrM;

@end

static const void * const kDispatchQueueSpecificKey = &kDispatchQueueSpecificKey;

@implementation AndyTaskQueue
{
    dispatch_queue_t _queue;
}

+ (instancetype)queueWithName:(NSString *)name
{
    return [[self alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"AndyTaskQueue.%@", name] UTF8String], NULL);
        dispatch_queue_set_specific(_queue, kDispatchQueueSpecificKey, (__bridge void *)(self), NULL);
        _tasksArrM = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithName:@"anonymous"];
}

- (void)addTask:(AndyTask *)task
{
    NSAssert(task != nil, @"task can not be nil");
    if (task != nil)
    {
        @synchronized (self) {
            [self.tasksArrM addObject:task];
            task.status = TaskStatusInQueue;
        }
        
        [self queueDoTaskWithError:nil params:task.obj];
    }
}

- (void)queueDoTaskWithError:(NSError *)error params:(id)obj
{
    AndyTask *task = nil;
    @synchronized (self) {
        if (_executing) {
            return;
        }
        task = [self.tasksArrM firstObject];
        _executing = task != nil;
        if (task == nil) {
            NSLog(@"完成");
            if (self.finishedBlock) self.finishedBlock();
        }
    }
    
    task.status = TaskStatusExecuting;
    AndyTaskQueue *currentQueue = (__bridge AndyTaskQueue *)(dispatch_get_specific(kDispatchQueueSpecificKey));
    
    __weak typeof(self) weakSelf = self;
    
    if (currentQueue == self)
    {
        [task doTaskWithError:error params:task.obj?:obj callNextTask:^(NSError *err, id result) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            @synchronized (strongSelf) {
                task.status = TaskStatusFinished;
                [strongSelf.tasksArrM removeObject:task];
                strongSelf->_executing = NO;
            }
            dispatch_async(strongSelf->_queue, ^{
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                [strongSelf queueDoTaskWithError:err params:result];
            });
        }];
    }
    else
    {
        dispatch_async(_queue, ^{
            [task doTaskWithError:error params:task.obj?:obj callNextTask:^(NSError *err, id result) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                @synchronized (strongSelf) {
                    task.status = TaskStatusFinished;
                    [strongSelf.tasksArrM removeObject:task];
                    strongSelf->_executing = NO;
                }
                [strongSelf queueDoTaskWithError:err params:result];
            }];
        });
    }
}

- (void)cancel
{
    @synchronized (self) {
        [self.tasksArrM enumerateObjectsUsingBlock:^(__kindof AndyTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.status = TaskStatusCanceled;
            if (obj.canceled) obj.canceled();
        }];
        
        [self.tasksArrM removeAllObjects];
        if (self.canceledBlock) self.canceledBlock();
        self->_executing = NO;
    }
}

@end
