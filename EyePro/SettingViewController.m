//
//  SettingViewController.m
//  EyePro
//
//  Created by 张志阳 on 8/31/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import "SettingViewController.h"
#import "OtaViewController.h"
#import "PravicyViewController.h"
#import "AppDelegate.h"
@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak) Setting *setting;
@property (weak) Statistics *statistic;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    _setting = [app setting];
    _statistic =[app statistic];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 1;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"settingTableCell1"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingTableCell1"];
    cell.backgroundColor = [UIColor whiteColor];
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell.textLabel.text = @"总提醒次数";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", _statistic.totalWarningTimes];
            
            /* UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
             switchView.tag = indexPath.row;
             cell.accessoryView = switchView;
             [switchView setOn:NO animated:NO];
             [switchView addTarget:self action:@selector(switchNotification:) forControlEvents:UIControlEventValueChanged];
             
             UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
             switchView.on = (types != UIUserNotificationTypeNone);
             switchView.onTintColor = [UIColor colorWithRed:0xf0/255.0 green:0x65/255.0 blue:0x22/255.0 alpha:1.0];*/
        }
        else if(indexPath.row == 1) {
            cell.textLabel.text = @"语音提醒";
            cell.detailTextLabel.text = @"";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            switchView.tag = indexPath.row;
            cell.accessoryView = switchView;
            [switchView setOn:_setting.voiceHelper animated:NO];
            [switchView addTarget:self action:@selector(switchVoiceHelper:) forControlEvents:UIControlEventValueChanged];
          //  switchView.onTintColor = CONTENT_COLOR;//[UIColor colorWithRed:0xf0/255.0 green:0x65/255.0 blue:0x22/255.0 alpha:1.0];
        }
        else if(indexPath.row == 2) {
            cell.textLabel.text = @"推送提醒";
            cell.detailTextLabel.text = @"";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            switchView.tag = indexPath.row;
            cell.accessoryView = switchView;
            [switchView setOn:_setting.pushHelper animated:NO];
            [switchView addTarget:self action:@selector(switchPushHelper:) forControlEvents:UIControlEventValueChanged];
         //   switchView.onTintColor = CONTENT_COLOR;//[UIColor colorWithRed:0xf0/255.0 green:0x65/255.0 blue:0x22/255.0 alpha:1.0];
        }
        else if(indexPath.row == 3) {
            cell.textLabel.text = @"自动调节屏幕亮度";
            cell.detailTextLabel.text = @"根据高精度传感器感知环境光线";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            switchView.tag = indexPath.row;
            cell.accessoryView = switchView;
            [switchView setOn:_setting.brightHelper animated:NO];
            [switchView addTarget:self action:@selector(switchBrightHelper:) forControlEvents:UIControlEventValueChanged];
         //   switchView.onTintColor = CONTENT_COLOR;//[UIColor colorWithRed:0xf0/255.0 green:0x65/255.0 blue:0x22/255.0 alpha:1.0];
        }
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = @"设备升级";
        cell.backgroundColor = [UIColor blueColor];
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = @"隐私声明";
        cell.backgroundColor = [UIColor grayColor];
    }
   // cell.backgroundColor = PROTECT_COLOR;// 180 200 80
   // cell.textLabel.textColor = CONTENT_COLOR;
    //cell.detailTextLabel.textColor = CONTENT_COLOR;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return  40.0f;
    }
    return 22.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        OtaViewController *vc = [[OtaViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        PravicyViewController *vc = [[PravicyViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
-(void)switchVoiceHelper:(id)sender
{
    NSLog(@"voice helper");
    UISwitch *s = (UISwitch *)sender;
    _setting.voiceHelper = s.on;
}

-(void)switchPushHelper:(id)sender
{
    NSLog(@"push helper");
    UISwitch *s = (UISwitch *)sender;
    _setting.pushHelper = s.on;
}

-(void)switchBrightHelper:(id)sender
{
    NSLog(@"bright helper");
    UISwitch *s = (UISwitch *)sender;
    _setting.brightHelper = s.on;
}
- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
