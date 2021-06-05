//
//  TimerProxy.m
//  RetainCycleDemo
//
//  Created by Tian on 2021/6/5.
//

#import "TimerProxy.h"

@interface TimerProxy()

@property (nonatomic, weak) id object;

@end

@implementation TimerProxy

+ (instancetype)proxyWithTransformObject:(id)object{
    TimerProxy *proxy = [TimerProxy alloc];
    proxy.object = object;
    return proxy;
}

// 仅仅添加了weak类型的属性还不够，为了保证中间件能够响应外部self的事件，
// 需要通过消息转发机制，让实际的响应target还是外部self，这一步至关重要，主要涉及到runtime的消息机制。
// 强引用 -> 消息转发
-(id)forwardingTargetForSelector:(SEL)aSelector {
    return self.object;
}
@end
