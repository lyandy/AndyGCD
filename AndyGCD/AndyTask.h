//
//  AndyTask.h
//  AndyGCD_Test
//
//  Created by 李扬 on 2019/7/9.
//  Copyright © 2019 李扬. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^callNextTaskBlock)(NSError * error, id result);
typedef void (^taskBlock)(NSError * error, id obj, callNextTaskBlock cntb);

typedef NS_ENUM(NSUInteger, TaskStatus) {
    TaskStatusInQueue,
    TaskStatusExecuting,
    TaskStatusFinished,
    TaskStatusCanceled,
};

@interface AndyTask : NSObject

@property (nonatomic, assign) TaskStatus status;
@property (nonatomic, copy) void(^canceled)(void);

+ (instancetype)taskWithBlock:(taskBlock)t;
- (instancetype)initWithBlock:(taskBlock)t;

+ (instancetype)taskWithParams:(id)obj block:(taskBlock)t;
- (instancetype)initWithParams:(id)obj block:(taskBlock)t;

@end
