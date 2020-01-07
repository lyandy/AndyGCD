//
//  AndySafeThread.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2019/6/28.
//  Copyright © 2019 andyshare. All rights reserved.
//

#import "AndySafeThread.h"

@implementation AndySafeThread

+ (AndySafeThread *)sharedSafeThread
{
    static AndySafeThread *thread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[AndySafeThread alloc] init];
    });
    return thread;
}

@end
