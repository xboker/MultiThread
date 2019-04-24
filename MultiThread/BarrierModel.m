//
//  BarrierModel.m
//  MultiThread
//
//  Created by xiekunpeng on 2019/4/23.
//  Copyright © 2019 xboker. All rights reserved.
//

#import "BarrierModel.h"

@interface BarrierModel ()
///并发队列
@property (nonatomic, strong) dispatch_queue_t      queue;
///用户数据, 期间可能多线程同时访问
@property (nonatomic, strong) NSMutableDictionary  *dataDic;
@end

@implementation BarrierModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create("CONCURRENT_QUEUE", DISPATCH_QUEUE_CONCURRENT);
        self.dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    __block id object;
    ///采用同步方式获取数据, 执行block然后返回
    dispatch_sync(self.queue, ^{
        object = [self.dataDic objectForKey:key];
    });
    return object;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    ///采用barrier, 确保唯一一个线程在写
    dispatch_barrier_async(self.queue, ^{
        [self.dataDic setObject:object forKey:key];
    });
}



///异步Barrier
- (void)testAsyncBarrierCase {
    dispatch_queue_t queue = dispatch_queue_create("CONCURRENT_QUEUE_1", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"A  当前线程:%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        NSLog(@"B  当前线程:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"C  当前线程:%@", [NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"等到上面A,B,C打印结束后, 执行下面的block, 但是这句话不会立即打印出来, 会在F后面, 因为是异步的");
    });
    dispatch_async(queue, ^{
        NSLog(@"D  当前线程:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"E  当前线程:%@", [NSThread currentThread]);
    });
    NSLog(@"F  当前线程:%@", [NSThread currentThread]);
}
///同步Barrier
- (void)testSyncBarrierCase {
    
    dispatch_queue_t queue = dispatch_queue_create("CONCURRENT_QUEUE_2", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"A  当前线程:%@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        NSLog(@"B  当前线程:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"C  当前线程:%@", [NSThread currentThread]);
    });
    dispatch_barrier_sync(queue, ^{
        NSLog(@"等到上面A,B,C打印结束后,这句话会立即打印出来, 会在D,E,F前面, 因为是同步的然后执行下面的block");
    });
    dispatch_async(queue, ^{
        NSLog(@"D  当前线程:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"E  当前线程:%@", [NSThread currentThread]);
    });
    NSLog(@"F  当前线程:%@", [NSThread currentThread]);
}



@end
