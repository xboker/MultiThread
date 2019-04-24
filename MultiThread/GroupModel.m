//
//  GroupModel.m
//  MultiThread
//
//  Created by xiekunpeng on 2019/4/23.
//  Copyright © 2019 xboker. All rights reserved.
//

#import "GroupModel.h"

@interface GroupModel  ()
@property (nonatomic, strong) dispatch_queue_t queue;
@end


@implementation GroupModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.queue = dispatch_queue_create("CONCURRENT_QUEUE", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)testGroupCase {
    dispatch_group_t group = dispatch_group_create();
    [self requestHTTP_AWithGroup:group];
    [self requestHTTP_BWithGroup:group];
    ///多个group全部leave后,即全部执行完后. 刷新UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self layoutUI];
    });
    
}


- (void)requestHTTP_AWithGroup:(dispatch_group_t)group {
    /**
     方式1: 将需要执行的内容放在block中, 但是这种由于是异步并不能立即获取到回调, 日常开发一般采用第二种方式
     dispatch_group_async(group, self.queue, ^{
     
     });
    */
    /**方式2*/
    if (group == nil) {
        return;
    }
    dispatch_group_enter(group);
    dispatch_async(self.queue, ^{
        for (int i = 0; i < 100; i ++) {
            NSLog(@"AAA");
        }
        dispatch_group_leave(group);
    });
    

}

- (void)requestHTTP_BWithGroup:(dispatch_group_t)group {
    if (group == nil) {
        return;
    }
    dispatch_group_enter(group);
    dispatch_async(self.queue, ^{
        for (int i = 0; i < 100; i ++) {
            NSLog(@"BBB");
        }
        dispatch_group_leave(group);
    });
}


- (void)layoutUI {
    NSLog(@"AAA和BBB歌打印100次后更新UI");
}



@end
