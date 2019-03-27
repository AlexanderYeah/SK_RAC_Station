### Map



map 用于自定义信号

* RACSubject，既能发送信号，又能订阅信号

* 多用于代理，相当于OC里的delegate或者回调block

```objective-c

- (void)mapDemo
{
    // 0  创建信号提供者
    // RACSubject，既能发送信号，又能订阅信号
    // 多用于代理，相当于OC里的delegate或者回调block
    RACSubject *subject = [RACSubject subject];
    // 1 绑定信号
    RACSignal *bindSignal = [subject map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"这是我自定义的信号"];
    }];
    // 2 订阅绑定信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    // 3 发送信号
    [subject sendNext:@"HelloThere"];
    
}

// 界面跳转回传值
- (IBAction)btnClick:(id)sender {
    
    FirstVC *vc = [[FirstVC alloc]init];
    vc.subject = [RACSubject subject];
    // 第二个控制器订阅信号 可以用于接收返回信息
    [vc.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

```

