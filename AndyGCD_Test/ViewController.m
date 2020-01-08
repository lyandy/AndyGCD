//
//  ViewController.m
//  AndyGCD_Test
//
//  Created by 李扬 on 2017/1/3.
//  Copyright © 2017年 andyshare. All rights reserved.
//

#import "ViewController.h"
#import "AndyGCD.h"
#import "AndySafeThread.h"
#import "AndyPeronalSafeThread.h"

@interface ViewController ()

@property (nonatomic, strong) AndyGCDTimer *timer;
@property (nonatomic, strong) AndyTaskQueue *taskQueue;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.taskQueue = [AndyTaskQueue queueWithName:@"task"];
    self.taskQueue.finishedBlock = ^{
        NSLog(@"完成-----");
    };
    self.taskQueue.canceledBlock = ^{
        NSLog(@"取消----");
    };
    
//    AndyLifeFreedomThread *lifeFreedomThread = [[AndyLifeFreedomThread alloc] init];
//    [lifeFreedomThread asyncExecuteBlock:^{
//        NSLog(@"-----%@", [NSThread currentThread]);
//    }];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [lifeFreedomThread syncExecuteBlock:^{
//            NSLog(@"block-----%@", [NSThread currentThread]);
//        }];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [lifeFreedomThread stop];
//        });
//    });
//
//    [[AndySafeThread sharedSafeThread] syncExecuteBlock:^{
//        NSLog(@"111-----%@", [NSThread currentThread]);
//        [[AndySafeThread sharedSafeThread] syncExecuteBlock:^{
//            NSLog(@"222-----%@", [NSThread currentThread]);
//            [[AndySafeThread sharedSafeThread] asyncExecuteBlock:^{
//                NSLog(@"333-----%@", [NSThread currentThread]);
//
//            }];
//            [[AndySafeThread sharedSafeThread] syncExecuteBlock:^{
//                NSLog(@"444-----%@", [NSThread currentThread]);
//
//            }];
//        }];
//    }];
    
//    for (int i = 0; i <= 10; i++) {
//        [[AndySafeThread sharedSafeThread] asyncExecuteBlock:^{
//            NSLog(@"1111====> %@", [NSThread currentThread]);
//        }];
//        
//        [[AndyPeronalSafeThread sharedSafeThread] asyncExecuteBlock:^{
//            NSLog(@"2222====> %@", [NSThread currentThread]);
//        }];
//    }
    
//    [AndyGCDQueue executeInGlobalQueue:^{
//        NSLog(@"");
//    }];
    
//    AndyGCDQueue *contextQueue = [[AndyGCDQueue alloc] initWithQOS:NSQualityOfServiceUtility queueCount:5];
//    for (int i = 0; i < 100; i++) {
//        [contextQueue execute:^{
//
//            NSLog(@"=====> %@", [NSThread currentThread]);
//        }];
//
//        [contextQueue execute:^{
//
//            NSLog(@"=====> %@", [NSThread currentThread]);
//        }];
//
//        [contextQueue execute:^{
//
//            NSLog(@"=====> %@", [NSThread currentThread]);
//        }];
//    }
//
//    AndyGCDQueue *queue = [[AndyGCDQueue alloc] initSerial];
//    [queue execute:^{
//       NSLog(@"=====> %@", [NSThread currentThread]);
//    }];
    

    
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
//
//    [queue waitExecute:^{
//        NSLog(@"第一个");
//        [queue1 waitExecute:^{
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
    //timer
//    self.timer = [[AndyGCDTimer alloc] initInQueue:[AndyGCDQueue mainQueue]];
//
//    [self.timer timerExecute:^{
//
//        NSLog(@"---%@", [NSThread currentThread]);
//    } timeInterval:NSEC_PER_SEC * 1];
//
//    [self.timer start];
//    [self.timer destroy];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self testMultiTask]; // 测试超多线程串行执行
    
//    [self testInitTaskParmas]; // 测试初始化Task传入定义参数
    
    [self testTaskInTask]; // 测试task嵌套。 如果做task嵌套，应当在 cntb 调用之前就加入嵌套的task
}

