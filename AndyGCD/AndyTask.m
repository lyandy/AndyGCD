//
//  AndyTask.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2019/7/9.
//  Copyright © 2019 李扬. All rights reserved.
//

#import "AndyTask.h"

@interface AndyTask ()

@property (nonatomic, copy) taskBlock block;
@property (nonatomic, strong) id obj;

@end

@implementation AndyTask

+ (instancetype)taskWithBlock:(taskBlock)t
{
    return [self taskWithParams:nil block:t];
}

- (instancetype)initWithBlock:(taskBlock)t
{
    return [self initWithParams:nil block:t];
}

+ (instancetype)taskWithParams:(id)obj block:(taskBlock)t
{
    return [[self alloc] initWithParams:obj block:t];
}

- (instancetype)initWithParams:(id)obj block:(taskBlock)t
{
    self = [super init];
    if (self)
    {
        self.block = t;
        self.obj = obj;
    }
    return self;
}

- (void)doTaskWithError:(NSError *)error params:(id)obj callNextTask:(callNextTaskBlock)cntb
{
    if (self.block)
    {
        self.block(error, obj, cntb);
    }
}


@end
