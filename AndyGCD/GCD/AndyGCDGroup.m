//
//  AndyGCDGroup.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2017/1/3.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "AndyGCDGroup.h"

@implementation AndyGCDGroup

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.dispatchGroup = dispatch_group_create();
    }
    
    return self;
}

- (void)enter
{
    dispatch_group_enter(self.dispatchGroup);
}

- (void)leave
{
    dispatch_group_leave(self.dispatchGroup);
}

- (void)wait
{
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta
{
    return dispatch_group_wait(self.dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}


@end
