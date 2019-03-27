//
//  ViewController.m
//  SK_RAC01
//
//  Created by coder on 2019/3/26.
//  Copyright © 2019 AlexanderYeah. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import "FirstVC.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonA;
@property (weak, nonatomic) IBOutlet UILabel *lblA;

@property (weak, nonatomic) IBOutlet UITextField *nameFiled;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RACSubject *sb = [RACSubject subject];
    
    // flattenMap作用：把原信号的内容映射成一个新信号，并return返回给一个RACStream类型数据。实际上是根据前一个信号传递进来的参数重新建立了一个信号，这个参数，可能会在创建信号的时候用到，也有可能用不到。
    RACSignal *sig = [sb flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        NSString *didValue = [NSString stringWithFormat:@"key:%@", value];
        return nil;
    }];
    //订阅信号
    [sig subscribeNext:^(id _Nullable x) {
        NSLog(@"订阅绑定数据：%@", x);
    }];
    
}


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
 







@end
