

RAC 集合 RACTuple  RACSequence

```objective-c
   // 0 RACTuple 就是一个数组
    /*
     RACTuple 就是一个数组
     */
    
    RACTuple *tp1 = [RACTuple tupleWithObjects:@"5",@5,@1, nil];
    RACTuple *tp2 = [RACTuple tupleWithObjectsFromArray:@[@"11",@"22",@"33"]];
    
    NSLog(@"%@",tp1.second);
    NSLog(@"%@",tp2.second);
    
    
    //2  RACSequence 用来快速遍历和字典转模型
    
    NSArray *arr1 = @[@"11",@"22",@"33",@"44",@"55",@"66"];
    NSDictionary *dic1 = @{@"key1":@"val1",@"key2":@"val2"};
    RACSequence *seq = arr1.rac_sequence;
    
    // 进行快速数组遍历
    RACSignal *sg1 = seq.signal;
    
    [sg1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    // 快速遍历字典
    [dic1.rac_sequence.signal subscribeNext:^(RACTuple* x) {
        NSLog(@"%@--%@",x.first,x.last);
    }];
```

