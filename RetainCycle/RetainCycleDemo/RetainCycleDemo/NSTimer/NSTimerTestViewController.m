//
//  NSTimerTestViewController.m
//  RetainCycleDemo
//
//  Created by Tian on 2021/6/5.
//

#import "NSTimerTestViewController.h"
#import "TimerProxy.h"

@interface NSTimerTestViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) TimerProxy *proxy;

@end

@implementation NSTimerTestViewController

static NSInteger cnt = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // weakSelf 无法打破
    // __weak typeof(self) weakSelf = self;
    // self.timer = [NSTimer timerWithTimeInterval:1
    //                                      target:weakSelf
    //                                    selector:@selector(fireAction)
    //                                    userInfo:nil
    //                                     repeats:YES];
    // [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSDefaultRunLoopMode];
    // // [self.timer fire]; 只走一次
    
    // proxy 虚基类的方式
    self.proxy = [TimerProxy proxyWithTransformObject:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.proxy selector:@selector(fireAction) userInfo:nil repeats:YES];
}

- (void)fireAction {
    NSLog(@"====== %ld", cnt++);
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"====== %s", __func__);
}

@end
