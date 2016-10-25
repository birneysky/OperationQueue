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
#import "TEReachability.h"
#import "TEStreamBuffer.h"
#import "TEPacketDisPatcher.h"


#define kTENetworkKitOperationTimeOutInSeconds 5
#define kHeartBeatSendInterval 5
#define kTagHeartBeat 1001
#define kTagBiz 1002

static NSOperationQueue *_sharedNetworkQueue;


@interface TENetworkEngine ()  <GCDAsyncSocketDelegate>

@property (nonatomic,copy) NSString* hostName;

@property (nonatomic,assign) uint16_t port;

@property (nonatomic,strong)  GCDAsyncSocket* asyncSocket;

@property (nonatomic,assign) TECONNECTION_STATUS status;

@property (nonatomic,strong) NSTimer* heartBeatTimer;

@property (nonatomic,strong) NSTimer* autoReconnectTimer;

@property (strong, nonatomic) TEReachability *reachability;

@property (nonatomic, strong) NSMutableArray<TENetworkOperation*>* cacheOperations;

@property (nonatomic,strong) TEStreamBuffer* streamBuffer;

@property (nonatomic,strong) TEPacketDisPatcher* packetDipatcher;

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
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("com.TENetworkEngine.delegateQueue",DISPATCH_QUEUE_SERIAL)/*, <#dispatch_queue_attr_t  _Nullable attr#>)(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)*/];
    }
    return _asyncSocket;
}

- (NSMutableArray<TENetworkOperation*>*)cacheOperations
{
    if (!_cacheOperations) {
        _cacheOperations = [NSMutableArray new];
    }
    return _cacheOperations;
}

- (TEStreamBuffer*)streamBuffer
{
    if (!_streamBuffer) {
        _streamBuffer = [[TEStreamBuffer alloc] init];
        _streamBuffer.delegate = self.packetDipatcher;
    }
    return _streamBuffer;
}


- (TEPacketDisPatcher*) packetDipatcher{
    if (!_packetDipatcher) {
        _packetDipatcher = [[TEPacketDisPatcher alloc] init];
    }
    return _packetDipatcher;
}

#pragma mark - *** Api ***
- (nonnull instancetype) initWithHostName:(nonnull NSString*)name port:(uint16_t)port;
{
    if (self = [super init]) {
        self.hostName = name;
        self.port = port;
        if (self.hostName.length > 0) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(reachabilityChanged:)
                                                         name:kTEReachabilityChangedNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(networkChanged:)
                                                         name:kTENetworkChangedNotification
                                                       object:nil];
            self.reachability = [TEReachability reachabilityWithHostname:self.hostName];
            [self.reachability startNotifier];
        }

        [self start];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTEReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTENetworkChangedNotification object:nil];
}

- (void)enqueueOperation:(TENetworkOperation*)operation;
{
    if (RUNNING != self.status) {
        [self.cacheOperations addObject:operation];
    }
    else{
        [_sharedNetworkQueue addOperation:operation];
    }
    
}


- (TENetworkOperation*)operationWithParams:(id<TEPacketProtocol>)packet
{
    TENetworkOperation* op = [[TENetworkOperation alloc] init];
    NSString* seqId = [NSString stringWithFormat:@"%p",op];
    [packet setSequenceNum:seqId];
    [op setTarget:self executionSelector:@selector(sendData:)];
    __weak TENetworkEngine* weakSelf = self;
    [op setExcuteBlock:^{
        [weakSelf sendData:packet.data];
    }];
    op.postedPacket = packet;
    return op;
}

#pragma mark - *** Helper ***

- (void)start
{
    NSError* error;
    self.status = CONNECTING;
    [self connectToHost:self.hostName onPort:self.port error:&error];
    if (error) {
        NSLog(@"connect error %@",error);
    }
}


- (void) sendData:(NSData *)data
{
    [self sendData:data tag:kTagBiz];
}

- (void) sendData:(NSData *)data tag:(NSInteger)tag
{
    NSInteger lenght = data.length;
    NSMutableData* sendData = [[NSMutableData alloc] initWithCapacity:data.length + 4];
    while (true) {
        if ((lenght & ~0x7F) == 0) {
            int8_t value = (int8_t)lenght;
            [sendData appendBytes:&value length:sizeof(value)];
            break;
        } else {
            int8_t value = (lenght & 0x7F) | 0x80;
            [sendData appendBytes:&value length:sizeof(value)];
            lenght >>= 7;
        }
    }
    [sendData appendData:data];
    [self.asyncSocket writeData:[sendData copy] withTimeout:kTENetworkKitOperationTimeOutInSeconds tag:tag];
}

- (BOOL)connectToHost:(NSString*)host onPort:(uint16_t)port error:(NSError **)errPtr
{
    //return [self.asyncSocket connectToHost:host onPort:port error:errPtr];
    NSLog(@"🚩🚩🚩🚩connectToHost-----begin");
    BOOL res = [self.asyncSocket connectToHost:host onPort:port withTimeout:kTENetworkKitOperationTimeOutInSeconds error:errPtr];
    NSLog(@"🚩🚩🚩🚩connectToHost-----end");
    return res;
}


