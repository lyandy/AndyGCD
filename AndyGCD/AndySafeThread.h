//
//  AndySafeThread.h
//  AndyGCD_Test
//
//  Created by 李扬 on 2019/6/28.
//  Copyright © 2019 andyshare. All rights reserved.
//

#import "AndyLifeFreedomThread.h"

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(10.0))

@interface AndySafeThread : AndyLifeFreedomThread

+ (AndySafeThread *)sharedSafeThread;

- (void)stop __attribute__((unavailable(" -[AndyLifeFreedomThread stop] method can`t be called by AndySafeThread or AndySafeThread subclass")));

@end

NS_ASSUME_NONNULL_END
