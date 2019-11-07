//
//  AndyGCDSemaphore.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2017/1/3.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyGCDSemaphore.h"
#import "AndyGCDConst.h"

@implementation AndyGCDSemaphore

- (instancetype)init
{
    return [self initWithValue:0];
}

- (instancetype)initWithValue:(long)value
{
    self = [super init];
    
    if (self)
    {
        self.dispatchSemaphore = dispatch_semaphore_create(value);
    }
    
    return self;
}

- (BOOL)signal
{
    AndyGCDAssert(self.dispatchSemaphore != nil, @"self.dispatchSemaphore can not be nil");
    return dispatch_semaphore_signal(self.dispatchSemaphore) != 0;
}

- (void)wait
{
    AndyGCDAssert(self.dispatchSemaphore != nil, @"self.dispatchSemaphore can not be nil");
    dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta
{
    AndyGCDAssert(self.dispatchSemaphore != nil, @"self.dispatchSemaphore can not be nil");
    return dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}


@end
