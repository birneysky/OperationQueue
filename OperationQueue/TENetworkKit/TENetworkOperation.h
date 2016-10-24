//
//  TestOperation.h
//  OperationQueue
//
//  Created by zhangguang on 16/10/11.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TENetworkOperation;

typedef void (^TENKCompletedBlock)(TENetworkOperation* operation);
typedef void (^TENKErrorBlock)( NSError* error);
typedef void (^TENKExecutionBlock)();

@interface TENetworkOperation : NSOperation

@property (nonatomic,copy,readonly) TENKCompletedBlock completedBlock;

@property (nonatomic,copy,readonly) TENKErrorBlock errorBlock;

@property (nonatomic,copy,readonly) NSData* responseData;

@property (copy, nonatomic) NSString* certificate;

@property (nonatomic,copy) TENKExecutionBlock excuteBlock;

- (void)setPostedData:(NSData*)data;


- (void)setTarget:(id)target executionSelector:(SEL)selector;


- (void)setCompletionHandler:(TENKCompletedBlock) completion errorHandler:(TENKErrorBlock) error;


- (void)operationFailedWithError:(NSError*) error;


- (void)operationSucceeded:(NSData*)data;

@end
