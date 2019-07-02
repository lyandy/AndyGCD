# AndyGCD
AndyGCD aimed to make C GCD easier and simpler to use. Include dispatchQueue、delay、group、timer、semaphore、apply、barrier.

__Use in pod:__  ```pod 'AndyGCD'```

---

### dispatchQueue

```
[AndyGCDQueue executeInGlobalQueue:^{

    NSLog(@"---%@", [NSThread currentThread]);

    [AndyGCDQueue executeInMainQueue:^{

        NSLog(@"---%@", [NSThread currentThread]);
    }];
}];

```


---

### delay

```

[AndyGCDQueue executeInGlobalQueue:^{

    NSLog(@"---%@", [NSThread currentThread]);

    [AndyGCDQueue executeInMainQueue:^{

        NSLog(@"---%@", [NSThread currentThread]);
    } afterDelaySecs:3];
} afterDelaySecs:3];

```

---

### group

```

AndyGCDGroup *group = [[AndyGCDGroup alloc] init];

[[AndyGCDQueue globalQueue] execute:^{

    NSLog(@"---%@", [NSThread currentThread]);
} inGroup:group];

[[AndyGCDQueue globalQueue] execute:^{

    NSLog(@"---%@", [NSThread currentThread]);
} inGroup:group];

[[AndyGCDQueue mainQueue] notify:^{

    NSLog(@"---%@", [NSThread currentThread]);
} inGroup:group];

```

---

### timer

```

self.timer = [[AndyGCDTimer alloc] initInQueue:[AndyGCDQueue mainQueue]];

[self.timer timerExecute:^{

    NSLog(@"---%@", [NSThread currentThread]);
} timeInterval:NSEC_PER_SEC * 3 delay:NSEC_PER_SEC * 3];

[self.timer start];


```

---

### semaphore

```

AndyGCDSemaphore *semaphore = [[AndyGCDSemaphore alloc] init];

[AndyGCDQueue executeInGlobalQueue:^{

    NSLog(@"---%@", [NSThread currentThread]);
    [semaphore wait];
}];

[AndyGCDQueue executeInGlobalQueue:^{

    NSLog(@"---%@", [NSThread currentThread]);
    [semaphore signal];
}];

```

---

### apply

```

NSString *from = @"/Users/liyang/Desktop/From";
NSString *to = @"/Users/liyang/Desktop/To";

NSFileManager *mgr = [NSFileManager defaultManager];
NSArray *subpaths = [mgr subpathsAtPath:from];

[[AndyGCDQueue globalQueue] applyExecute:subpaths.count block:^(size_t index) {
    NSString *subpath = subpaths[index];
    NSString *fromFullpath = [from stringByAppendingPathComponent:subpath];
    NSString *toFullpath = [to stringByAppendingPathComponent:subpath];
    // cut
    [mgr moveItemAtPath:fromFullpath toPath:toFullpath error:nil];

    NSLog(@"%@---%@", [NSThread currentThread], subpath);
}];

```

---

### barrier

_注意使用全局并发队列 ```dispatch_get_global_queue(<#long identifier#>, <#unsigned long flags#>)```是不行的，即不可以使用```[AndyGCDQueue globalQueue]```全局队列, 效果等同于 dispatch_async. 只能使用自己创建的 ```dispatch_async_create``` 并队列，即 ```[[AndyGCDQueue alloc] initConcurrent]```_


```

AndyGCDQueue *concurrentQueue = [[AndyGCDQueue alloc] initConcurrent];
[concurrentQueue execute:^{
    NSLog(@"----1-----%@", [NSThread currentThread]);
}];

[concurrentQueue execute:^{
    NSLog(@"----2-----%@", [NSThread currentThread]);
}];

[concurrentQueue barrierExecute:^{
    NSLog(@"----barrier-----%@", [NSThread currentThread]);
}];

[concurrentQueue execute:^{
    NSLog(@"----3-----%@", [NSThread currentThread]);
}];

[concurrentQueue execute:^{
    NSLog(@"----4-----%@", [NSThread currentThread]);
}];

```

---

### QOS DispatchContextQueue

```
AndyGCDQueue *contextQueue = [[AndyGCDQueue alloc] initWithQOS:NSQualityOfServiceUtility queueCount:5];
for (int i = 0; i < 100; i++) {
    [contextQueue execute:^{

        NSLog(@"=====> %@", [NSThread currentThread]);
    }];

    [contextQueue execute:^{

        NSLog(@"=====> %@", [NSThread currentThread]);
    }];

    [contextQueue execute:^{

        NSLog(@"=====> %@", [NSThread currentThread]);
    }];
}

```

---

### AndyLifeFreedomThread

```
AndyLifeFreedomThread *lifeFreedomThread = [[AndyLifeFreedomThread alloc] init];
    [lifeFreedomThread asyncExecuteBlock:^{
        NSLog(@"-----%@", [NSThread currentThread]);
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [lifeFreedomThread syncExecuteBlock:^{
            NSLog(@"block-----%@", [NSThread currentThread]);
        }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [lifeFreedomThread stop];
        });
    });

```

---

### AndySafeThread

```
[[AndySafeThread sharedSafeThread] syncExecuteBlock:^{
        NSLog(@"111-----%@", [NSThread currentThread]);
        [[AndySafeThread sharedSafeThread] syncExecuteBlock:^{
            NSLog(@"222-----%@", [NSThread currentThread]);
            [[AndySafeThread sharedSafeThread] asyncExecuteBlock:^{
                NSLog(@"333-----%@", [NSThread currentThread]);

            }];
            [[AndySafeThread sharedSafeThread] syncExecuteBlock:^{
                NSLog(@"444-----%@", [NSThread currentThread]);

            }];
        }];
    }];

```

---