// 测试超多线程串行执行
- (void)testMultiTask
{
    for (int i = 0; i < 10; i++) {
        // error， obj 是上一个task传进来的l; cntb 是要把当前执行的结果传给下一个task
        AndyTask *task = [AndyTask taskWithBlock:^(NSError *error, id obj, callNextTaskBlock cntb) {
            if (error != nil) {
                // 一旦发生错误就取消全部task队列。应当在 cntb 调用之前cancel，并同时return
                [self.taskQueue cancel];
                return;
            }
            
            // 没有发生错误，则可选择性的使用上一个task传递给的参数 obj 做进一步处理。这里只是打印的上一个task传递过来的参数
            NSLog(@"%@----", obj);
            
            static NSInteger ticketsCount = 0;
            
            ticketsCount++;
            
            uint32_t idx = arc4random_uniform(5) + 1; // 1 ~ 5
            sleep(idx * 0.5);
            ticketsCount--;
            
            // 这里做多线程串行执行检测标
            if (ticketsCount != 0) {
                NSAssert(NO, @"队列出错");
            }
            
            NSError *err = nil;
            if (((NSNumber *)obj).integerValue == 5){
                // 模拟出错
                err = [NSError errorWithDomain:@"sdfsdf" code:101 userInfo:nil];
            }
            
            // 调用此方法，一方面是开始执行下一个task,另一方面将本task任务执行的结果传递给下一个task
            if (cntb) cntb(err, @(((NSNumber *)obj).integerValue + 1));
        }];
        
        task.canceled = ^{
            NSLog(@"task已取消-----");
        };
        
        // 如果想要初始化task的时候就传入初始参数，则可以自定义taskblock，初始化 Task的时候调用 -[AndyTask initWithParams:block:]
//        taskBlock t = ^(NSError *error, id obj, callNextTaskBlock cntb) {
//            if (error != nil) {
//                // 一旦发生错误就取消全部task队列
//                [self.taskQueue cancel];
//                return;
//            }
//
//            // 没有发生错误，则可选择性的使用上一个task传递给的参数 obj 做进一步处理。这里只是打印的上一个task传递过来的参数
//            NSLog(@"%@----", obj);
//
//            static NSInteger ticketsCount = 0;
//
//            ticketsCount++;
//
//            uint32_t idx = arc4random_uniform(5) + 1; // 1 ~ 5
//            sleep(idx * 0.5);
//            ticketsCount--;
//
//            // 这里做多线程串行执行检测标
//            if (ticketsCount != 0) {
//                NSAssert(NO, @"队列出错");
//            }
//
//            NSError *err = nil;
//            if (((NSNumber *)obj).integerValue == 5){
//                // 模拟出错
//                err = [NSError errorWithDomain:@"sdfsdf" code:101 userInfo:nil];
//            }
//
//            // 调用此方法，一方面是开始执行下一个task,另一方面将本task任务执行的结果传递给下一个task
//            if (cntb) cntb(err, @(((NSNumber *)obj).integerValue + 1));
//        };
//        AndyTask *task = [[AndyTask alloc] initWithParams:@(1) block:t];
        
        [self.taskQueue addTask:task];
    }
}

