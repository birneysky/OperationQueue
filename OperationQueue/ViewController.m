//
//  ViewController.m
//  OperationQueue
//
//  Created by zhangguang on 16/10/11.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import "ViewController.h"
#import "TENetworkOperation.h"
#import "TENetworkEngine.h"

#import "TENetworkKit.h"

@interface ViewController ()

//@property (nonatomic,strong) NSOperationQueue* operationQueue;
//
//@property (nonatomic,strong) TENetworkEngine* testEngine;


@end

@implementation ViewController

//- (NSOperationQueue*) operationQueue
//{
//    if (!_operationQueue) {
//        _operationQueue = [[NSOperationQueue alloc] init];
//        _operationQueue.maxConcurrentOperationCount = 4;
//    }
//    
//    return _operationQueue;
//}


//- (TENetworkEngine*)testEngine
//{
//    if (!_testEngine) {
//        _testEngine = [[TENetworkEngine alloc] init];
//    }
//    return _testEngine;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    [TENetworkKit defaultNetKit];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    //operationQueue.maxConcurrentOperationCount = 4;
    
//    TENetworkOperation* op1 = [[TENetworkOperation alloc] init];
//    TENetworkOperation* op2 = [[TENetworkOperation alloc] init];
//    
//    
//    
//    TENetworkOperation* op3 = [[TENetworkOperation alloc] init];
//    TENetworkOperation* op4 = [[TENetworkOperation alloc] init];
//    
//    
//    TENetworkOperation* op5 = [[TENetworkOperation alloc] init];
//    TENetworkOperation* op6 = [[TENetworkOperation alloc] init];
//    
//    
//    TENetworkOperation* op7 = [[TENetworkOperation alloc] init];
//    TENetworkOperation* op8 = [[TENetworkOperation alloc] init];
//    
//    
//    TENetworkOperation* op9 = [[TENetworkOperation alloc] init];
//    TENetworkOperation* op10 = [[TENetworkOperation alloc] init];
    
//    
//    TENetworkEngine* op11 = [[TENetworkOperation alloc] init];
//    TENetworkEngine* op12 = [[TENetworkOperation alloc] init];
//    
//    
//    TENetworkEngine* op13 = [[TENetworkOperation alloc] init];
//    TENetworkEngine* op14 = [[TENetworkOperation alloc] init];
    
//    [self.operationQueue addOperation:op1];
//    [self.operationQueue addOperation:op2];
//    [self.operationQueue addOperation:op3];
//    [self.operationQueue addOperation:op4];
//    [self.operationQueue addOperation:op5];
//    [self.operationQueue addOperation:op6];
//    [self.operationQueue addOperation:op7];
//    [self.operationQueue addOperation:op8];
//    [self.operationQueue addOperation:op9];
//    [self.operationQueue addOperation:op10];
//    [self.operationQueue addOperation:op11];
//    [self.operationQueue addOperation:op12];
//    [self.operationQueue addOperation:op13];
//    [self.operationQueue addOperation:op14];

//    [self.testEngine enqueueOperation:op1];
//    [self.testEngine enqueueOperation:op2];
//    [self.testEngine enqueueOperation:op3];
//    [self.testEngine enqueueOperation:op4];
//    [self.testEngine enqueueOperation:op5];
//    [self.testEngine enqueueOperation:op6];
//    [self.testEngine enqueueOperation:op7];
//    [self.testEngine enqueueOperation:op8];
//    
//    [self.testEngine enqueueOperation:op9];
//    [self.testEngine enqueueOperation:op10];
//    [self.testEngine enqueueOperation:op11];
//    [self.testEngine enqueueOperation:op12];
//    [self.testEngine enqueueOperation:op13];
//    [self.testEngine enqueueOperation:op14];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
