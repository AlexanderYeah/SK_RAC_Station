

## RACommand



### RACCommand 就是命令

```objective-c
    
    // RACCommand 就是命令
    // 0 创建一个CMD 穿进去一个用于构建RACSignal的Block参数来初始化RACommand
    RACCommand *cmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        // 此处是cmd 执行的输入源
        NSLog(@"%@",input);
        // 创建一个信号 并且发送信号
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"HelloFromCommand"];
            return nil;
        }];
    }];
	
    // 获取信号的发送者 监听信号
    [cmd.executionSignals subscribeNext:^(id  _Nullable x) {
        
        // 此处返回的是信号
        // <RACDynamicSignal: 0x600003963920> name:
        NSLog(@"%@",x);
        [x subscribeNext:^(id  _Nullable x) {
            // 此处打印的是信号发送的信息 HelloFromCommand
            NSLog(@"%@",x);
        }];
        
    }];
    
    // cmd 执行execute 方法 才会调用
    [cmd execute:@"555555"];

```

```objective-c

    // 用户名和密码长度大于6之后才能登陆
    // 下面两行代码是实时监听输入框的长度 去改变登录按钮的颜色
 
    [self.nameFiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
        self.username = x;
        self.loginBtn.backgroundColor = [UIColor grayColor];
        if (self.username.length > 6 && self.password.length > 6 ) {
            self.loginBtn.backgroundColor = [UIColor redColor];
        }

    }];
    
    [self.passwordField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
        self.password = x;
        self.loginBtn.backgroundColor = [UIColor grayColor];
        if (self.username.length > 6 && self.password.length > 6 ) {
            self.loginBtn.backgroundColor = [UIColor redColor];
        }
        
    }];
    
    
    
    
    
    
    // 观察self.nameFiled.text
    // 用户名的信号
   RACSignal *usernameSignal = [RACObserve(self.nameFiled, text) map:^id _Nullable(NSString  * value) {
        if (value.length > 6 ) {
 
            return  @(YES);
        }else{
 
            return @(NO);
        }
    }];
    
    // 密码的信号
    RACSignal *passwordSignal = [RACObserve(self.passwordField, text) map:^id _Nullable(  NSString * value) {
        if (value.length > 6 ) {
            
            return @(YES);
            
        }else{
 
            return @(NO);
        }
    }];
    
    

    //信号的合并
    // combineLatest 是将数组中的信号合并成一个信号 只有当两个信号都成功发送的时候后面的代码才会执行
    // reduce 聚合：用于信号发出的内容时元组，把信号发出元组的值聚合成一个值

    RACSignal *loginSig = [RACSignal combineLatest:@[usernameSignal,passwordSignal] reduce:^id (NSNumber *username,NSNumber *pwd){
        // 返回的是0 或者 1
        // 只有都符合条件的话 信号才会发出去
        
        return @([username boolValue] && [pwd boolValue]);
    }];
    
    
    // 实例化command
    _loginCommand = [[RACCommand alloc]initWithEnabled:loginSig signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        // 登录的操作
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:[NSString stringWithFormat:@"%@--%@",self.nameFiled.text,self.passwordField.text]];
            [subscriber sendCompleted];
            return nil;
        }];
        return nil;
    }];
    
    
    
    // 订阅信号
    [[self.loginCommand executionSignals]subscribeNext:^(RACSignal  * x) {
        
        [x subscribeNext:^(NSString * x) {
            //
            NSLog(@"x--%@",x);
        }];
    }];
    
    
    
    // 绑定按钮的command 事件
    
    self.loginBtn.rac_command = self.loginCommand;
```

