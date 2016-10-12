//
//  TestOperation.m
//  OperationQueue
//
//  Created by zhangguang on 16/10/11.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import "TestOperation.h"


@interface TestOperation ()

@property (nonatomic,copy) NSString* identity;

@end

@implementation TestOperation
{
    BOOL _executing;  // 执行中
    BOOL _finished;   // 已完成
}


- (instancetype)initWithIdentity:(NSString*)identity
{
    if (self = [super init]) {
        _executing = YES;
        self.identity = identity;
    }
    return self;
}


- (void)start{
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [self main];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main{
    NSLog(@"main begin  %@",self.identity);
    @try {
        // 提供一个变量标识，来表示需要执行的操作是否完成了，当然，没开始执行之前，为NO
        BOOL taskIsFinished = NO;
        // while 保证：只有当没有执行完成和没有被取消，才执行自定义的相应操作
        while (taskIsFinished == NO && [self isCancelled] == NO){
            // 自定义的操作
            sleep(10);  // 睡眠模拟耗时操作
            NSLog(@"currentThread = %@", [NSThread currentThread]);
            NSLog(@"identity      = %@", self.identity);
            // 这里相应的操作都已经完成，后面就是要通知KVO我们的操作完成了。
            taskIsFinished = YES;
        }
        
        [self completeOperation];
    }
    @catch (NSException * e) {
        NSLog(@"Exception %@", e);
    }
    NSLog(@"main end %@",self.identity);
}


- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}





@end
