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
    
    [self map];
    
}



/**
 flattenMap 对传递过来的信号进行二次定义
 也可以多次定义
 */

- (void)flattenMap
{
    
    RACSignal *sg1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"1"];
        return nil;
    }];
    
    // 对传递过来的信号进行二次定义
    RACSignal *flSig = [sg1 flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
         return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:[NSString stringWithFormat:@"flattenMap-%@",value]];
            return nil;
        }];
     
    }];
    
    
    [flSig subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    
}




/**
    信号的延迟订阅
 */

- (void)delay
{
    RACSignal *sig1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"5s之后打印"];
        [subscriber sendCompleted];
        return nil;
    }];
    // 延迟5秒订阅信号
    [[sig1 delay:5]subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
}




/**
    信号的过滤
*/

- (void)filter
{
    RACSignal *sig = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 发送多个文本
        [subscriber sendNext:@"100"];
        [subscriber sendNext:@"200"];
        [subscriber sendNext:@"300"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    
    [[sig filter:^BOOL(NSString * value) {
        // 可以进行过滤
        if (value.integerValue > 200) {
            return  value;
        }
        return nil;
    }] subscribeNext:^(id  _Nullable x) {
        // 只会打印出300
        NSLog(@"%@",x);
    }];
    
    
}


/**
    压缩信号订阅之后再次进行解压
*/

- (void)zip
{
    
    RACSignal *sg1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext: @"Fromsg1"];
            [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *sg2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext: @"Fromsg2"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // 信号订阅
    [[sg1 zipWith:sg2]subscribeNext:^(id  _Nullable x) {
        
        // 解压缩
        RACTupleUnpack(NSString *str1,NSString *str2) = x;
        NSLog(@"%@---%@",str1,str2);
        
    }];
    
}




/**
    数组中的信号被打包成一个信号
    被打包的信号都要完成信号的发送信号才可以被订阅
    都能正常被订阅接收信号
 */

- (void)combineLatest
{
    // 因为信号sg1 没有完成发送 所以信号不能被订阅
    RACSignal *sg1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        [subscriber sendNext: @"Fromsg1"];
//        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *sg2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext: @"Fromsg2"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *combineSig = [RACSignal combineLatest:@[sg1,sg2]];
    // 订阅信号
    [combineSig subscribeNext:^(id  _Nullable x) {
        //  打印的是 RACTuple
        NSLog(@"%@",x);
    }];
    
}

/**
 // 数组中的信号被打包成一个信号 只要数组中的信号任何一个完成信号的发送
 // 都能正常被订阅接收信号
 */
- (void)merge
{
    RACSignal *sg1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        [subscriber sendNext: @"Fromsg1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    
    RACSignal *sg2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext: @"Fromsg2"];
        [subscriber sendCompleted];
        return nil;
    }];
    

    RACSignal *mergeSig = [RACSignal merge:@[sg1,sg2]];
    
    // 订阅信号
    [mergeSig subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
}





/**
  信号的串联
  把控代码的执行顺序 如下面的例子 顺序下载图片
 
 */
- (void)concat
{
    
    
    RACSignal *sg1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        // 线程是阻塞的
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://qzonestyle.gtimg.cn/qzone/app/weishi/client/testimage/1024/36.jpg"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                [subscriber sendNext:@"Hellosg1"];
                [subscriber sendCompleted];
                NSLog(@"sg1");
                
            }
        }];
        
        [task resume];
        

        return nil;
    }];
    
    RACSignal *sg2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
     
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://qzonestyle.gtimg.cn/qzone/app/weishi/client/testimage/1024/56.jpg"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                
                
                [subscriber sendNext:@"Hellosg2"];
                [subscriber sendCompleted];
                NSLog(@"sg2");
            }
        }];
        
        [task resume];
        
        return nil;
    }];
    
    RACSignal *conSig = [sg1 concat: sg2];
    
    // 订阅信号
    [conSig subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
}

- (void)map
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
