//
//  MainViewController.m
//  EyeCare
//
//  Created by 张志阳 on 8/26/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//
#import "AppDelegate.h"
#import "MainViewController.h"
#import "BLEDevice.h"
#import <UIKit/UIKit.h>
@interface MainViewController ()<UIAlertViewDelegate, HeartRateDelegate>
{
    NSTimer *_timer;
    NSInteger _alertFlag;
    NSInteger _counter;
    HeartRateDevice *_hd;
}
@end

@implementation MainViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        _alertFlag = 0;
        _counter = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     _hd = [[HeartRateDevice alloc]init:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTimer
{
    if (_alertFlag == 0) {
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"距离太近，有害眼睛"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];*/
        //_alertFlag = 1;
        [self sendNotify];
    }
    _counter += 5;
    self.CounterLabel.text = [NSString stringWithFormat:@"%ld",_counter];
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    if ([[app getPreferredLanguage] isEqualToString:@"zh-Hans"]) {
        [app say:@"距离太近 请保持距离"];
    }
    else if([[app getPreferredLanguage] isEqualToString:@"en"])
    [app say:@"keep distance"];
    else if([[app getPreferredLanguage] isEqualToString:@"fr"])
        [app say:@"Veuillez garder à distance"];
    else if([[app getPreferredLanguage] isEqualToString:@"de"])
        [app say:@"Bitte abstand Halten"];
     float brightness = [[UIScreen mainScreen]brightness];
     [[UIScreen mainScreen]setBrightness:0.5f];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _alertFlag = 0;
}

-(void)sendNotify
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:10];//10秒后通知
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber=1; //应用的红色数字
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        notification.alertBody=@"距离太近，请保护眼睛";//提示信息 弹出提示框
        notification.alertAction = @"打开";  //提示框按钮
        //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        // NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        //notification.userInfo = infoDict; //添加额外的信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(void)didUpdateHeartRate:(unsigned short)heartRate
{

}

-(void)isheartRateAvailable:(BOOL)available
{}
@end
/*
 (
 
 en,
 
 "zh-Hans",
 
 fr,
 
 de,
 
 ja,
 
 nl,
 
 it,
 
 es,
 
 pt,
 
 "pt-PT",
 
 da,
 
 fi,
 
 nb,
 
 sv,
 
 ko,
 
 "zh-Hant",
 
 ru,
 
 pl,
 
 tr,
 
 uk,
 
 ar,
 
 hr,
 
 cs,
 
 el,
 
 he,
 
 ro,
 
 sk,
 
 th,
 
 id,
 
 ms,
 
 "en-GB",
 
 ca,
 
 hu,
 
 vi
 
 )
 

 */
