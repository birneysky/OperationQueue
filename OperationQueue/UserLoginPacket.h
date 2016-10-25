//
//  UserLoginPacket.h
//  OperationQueue
//
//  Created by zhangguang on 16/10/25.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicPacket.h"

@interface UserLoginPacket : BasicPacket

@property (nonatomic,copy) NSString* userName;

@property (nonatomic,copy) NSString* pwd;

@end