- (void)disconnect
{
    self.status = CLOSING;
    [self.asyncSocket disconnect];
    
}

- (void)setStatus:(TECONNECTION_STATUS)status
{
    _status = status;
    if (RUNNING == status) {
        // 启动心跳定时器
        [self startHeartBeatTimer];
        //取消重连定时器
        [self cancelReconnectTimer];
        
        // 执行缓存任务
        __weak TENetworkEngine* weakSelf = self;
        [self.cacheOperations enumerateObjectsUsingBlock:^(TENetworkOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf enqueueOperation:obj];
        }];
        
    }
    else if(CLOSED == status){
        // 取消心跳定时器
        [self cancelHeartBeatTimer];
        // 启动重连定时器
        
        [self startReconnectTimer];
        

    }
}


- (void) startReconnectTimer{
    if (self.reachability.currentReachabilityStatus == NotReachable) {
        [self.autoReconnectTimer  invalidate];
        self.autoReconnectTimer = nil;
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.autoReconnectTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(autoReconnect:) userInfo:nil repeats:NO];
    });
}

- (void) startHeartBeatTimer{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.heartBeatTimer =  [NSTimer scheduledTimerWithTimeInterval:kTENetworkKitOperationTimeOutInSeconds target:self selector:@selector(autoSendHeartbeat:) userInfo:nil repeats:YES];

    });
}

- (void)cancelReconnectTimer{
    if (self.autoReconnectTimer) {
        [self.autoReconnectTimer invalidate];
        self.autoReconnectTimer = nil;
    }
}

- (void)cancelHeartBeatTimer{
    if (self.heartBeatTimer) {
        [self.heartBeatTimer invalidate];
        self.heartBeatTimer = nil;
    }
}

#pragma mark - *** GCDAsyncSocketDelegate ***

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"🌏🌏🌏🌏🌏Connect to server successfully %@:%d",host,port);
    self.status = RUNNING;
    [self.asyncSocket readDataWithTimeout:-1 tag:0];

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"📲📲📲📲📲📲 didReadDataTag %ld  %@,length %ld",tag,data,(long)data.length);
    
     [self.streamBuffer appendData:data];
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didWritePartialDataOfLength");
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"didWriteDataWithTag:%ld",tag);
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
    self.status = CLOSED;
    NSLog(@" socketDidDisconnect %@",err);
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDidCloseReadStream");
}

- (NSTimeInterval)onSocket:(AsyncSocket *)sock
 shouldTimeoutWriteWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(NSUInteger)length
{
    NSLog(@"shouldTimeoutWriteWithTag:%ld elapsed %f bytesDone %lu",tag,elapsed,length);
    return -1;
}

#pragma mark - *** Timer ***
- (void)autoSendHeartbeat:(NSTimer*)timer
{
    uint8_t buffer[] = {0x08,0x03};
    
    [self sendData:[NSData dataWithBytes:buffer length:sizeof(buffer)] tag:kTagHeartBeat];
    NSLog(@"☄️☄️☄️☄️☄️☄️ send heart beat");
    [self.asyncSocket readDataWithTimeout:-1 tag:0];
}

- (void)autoReconnect:(NSTimer*)timer
{
    NSError* error;
    [self connectToHost:self.hostName onPort:self.port error:&error];
}

#pragma mark - *** Notification ***
-(void) reachabilityChanged:(NSNotification*) notification
{
    if([self.reachability currentReachabilityStatus] == ReachableViaWiFi ||
       [self.reachability currentReachabilityStatus] == ReachableViaWWAN)
    {
//        DLog(@"Server [%@] is reachable via Wifi", self.hostName);
//        [_sharedNetworkQueue setMaxConcurrentOperationCount:6];
//        
//        [self checkAndRestoreFrozenOperations];
        NSLog(@"🌊🌊🌊🌊🌊🌊");
        if (!self.autoReconnectTimer && CLOSED == self.status) {
            [self startReconnectTimer];
        }
    }
//    else if([self.reachability currentReachabilityStatus] == ReachableViaWWAN)
//    {
//        if(self.wifiOnlyMode) {
//            
//            DLog(@" Disabling engine as server [%@] is reachable only via cellular data.", self.hostName);
//            [_sharedNetworkQueue setMaxConcurrentOperationCount:0];
//        } else {
//            DLog(@"Server [%@] is reachable only via cellular data", self.hostName);
//            [_sharedNetworkQueue setMaxConcurrentOperationCount:2];
//            [self checkAndRestoreFrozenOperations];
//        }
//    }
    else if([self.reachability currentReachabilityStatus] == NotReachable)
    {
//        DLog(@"Server [%@] is not reachable", self.hostName);
//        [self freezeOperations];
        NSLog(@"‼️‼️ Server [%@] is not reachable",self.hostName);
    }
    
//    if(self.reachabilityChangedHandler) {
//        self.reachabilityChangedHandler([self.reachability currentReachabilityStatus]);
//    }
}

- (void)networkChanged:(NSNotification*)notification
{
    [self.asyncSocket disconnect];
    NSLog(@"♨️♨️♨️♨️♨️♨️♨️");
}


@end
