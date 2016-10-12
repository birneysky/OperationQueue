//
//  TestEngine.h
//  OperationQueue
//
//  Created by zhangguang on 16/10/11.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "TestOperation.h"



@interface TestEngine : NSObject


- (void)enqueueOperation:(TestOperation*)operation;


@end
