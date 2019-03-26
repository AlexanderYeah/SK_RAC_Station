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
    
    // 0 RAC 中最为常见的类 信号类
    /*
     RACSignal：信号类
     1.通过RACSignal 创建1个信号（默认：冷信号）
     2.通过订阅者，订阅信号信号（变成:热信号）
     3.发送信号
     */

    // 创建信号
    /*
     didSubScriber调用：只要一个信号被订阅就调用！
     didSubScriber作用：利用subscriber 来发送数据！
     didSubScriber能否执行，取决于信号是否被订阅
     */
    
    
    /*
     RACDisposable：它是帮助我们取消订阅！
     什么时候需要取消订阅？
     1、信号发送完毕;
     2、信号发送失败;
     
     */
    
    // 信号的提供者 既可以发送信号 也可以取消信号
    RACSignal *sig = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"Block 被执行了");
        
        // 发送信号
        [subscriber sendNext:@"Hello From Alex"];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"只有信号被取消订阅才会走到这里");
        }];;
    }];
    
    
    // 订阅信号
    /*
     nextBlock调用：只要订阅者发送数据、信号就会被调用
     nextBlock作用：处理数据、展示UI
     nextBlock是否被调用，取决于订阅者是否发送了信号
     */

    // x 是信号发送的内容
    RACDisposable *dip =  [sig subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [dip dispose];
    
    
    
    
    // 1 利用RAC 给控件添加点击事件
    // Block 代码中的x 为控件的信息
    
    [[self.buttonA rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
        NSLog(@"self.buttonA点击了");
    }];
    
    self.lblA.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc]init];
    
    [self.lblA addGestureRecognizer:editTap];
    
    [editTap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSLog(@"%@",x);
        NSLog(@"self.lblA点击了");
    }];
    
    // 2 UITextField 代理方法
    self.nameFiled.delegate = self;
    
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@",x.first);
        NSLog(@"开始编辑了");
    }];
    
    // 3 添加通知
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillShowNotification object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"收到键盘隐藏的通知了");
    }];
    
    
    // 4 RAC 的定时器
    // 每隔5秒打印一次数据
    [[RACSignal interval:5.0f onScheduler:[RACScheduler mainThreadScheduler]]subscribeNext:^(NSDate * _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
    // 5 RAC 遍历数
    NSArray *arr = @[@"1",@"2",@"3"];
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    NSDictionary *dic = @{
                          @"key1":@"val1",
                          @"key2":@"val2",
                          @"key3":@"val3"
                          };
    [dic.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
       
        RACTwoTuple *tp = (RACTwoTuple *)x;
        // 第一个值是key 第二个值是val
        NSLog(@"%@",tp.first);
        NSLog(@"%@",tp.last);
    }];
    
    
}



@end
