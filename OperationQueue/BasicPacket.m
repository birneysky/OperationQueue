//
//  Test.m
//  OperationQueue
//
//  Created by zhangguang on 16/10/25.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import "BasicPacket.h"

@interface BasicPacket()

@property (nonatomic,copy) NSString* packetId;

@end

@implementation BasicPacket



- (void)setSequenceNum:(NSString *)num
{
    self.packetId = num;
}

- (NSData*)data
{
    return [self toJsonData];
}






@end
