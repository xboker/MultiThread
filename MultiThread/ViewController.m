//
//  ViewController.m
//  MultiThread
//
//  Created by xiekunpeng on 2019/4/18.
//  Copyright © 2019 xboker. All rights reserved.
//

#import "ViewController.h"
#import "BarrierModel.h"
#import "GroupModel.h"


@interface ViewController ()
@property (nonatomic, strong) BarrierModel *barriermodel;
@property (nonatomic, strong) GroupModel   *groupModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testCase1];
    [self.barriermodel testSyncBarrierCase];
    [self.groupModel testGroupCase];
}



///死锁
- (void)deadLock {
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"造成死锁");
    });
}

///只会打印1, 3
- (void)testCase1 {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1");
        [self performSelector:@selector(print2) withObject:nil afterDelay:0];
        NSLog(@"3");
    });
}

- (void)print2 {
    NSLog(@"2");
}


///顺序ABCDE
- (void)testCase2 {
    NSLog(@"A");
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"B");
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"C");
        });
        NSLog(@"D");
    });
    NSLog(@"E");
}


///死锁
- (void)testCase3 {
    dispatch_queue_t queue = dispatch_queue_create("queue1", NULL);
    NSLog(@"A");
    dispatch_sync(queue, ^{
        NSLog(@"B");
        dispatch_sync(queue, ^{
            NSLog(@"C");
        });
        NSLog(@"D");
    });
    NSLog(@"E");
}


- (void)testCase4  {
    dispatch_queue_t queue = dispatch_queue_create("queue1", NULL);
    NSLog(@"A");
    dispatch_async(queue, ^{
        NSLog(@"B");
        dispatch_async(queue, ^{
            NSLog(@"C");
            dispatch_async(queue, ^{
                NSLog(@"CC");
            });
        });
        NSLog(@"D");
    });
    NSLog(@"E");
}










#pragma mark    getter
- (BarrierModel *)barriermodel {
    if (!_barriermodel) {
        _barriermodel = [[BarrierModel alloc] init];
    }
    return _barriermodel;
}


- (GroupModel *)groupModel {
    if (!_groupModel) {
        _groupModel = [[GroupModel alloc] init];
    }
    return _groupModel;
}

@end
