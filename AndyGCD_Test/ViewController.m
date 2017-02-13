//
//  ViewController.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2017/1/3.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "ViewController.h"
#import "AndyGCD.h"

@interface ViewController ()

@property (nonatomic, strong) AndyGCDTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //main global
//   [AndyGCDQueue executeInGlobalQueue:^{
//        
//        NSLog(@"---%@", [NSThread currentThread]);
//        
//        [AndyGCDQueue executeInMainQueue:^{
//
//            NSLog(@"---%@", [NSThread currentThread]);
//        }];
//    }];

//    AndyGCDQueue *queue = [[AndyGCDQueue alloc] initSerial];

//    [queue execute:^{
//        NSLog(@"1---%@", [NSThread currentThread]);
//    }];
//    
//    [queue execute:^{
//        NSLog(@"2---%@", [NSThread currentThread]);
//    }];
//    
//    [queue execute:^{
//        NSLog(@"3---%@", [NSThread currentThread]);
//    }];
    
    
//    AndyGCDQueue *queue = [[AndyGCDQueue alloc] init];
//    AndyGCDQueue *queue1 = [[AndyGCDQueue alloc] init];
    
//    [queue waitExecute:^{
//        NSLog(@"第一个");
//        [queue waitExecute:^{
//            NSLog(@"第二个");
//        }];
//    }];
//    NSLog(@"第三个");
    
    
//    //delay
//    [AndyGCDQueue executeInGlobalQueue:^{
//        
//        NSLog(@"---%@", [NSThread currentThread]);
//        
//        [AndyGCDQueue executeInMainQueue:^{
//            
//            NSLog(@"---%@", [NSThread currentThread]);
//        } afterDelaySecs:3];
//    } afterDelaySecs:3];
//    
//    
//    //group
//    AndyGCDGroup *group = [[AndyGCDGroup alloc] init];
//    
//    [[AndyGCDQueue globalQueue] execute:^{
//        
//        NSLog(@"---%@", [NSThread currentThread]);
//    } inGroup:group];
//    
//    [[AndyGCDQueue globalQueue] execute:^{
//        
//        NSLog(@"---%@", [NSThread currentThread]);
//    } inGroup:group];
//    
//    [[AndyGCDQueue mainQueue] notify:^{
//        
//        NSLog(@"---%@", [NSThread currentThread]);
//    } inGroup:group];
//    
//    
//    //timer
//    self.timer = [[AndyGCDTimer alloc] initInQueue:[AndyGCDQueue mainQueue]];
//    
//    [self.timer timerExecute:^{
//        
//        NSLog(@"---%@", [NSThread currentThread]);
//    } timeInterval:NSEC_PER_SEC * 3 delay:NSEC_PER_SEC * 3];
//    
//    [self.timer start];
//    
//    
//    //semaphore
//    AndyGCDSemaphore *semaphore = [[AndyGCDSemaphore alloc] init];
//    
//    [AndyGCDQueue executeInGlobalQueue:^{
//        
//        NSLog(@"---%@", [NSThread currentThread]);
//        [semaphore wait];
//    }];
//    
//    [AndyGCDQueue executeInGlobalQueue:^{
//       
//        NSLog(@"---%@", [NSThread currentThread]);
//        [semaphore signal];
//    }];
//    
//    
//    //apply
//    NSString *from = @"/Users/liyang/Desktop/From";
//    NSString *to = @"/Users/liyang/Desktop/To";
//    
//    NSFileManager *mgr = [NSFileManager defaultManager];
//    NSArray *subpaths = [mgr subpathsAtPath:from];
//    [[AndyGCDQueue globalQueue] applyExecute:subpaths.count block:^(size_t index) {
//        NSString *subpath = subpaths[index];
//        NSString *fromFullpath = [from stringByAppendingPathComponent:subpath];
//        NSString *toFullpath = [to stringByAppendingPathComponent:subpath];
//        // cut
//        [mgr moveItemAtPath:fromFullpath toPath:toFullpath error:nil];
//        
//        NSLog(@"%@---%@", [NSThread currentThread], subpath);
//    }];
//
//    
//    //barrier
//    //注意 dispatch_get_global_queue(<#long identifier#>, <#unsigned long flags#>) 是不行的。即在使用barrier的时候不可以使用[AndyGCDQueue globalQueue]全局队列
//    AndyGCDQueue *concurrentQueue = [[AndyGCDQueue alloc] initConcurrent];
//    [concurrentQueue execute:^{
//        NSLog(@"----1-----%@", [NSThread currentThread]);
//    }];
//    
//    [concurrentQueue execute:^{
//        NSLog(@"----2-----%@", [NSThread currentThread]);
//    }];
//    
//    [concurrentQueue barrierExecute:^{
//        NSLog(@"----barrier-----%@", [NSThread currentThread]);
//    }];
//    
//    [concurrentQueue execute:^{
//        NSLog(@"----3-----%@", [NSThread currentThread]);
//    }];
//    
//    [concurrentQueue execute:^{
//        NSLog(@"----4-----%@", [NSThread currentThread]);
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
