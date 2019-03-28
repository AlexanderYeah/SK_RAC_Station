

RAC rac_liftSelector 

主要是用于线程的同步



```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // rac_liftSelector
    // 类似于dispatch_group 中的组
    // 多线程中的组 等所有的请求都完毕之后 去更新UI
    
    RACSignal *sg1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"网络请求数据1"];
        return nil;
    }];
    
    RACSignal *sg2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"网络请求数据2"];
        return nil;
    }];
    
    RACSignal *sg3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"网络请求数据3"];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUI:str:str:) withSignals:sg1,sg2,sg3, nil];
    
}

- (void)updateUI:(id)str1 str:(id)str2 str:(id)str3
{
    
    // 回传过来
    NSLog(@"%@-%@-%@",str1,str2,str3);
    
}

```

