//
//  AndyLifeFreedomThread.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2019/6/28.
//  Copyright © 2019 andyshare. All rights reserved.
//

#import "AndyLifeFreedomThread.h"

@interface AndyThread : NSThread
@end

@implementation AndyThread

- (void)dealloc
{
//    NSLog(@"%s", __func__);
}

@end

@interface AndyLifeFreedomThread ()

@property (nonatomic, strong) AndyThread *innerThread;

@end

@implementation AndyLifeFreedomThread

- (instancetype)init
{
    if (self = [super init]) {
        self.innerThread = [[AndyThread alloc] initWithBlock:^{
            // 创建上下文（要初始化一下结构体）
            CFRunLoopSourceContext context = {0};
            
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            
            // 往Runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            
            // 销毁source
            CFRelease(source);
            
            // 启动
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
        }];
        
        [self.innerThread start];
    }
    return self;
}

- (void)syncExecuteBlock:(void (^)(void))blocker
{
    if (blocker)
    {
        if ([NSThread currentThread] == self.innerThread)
        {
            blocker();
        }
        else
        {
            [self performSelector:@selector(syncExecuteBlock:) onThread:self.innerThread withObject:blocker waitUntilDone:YES];
        }
    }
}

- (void)asyncExecuteBlock:(void (^)(void))blocker
{
    [self performSelector:@selector(syncExecuteBlock:) onThread:self.innerThread withObject:blocker waitUntilDone:NO];
}

- (void)stop
{
    if (self.innerThread == nil) return;
    
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

#pragma mark - private methods
- (void)__stop
{
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)dealloc
{
    [self stop];
}

@end
