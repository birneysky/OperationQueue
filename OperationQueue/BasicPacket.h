//
//  Test.h
//  OperationQueue
//
//  Created by zhangguang on 16/10/25.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEPacketProtocol.h"
#import "TEJSONModel.h"

@interface BasicPacket : TEJSONModel <TEPacketProtocol>

- (void)setSequenceNum:(NSString *)num;

- (NSData*)data;


@end
