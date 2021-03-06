//
//  TestOperation.m
//  OperationQueue
//
//  Created by zhangguang on 16/10/11.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import "TENetworkOperation.h"
#import <objc/message.h>

typedef NS_ENUM(NSInteger, TENetworkOperationState) {
    TENetworkOperationStateReady = 1,
    TENetworkOperationStateExecuting = 2,
    TENetworkOperationStateFinished = 3
};


@interface TENetworkOperation ()

@property (nonatomic,copy) NSDictionary* responseData;

@property (nonatomic,assign) TENetworkOperationState state;

@property (nonatomic,weak) id target;

@property (nonatomic,assign) SEL executionSelector;

@property (nonatomic,copy) TENKCompletedBlock completedBlock;

@property (nonatomic,copy) TENKErrorBlock errorBlock;

@end

@implementation TENetworkOperation
{
    BOOL _executing;  // 执行中
    BOOL _finished;   // 已完成
    BOOL _canceled; //已取消
}

- (void)dealloc{
    static long count = 0;
    NSLog(@"♻️♻️♻️♻️ TENetworkOperation ~ %@ %ld",self,count++);
}

- (void)setTarget:(id)target executionSelector:(SEL)selector
{
    self.target = target;
    self.executionSelector = selector;
}


-(void) setCompletionHandler:(TENKCompletedBlock) completion errorHandler:(TENKErrorBlock) error
{
    self.completedBlock = completion;
    self.errorBlock = error;
}

- (void) operationFailedWithError:(NSError*) error
{
    if (self.errorBlock) {
        self.errorBlock(error);
    }
    [self completeOperation];
}

- (void)operationSucceeded:(NSDictionary*)data
{
    self.responseData = data;
    if (self.completedBlock) {
        self.completedBlock(self);
    }
    [self completeOperation];
}

#pragma mark - *** Override ***


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
    
    @try {
        
        BOOL taskIsFinished = NO;
        
        while (taskIsFinished == NO && [self isCancelled] == NO){
            
//            if([self.target respondsToSelector:self.executionSelector]){
//                NSData* data = self.postedPacket.data;
//                objc_msgSend(self.target,self.executionSelector,data);
//            }
            
            if (self.excuteBlock) {
                self.excuteBlock();
            }
            
            taskIsFinished = YES;
        }
        
        if ([self isCancelled]) {
            [self operationFailedWithError:nil];
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception %@", e);
    }
    
}


- (void)completeOperation {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
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

- (BOOL)isCancelled{
    return _canceled;
}

- (void)cancel{
    [self willChangeValueForKey:@"isCancelled"];
    _canceled = NO;
    [self didChangeValueForKey:@"isCancelled"];
    [super cancel];
}

@end
