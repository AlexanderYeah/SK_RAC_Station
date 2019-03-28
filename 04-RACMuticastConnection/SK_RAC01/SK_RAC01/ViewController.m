//
//  ViewController.m
//  SK_RAC01
//
//  Created by coder on 2019/3/26.
//  Copyright © 2019 AlexanderYeah. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buttonA;
@property (weak, nonatomic) IBOutlet UILabel *lblA;

@property (weak, nonatomic) IBOutlet UITextField *nameFiled;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self demo2];
    
}


- (void)demo2
{
    
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
    

    
    
    
    
}


-(void)demo1{
    
    
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
    
}



@end
