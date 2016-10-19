//
//  TestEngine.h
//  OperationQueue
//
//  Created by zhangguang on 16/10/11.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TENetworkOperation.h"



typedef NS_ENUM(NSUInteger, TECONNECTION_STATUS){
    RUNNING,CLOSED,CONNECTING,CLOSING,FETCHING,FETCHED,
};


@interface TENetworkEngine : NSObject


- (instancetype) initWithHostName:(NSString*)name port:(uint16_t)port;


- (void)enqueueOperation:(TENetworkOperation*)operation;


@end
