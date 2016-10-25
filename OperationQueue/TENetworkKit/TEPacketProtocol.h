//
//  TEPacketProtocol.h
//  OperationQueue
//
//  Created by zhangguang on 16/10/25.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#ifndef TEPacketProtocol_h
#define TEPacketProtocol_h

@protocol TEPacketProtocol <NSObject>

- (nullable NSData*)data;

- (void)setSequenceNum:(nonnull NSString*)num;

@end

#endif /* TEPacketProtocol_h */
