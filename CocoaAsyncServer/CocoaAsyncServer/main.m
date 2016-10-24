//
//  main.m
//  CocoaAsyncServer
//
//  Created by zhangguang on 16/10/24.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEServer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        TEServer* server = [[TEServer alloc] init];
        [server start];
    }
    return 0;
}
