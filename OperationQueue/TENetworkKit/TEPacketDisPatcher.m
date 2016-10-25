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
    long long pointValue = 0;//(void*)[packetId longLongValue];
    //scanf(packetId.UTF8String,"%lld",&pointValue);
    void* operationP = (void*)pointValue;
    NSObject* object = (__bridge NSObject *)(operationP);
    
    
    if ([object isMemberOfClass:[TENetworkOperation class]]) {
        
    }
    
}


@end
