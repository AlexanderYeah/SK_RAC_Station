

# RACMulticastConnection

信号被多次订阅

如果一个信号多次被订阅，那么代码块代码会多次被执行。

```objective-c
    // 创建信号
    RACSignal *sg1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"网络请求");
        [subscriber sendNext:@"发送数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // 订阅信号三次 则会进行网络请求三次
    [sg1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [sg1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [sg1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
```



解决此问题的方案就是RACMulticastConnection，避免一个信号被多次订阅的时候，可以避免多次调用创建信号中的Block

```objective-c
   RACSignal *sg2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"网络请求");
        [subscriber sendNext:@"发送数据"];
        return nil;
    }];
    
    
    RACMulticastConnection *con1 = [sg2 publish];
    
    // 虽然信号被订阅多次 但是网络请求只走一次
    [con1.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [con1.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [con1.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    // 必须调用此方法
    [con1 connect];
    

```

