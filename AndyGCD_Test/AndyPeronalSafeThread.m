//
//  AndyPeronalSafeThread.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2020/1/7.
//  Copyright © 2020 andyshare. All rights reserved.
//

#import "AndyPeronalSafeThread.h"

@implementation AndyPeronalSafeThread

+ (AndyPeronalSafeThread *)sharedSafeThread
{
    static AndyPeronalSafeThread *thread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[AndyPeronalSafeThread alloc] init];
    });
    return thread;
}

@end
