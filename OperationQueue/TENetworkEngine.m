//
//  TestEngine.m
//  OperationQueue
//
//  Created by zhangguang on 16/10/11.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import "TENetworkEngine.h"
#import <UIKit/UIKit.h>
#import <CocoaAsyncSocket/CocoaAsyncSocket.h>


static NSOperationQueue *_sharedNetworkQueue;


@interface TENetworkEngine ()  <GCDAsyncSocketDelegate>

@property (nonatomic,copy) NSString* hostName;

@property (nonatomic,assign) uint16_t port;

@property (nonatomic,strong)  GCDAsyncSocket* asyncSocket;


@end


@implementation TENetworkEngine

#pragma mark - *** Static ***
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

#pragma mark - *** Properties ***
- (GCDAsyncSocket*) asyncSocket
{
    if (!_asyncSocket) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return _asyncSocket;
}


#pragma mark - *** Api ***
- (instancetype) initWithHostName:(NSString*)name port:(uint16_t)port
{
    if (self = [super init]) {
        self.hostName = name;
        self.port = port;
    }
    return self;
}



- (void)enqueueOperation:(TENetworkOperation*)operation;
{
    [_sharedNetworkQueue addOperation:operation];
}


#pragma mark - *** GCDAsyncSocketDelegate ***

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"Connect to server successfully %@:%d",host,port);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"didReadData  %@,length %ld",data,(long)data.length);
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didWritePartialDataOfLength");
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"didWriteDataWithTag");
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    NSLog(@"didReceiveTrust");
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didReadPartialDataOfLength");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    NSLog(@"socketDidDisconnect %@",err);
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDidCloseReadStream");
}

@end