// 测试初始化Task传入定义参数
- (void)testInitTaskParmas
{
    taskBlock t1 = ^(NSError *error, id obj, callNextTaskBlock cntb) {
        static NSInteger ticketsCount = 0;
        
        ticketsCount++;
        
        uint32_t idx = arc4random_uniform(5) + 1; // 1 ~ 5
        sleep(idx * 0.5);
        ticketsCount--;
        
        if (ticketsCount != 0) {
            NSAssert(NO, @"队列出错");
        }
        
        NSLog(@"%@----", obj);
        
        if (cntb) cntb(nil, @(((NSNumber *)obj).integerValue + 1));
    };
    // 手动传参
    AndyTask *task1 = [AndyTask taskWithParams:@(1) block:t1];
    [self.taskQueue addTask:task1];
    
    taskBlock t2 = ^(NSError *error, id obj, callNextTaskBlock cntb) {
        static NSInteger ticketsCount = 0;
        
        ticketsCount++;
        
        uint32_t idx = arc4random_uniform(5) + 1; // 1 ~ 5
        sleep(idx * 0.5);
        ticketsCount--;
        
        if (ticketsCount != 0) {
            NSAssert(NO, @"队列出错");
        }
        
        NSLog(@"%@----", obj);
        
        if (cntb) cntb(nil, @(((NSNumber *)obj).integerValue + 1));
    };
    // 不传参
    AndyTask *task2 = [AndyTask taskWithBlock:t2];
    [self.taskQueue addTask:task2];
    
    taskBlock t3 = ^(NSError *error, id obj, callNextTaskBlock cntb) {
        static NSInteger ticketsCount = 0;
        
        ticketsCount++;
        
        uint32_t idx = arc4random_uniform(5) + 1; // 1 ~ 5
        sleep(idx * 0.5);
        ticketsCount--;
        
        if (ticketsCount != 0) {
            NSAssert(NO, @"队列出错");
        }
        
        NSLog(@"%@----", obj);
        
        if (cntb) cntb(nil, @(((NSNumber *)obj).integerValue + 1));
    };
    // 再次手动传参
    AndyTask *task3 = [AndyTask taskWithParams:@(200) block:t3];
    [self.taskQueue addTask:task3];
}

// 测试task嵌套
- (void)testTaskInTask
{
    taskBlock t = ^(NSError *error, id obj, callNextTaskBlock cntb) {
        static NSInteger ticketsCount = 0;
        
        ticketsCount++;
        
        uint32_t idx = arc4random_uniform(5) + 1; // 1 ~ 5
        sleep(idx * 0.5);
        ticketsCount--;
        
        if (ticketsCount != 0) {
            NSAssert(NO, @"队列出错");
        }
        
        NSLog(@"%@----", obj);
        
        NSInteger tt = 1000;

        taskBlock t1 = ^(NSError *error, id obj, callNextTaskBlock cntb) {
            static NSInteger ticketsCount = 0;
            
            ticketsCount++;
            
            uint32_t idx = arc4random_uniform(5) + 1; // 1 ~ 5
            sleep(idx * 0.5);
            ticketsCount--;
            
            if (ticketsCount != 0) {
                NSAssert(NO, @"队列出错");
            }
            
            NSLog(@"%zd----", tt);
            NSLog(@"%@----", obj);
            
            taskBlock t2 = ^(NSError *error, id obj, callNextTaskBlock cntb) {
                static NSInteger ticketsCount = 0;
                
                ticketsCount++;
                
                uint32_t idx = arc4random_uniform(5) + 1; // 1 ~ 5
                sleep(idx * 0.5);
                ticketsCount--;
                
                if (ticketsCount != 0) {
                    NSAssert(NO, @"队列出错");
                }
                
                NSLog(@"%@----", obj);
                
                if (cntb) cntb(nil, @(((NSNumber *)obj).integerValue + 1));
            };
            
            AndyTask *task2 = [[AndyTask alloc] initWithParams:@(200) block:t2];
            [self.taskQueue addTask:task2];
            
            if (cntb) cntb(nil, @(((NSNumber *)obj).integerValue + 1));
        };
        
        
        AndyTask *task1 = [[AndyTask alloc] initWithBlock:t1];
        [self.taskQueue addTask:task1];
        
        // 如果做task嵌套，应当在 cntb 调用之前就加入嵌套的task
        if (cntb) cntb(nil, @(((NSNumber *)obj).integerValue + 1));
    };
    
    AndyTask *task = [[AndyTask alloc] initWithParams:@(50) block:t];
    [self.taskQueue addTask:task];
}

- (IBAction)suspend:(UIButton *)sender {
    [self.timer suspend];
}

- (IBAction)resume:(UIButton *)sender {
    [self.timer resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
