//
//  AppDelegate.h
//  EyeCare
//
//  Created by 张志阳 on 8/26/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Statistics.h"
#import "Setting.h"


#define SCREEN_LOCK_STATE_INIT   0x00
#define SCREEN_LOCK_STATE_CHANGED 0x01
#define SCREEN_LOCK_STATE_LOCKED 0x02
#define SCREEN_LOCK_STATE_MASK 0x03


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property Setting *setting;
@property Statistics *statistic;
@property NSInteger screenLockState;

-(void)say:(NSString *)sth;
- (NSString*)getPreferredLanguage;

-(void)sendImageContent: (UIImage*)viewImage withScene:(int)scene;
-(void)sendTextContent: (NSString *)text withScene:(int)scene;
@end

