//
//  Setting.m
//  EyePro
//
//  Created by 张志阳 on 8/31/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import "Setting.h"

@implementation Setting
-(instancetype)init
{
    self = [super init];
    if (self) {
        //should load from local configure file
        _voiceHelper = true;
        _pushHelper = true;
        _brightHelper = true;
    }
    return self;
}
@end
