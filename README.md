# AndyGCD
AndyGCD aimed to make OC native GCD easier and simpler to use. Include dispatchQueue、delay、group、timer、semaphore、apply、barrier

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
    } afterDelaySecs:NSEC_PER_SEC * 3];
} afterDelaySecs:NSEC_PER_SEC * 3];

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

NSFileManager *mgr = [NSFileManager defaultManager];  NSArray *subpaths = [mgr subpathsAtPath:from];
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

_* 注意 ```dispatch_get_global_queue(<#long identifier#>, <#unsigned long flags#>)```是不行的。即在使用barrier的时候不可以使用[AndyGCDQueue globalQueue]全局队列 *_


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
