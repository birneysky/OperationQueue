//
//  Server.m
//  CocoaAsyncServer
//
//  Created by zhangguang on 16/10/24.
//  Copyright © 2016年 com.V2.Telescope. All rights reserved.
//

#import "TEServer.h"
#import "GCDAsyncSocket.h"


@interface TEServer ()

@property(strong,nonatomic)NSMutableArray *clientSocket;

@property(nonatomic,strong) GCDAsyncSocket* serverSocket;

@property (nonatomic,strong)dispatch_queue_t gloableQ;

@end

@implementation TEServer

#pragma mark - *** Properties ***

-(NSMutableArray *)clientSocket{
    if (_clientSocket == nil) {
        _clientSocket = [NSMutableArray array];
    }
    return _clientSocket;
}

- (dispatch_queue_t)gloableQ
{
    if (!_gloableQ) {
        _gloableQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    }
    return _gloableQ;
}

/*
 *创建一个服务端的socket
 */

 - (GCDAsyncSocket*) serverSocket
{
    if (!_serverSocket) {
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.gloableQ];;
    }
    return _serverSocket;
}

-(instancetype)init{
    if (self = [super init]) {

    }
    return self;
}

- (void)start
{
    //打开监听端口
    NSError *error = nil;
    [self.serverSocket acceptOnPort:5123 error:&error];
    
    if (error == nil) {
        NSLog(@"服务器开启成功");
    }else{
        NSLog(@"服务器开启失败 %@",error);
    }
    //开启主线程循环
    [[NSRunLoop mainRunLoop] run];
}


#pragma mark - *** GCDAsyncSocketDelegate ***

/*
 * 有客户端建立连接  sock 服务端  newSocket 客户端的
 */
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [self.clientSocket addObject:newSocket];
    [newSocket readDataWithTimeout:-1 tag:0];
    
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString *receiverStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // 把回车和换行字符去掉  \r 回车 \n 换行
    [receiverStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    [receiverStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //判断指令
    if ([receiverStr hasPrefix:@"iam:"]) {
        //获取指令后面的信息
        NSString *user = [receiverStr componentsSeparatedByString:@":"][1];
        
        //响应给客户数据
        NSString *respStr = [user stringByAppendingString:@"has joined"];
        
        [sock writeData:[respStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:101];
    }else if([receiverStr hasPrefix:@"msg:"]){
        //获取指令后面的信息
        NSString *msg = [receiverStr componentsSeparatedByString:@":"][1];
        
        
        [sock writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:101];
    }else if([receiverStr isEqualToString:@"quit"]){
        [self.clientSocket removeObject:sock];
        [sock disconnect];
    }
    // 在真正的服务器中还有很多其他的业务    消息保存到数据库中 等
    NSLog(@"%@ data %@",NSStringFromSelector(_cmd),data);
    [sock writeData:data withTimeout:10 tag:0];
     [sock readDataWithTimeout:-1 tag:0];
}


@end
