//
//  TENetworkKit.h
//  OperationQueue
//
//  Created by zhangguang on 16/10/24.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TENetworkKit : NSObject

+ (instancetype)defaultNetKit;


- (void) loginWithAccountNum:(NSString*)anum password:(NSString*)pwd;

@end
