//
//  Statistics.m
//  EyePro
//
//  Created by 张志阳 on 8/31/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import "Statistics.h"

@implementation Statistics
-(instancetype)init
{
    if (self = [super init]) {
        //should load from local file
        _totalWarningTimes = 0;
        _totalRunningTime = 0;
        _healthIndex = 0;
    }
    return self;
}
@end
