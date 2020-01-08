//
//  AndyTaskQueue.h
//  AndyGCD_Test
//
//  Created by 李扬 on 2019/7/9.
//  Copyright © 2019 李扬. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^queueFinishedBlock)(void);
typedef void (^queueCanceldBlock)(void);

@class AndyTask;

@interface AndyTaskQueue : NSObject

+ (instancetype)queueWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name;

- (void)addTask:(AndyTask *)task;
- (void)cancel;

@property (nonatomic, copy) queueFinishedBlock finishedBlock;
@property (nonatomic, copy) queueCanceldBlock canceledBlock;

@end
