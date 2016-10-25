//
//  TestEngine.h
//  OperationQueue
//
//  Created by zhangguang on 16/10/11.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TENetworkOperation.h"
#import "TEPacketProtocol.h"


typedef NS_ENUM(NSUInteger, TECONNECTION_STATUS){
    UNKNOWN,RUNNING,CLOSED,CONNECTING,CLOSING
};


@interface TENetworkEngine : NSObject


@property (nonatomic,readonly) TECONNECTION_STATUS status;


- (nonnull instancetype) initWithHostName:(nonnull NSString*)name port:(uint16_t)port;


- (void)enqueueOperation:(nonnull TENetworkOperation*)operation;


- (nonnull TENetworkOperation*)operationWithParams:(nonnull id<TEPacketProtocol>)packet;

@end
