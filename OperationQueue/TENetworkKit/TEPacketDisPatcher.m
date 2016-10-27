//
//  TEPacketDisPatcher.m
//  Telescope
//
//  Created by zhangguang on 16/10/10.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEPacketDisPatcher.h"
#import <Foundation/Foundation.h>
#import "TENetworkOperation.h"

@implementation TEPacketDisPatcher


- (void)didParsePacket:(NSDictionary *)packet
{

    NSString* packetId = [packet objectForKey:@"packetId"];
    long long pointValue = strtoll(packetId.UTF8String, NULL, 16);//(void*)[packetId longLongValue];
    //sscanf(packetId.UTF8String,"%x",&pointValue);
    void* operationP = (void*)pointValue;
    NSObject* object = (__bridge NSObject *)(operationP);
    static long count = 0;
    NSLog(@"📩📩📩📩 %ld",count++);
    if ([object isMemberOfClass:[TENetworkOperation class]]) {
        TENetworkOperation* op = (TENetworkOperation*)object;
        [op operationSucceeded:nil];
    }
    
}


@end
