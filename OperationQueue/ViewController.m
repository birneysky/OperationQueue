//
//  ViewController.m
//  OperationQueue
//
//  Created by zhangguang on 16/10/11.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import "ViewController.h"
#import "TestOperation.h"
#import "TestEngine.h"

@interface ViewController ()

@property (nonatomic,strong) NSOperationQueue* operationQueue;

@property (nonatomic,strong) TestEngine* testEngine;

@end

@implementation ViewController

- (NSOperationQueue*) operationQueue
{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 4;
    }
    
    return _operationQueue;
}


- (TestEngine*)testEngine
{
    if (!_testEngine) {
        _testEngine = [[TestEngine alloc] init];
    }
    return _testEngine;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    //operationQueue.maxConcurrentOperationCount = 4;
    
    TestOperation* op1 = [[TestOperation alloc] initWithIdentity:@"1"];
    TestOperation* op2 = [[TestOperation alloc] initWithIdentity:@"2"];
    
    
    
    TestOperation* op3 = [[TestOperation alloc] initWithIdentity:@"3"];
    TestOperation* op4 = [[TestOperation alloc] initWithIdentity:@"4"];
    
    
    TestOperation* op5 = [[TestOperation alloc] initWithIdentity:@"5"];
    TestOperation* op6 = [[TestOperation alloc] initWithIdentity:@"6"];
    
    
    TestOperation* op7 = [[TestOperation alloc] initWithIdentity:@"7"];
    TestOperation* op8 = [[TestOperation alloc] initWithIdentity:@"8"];
    
    
    TestOperation* op9 = [[TestOperation alloc] initWithIdentity:@"9"];
    TestOperation* op10 = [[TestOperation alloc] initWithIdentity:@"10"];
    
    
    TestOperation* op11 = [[TestOperation alloc] initWithIdentity:@"11"];
    TestOperation* op12 = [[TestOperation alloc] initWithIdentity:@"12"];
    
    
    TestOperation* op13 = [[TestOperation alloc] initWithIdentity:@"13"];
    TestOperation* op14 = [[TestOperation alloc] initWithIdentity:@"14"];
    
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

    [self.testEngine enqueueOperation:op1];
    [self.testEngine enqueueOperation:op2];
    [self.testEngine enqueueOperation:op3];
    [self.testEngine enqueueOperation:op4];
    [self.testEngine enqueueOperation:op5];
    [self.testEngine enqueueOperation:op6];
    [self.testEngine enqueueOperation:op7];
    [self.testEngine enqueueOperation:op8];
    
    [self.testEngine enqueueOperation:op9];
    [self.testEngine enqueueOperation:op10];
    [self.testEngine enqueueOperation:op11];
    [self.testEngine enqueueOperation:op12];
    [self.testEngine enqueueOperation:op13];
    [self.testEngine enqueueOperation:op14];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
