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
#import "GraphView.h"
#import "SettingViewController.h"
#import <UIKit/UIKit.h>
#import "WXApi.h"
#define PROTECT_COLOR [UIColor colorWithRed:70.0/255 green:150.0/255 blue:30.0/255 alpha:1.0]
#define CONTENT_COLOR [UIColor colorWithRed:180.0/255 green:200.0/255 blue:80.0/255 alpha:1.0]
@interface MainViewController ()< HeartRateDelegate>
{
    NSTimer *_timer;
    HeartRateDevice *_hd;
    GraphView *_graphView;

}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"empty.png"] forBarMetrics:UIBarMetricsDefault];
    //self.view.backgroundColor = PROTECT_COLOR;
   // self.navigationBar.tintColor = CONTENT_COLOR;
    self.CounterLabel.textColor = CONTENT_COLOR;
    self.CounterLabel.text = [NSString stringWithFormat:@"提醒次数\t\t0"];

     _hd = [[HeartRateDevice alloc]init:self];
    _timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

    // init _graphView and set up options
    _graphView = [[GraphView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 300, [[UIScreen mainScreen] bounds].size.width, 300)];
    [_graphView setBackgroundColor:[UIColor darkGrayColor]];
    [_graphView setSpacing:10];
    [_graphView setFill:YES];
    [_graphView setStrokeColor:[UIColor redColor]];
    [_graphView setZeroLineStrokeColor:[UIColor greenColor]];
    [_graphView setFillColor:[UIColor orangeColor]];
    [_graphView setLineWidth:2];
    [_graphView setCurvedLines:NO];
    //to hold heart rates
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:[[NSNumber alloc]initWithInt:20]];
    [array addObject:[[NSNumber alloc]initWithInt:50]];
    [array addObject:[[NSNumber alloc]initWithInt:20]];
    [array addObject:[[NSNumber alloc]initWithInt:50]];
    [array addObject:[[NSNumber alloc]initWithInt:20]];
    [array addObject:[[NSNumber alloc]initWithInt:50]];
    [array addObject:[[NSNumber alloc]initWithInt:20]];
    [array addObject:[[NSNumber alloc]initWithInt:50]];
    [array addObject:[[NSNumber alloc]initWithInt:20]];
    [array addObject:[[NSNumber alloc]initWithInt:50]];

    //init array here!!!!!!!!!!!!!!!!!!!!!!!
    [_graphView setArray:array];
    [_graphView setNumberOfPointsInGraph:(int)[array count]];
    [self.view addSubview:_graphView];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - disable landscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


-(void)onTimer
{

}

-(void)voiceHelper
{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    if ([[app getPreferredLanguage] isEqualToString:@"zh-Hans"]) {
        //语音需要一段时间结束
        [app say:@"请保持眼睛距离屏幕20厘米以上"];
    }
    else if([[app getPreferredLanguage] isEqualToString:@"en"])
        [app say:@"keep distance"];
    else if([[app getPreferredLanguage] isEqualToString:@"fr"])
        [app say:@"Veuillez garder à distance"];
    else if([[app getPreferredLanguage] isEqualToString:@"de"])
        [app say:@"Bitte abstand Halten"];
}
-(void)pushHelper
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:0];//10秒后通知
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        //notification.applicationIconBadgeNumber=0; //应用的红色数字
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        notification.alertBody=@"距离太近，请保护眼睛";//提示信息 弹出提示框
        notification.alertAction = @"打开";  //提示框按钮
        notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        notification.userInfo = infoDict; //添加额外的信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(void)brightHelper:(float)brightness
{
    //float brightness = [[UIScreen mainScreen]brightness];
    [[UIScreen mainScreen]setBrightness:brightness];
}
//0x31~0x34 from far to near
-(void)onDataUpdated:(int)data
{
   
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    Setting *set = [app setting];
    Statistics *statistic = [app statistic];
    NSLog(@"screen lock state %ld", app.screenLockState);
    //已经锁屏，取消提醒
    if (app.screenLockState == SCREEN_LOCK_STATE_MASK) {
        return;
    }
    
    //距离没问题
    if (data < 0x32) {
        return;
    }
    
    statistic.totalWarningTimes++;
    self.CounterLabel.text = [NSString stringWithFormat:@"提醒次数\t\t%ld",statistic.totalWarningTimes];
    
    if (set.voiceHelper) {
        [self voiceHelper];
    }
    if (set.pushHelper) {
        [self pushHelper];
    }
    
    if (set.brightHelper) {
        [[UIScreen mainScreen]setBrightness: (float)(data%100)/100.0f];
    }
}
-(void)didUpdateHeartRate:(unsigned short)heartRate
{
    static int conuter = 0;
    
   // if (conuter++ == 10) {
        conuter = 0;
      //  if (heartRate > 80) {
            [self onDataUpdated:heartRate];
            
       // }
  //  }
    NSLog(@"heart rate available");
    }

-(void)isheartRateAvailable:(BOOL)available
{
    NSLog(@"heart rate available %d",available);
}


- (IBAction)onSettingButton:(id)sender {
    SettingViewController *vc = [[SettingViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)onShareButton:(id)sender {
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    [app sendTextContent:@"hello world" withScene:WXSceneSession];
}

@end
