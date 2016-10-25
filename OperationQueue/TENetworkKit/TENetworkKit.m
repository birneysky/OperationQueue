//
//  TENetworkKit.m
//  OperationQueue
//
//  Created by zhangguang on 16/10/24.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import "TENetworkKit.h"
#import "TENetworkEngine.h"
#import "UserLoginPacket.h"

static TENetworkKit* defaultKit;



@interface TENetworkKit ()

@property (nonatomic,strong) TENetworkEngine* networkEngine;

@end


@implementation TENetworkKit

+ (instancetype)defaultNetKit
{
    if (!defaultKit) {
        defaultKit = [[TENetworkKit alloc] init];
        [defaultKit networkEngine];
    }
    return defaultKit;
}

+ (instancetype) allocWithZone:(struct _NSZone *)zone
{
    if (!defaultKit) {
        defaultKit = [super allocWithZone:zone];
    }
    return defaultKit;
}

- (instancetype) copy{
    return defaultKit;
}


#pragma mark - *** Properties ***
- (TENetworkEngine*) networkEngine
{
    if (!_networkEngine) {
        _networkEngine = [[TENetworkEngine alloc] initWithHostName:@"192.168.0.93" port:5123];
    }
    return _networkEngine;
}


- (void) loginWithAccountNum:(NSString*)anum password:(NSString*)pwd
{
    UserLoginPacket* packet = [[UserLoginPacket alloc] init];
    packet.userName = anum;
    packet.pwd = pwd;
    
    TENetworkOperation* op = [self.networkEngine operationWithParams:packet];

    [self.networkEngine enqueueOperation:op];
}

@end
