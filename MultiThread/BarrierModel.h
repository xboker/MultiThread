//
//  BarrierModel.h
//  MultiThread
//
//  Created by xiekunpeng on 2019/4/23.
//  Copyright © 2019 xboker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BarrierModel : NSObject
///异步Barrier
- (void)testAsyncBarrierCase;
///同步Barrier
- (void)testSyncBarrierCase;


@end

NS_ASSUME_NONNULL_END
