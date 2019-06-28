//
//  AndyLifeFreedomThread.h
//  AndyGCD_Test
//
//  Created by 李扬 on 2019/6/28.
//  Copyright © 2019 andyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AndyLifeFreedomThread : NSObject

- (void)syncExecuteBlock:(void (^)(void))blocker;

- (void)asyncExecuteBlock:(void (^)(void))blocker;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
