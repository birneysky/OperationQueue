//
//  TestEngine.m
//  OperationQueue
//
//  Created by zhangguang on 16/10/11.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import "TestEngine.h"
#import <UIKit/UIKit.h>

static NSOperationQueue *_sharedNetworkQueue;


@interface TestEngine ()

@property (copy, nonatomic) NSString *hostName;

@end


@implementation TestEngine


+(void) initialize {
    
    if(!_sharedNetworkQueue) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _sharedNetworkQueue = [[NSOperationQueue alloc] init];
            [_sharedNetworkQueue addObserver:[self self] forKeyPath:@"operationCount" options:0 context:NULL];
            [_sharedNetworkQueue setMaxConcurrentOperationCount:4];
            
        });
    }
}

+(void)dealloc{
    
}

+ (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == _sharedNetworkQueue && [keyPath isEqualToString:@"operationCount"]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible =
        ([_sharedNetworkQueue.operations count] > 0);
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
    
    if(_sharedNetworkQueue.operations.count ==0){
        NSLog(@"All operations performed.");
    }
}




- (void)enqueueOperation:(TestOperation*)operation;
{
    [_sharedNetworkQueue addOperation:operation];
}

@end
