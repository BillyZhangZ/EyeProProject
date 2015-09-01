//
//  OtaViewController.m
//  EyePro
//
//  Created by 张志阳 on 8/30/15.
//  Copyright (c) 2015 张志阳. All rights reserved.
//

#import "OtaViewController.h"

@interface OtaViewController ()<NSStreamDelegate>

@property (nonatomic, retain)   NSInputStream *   networkStream;//输入流
@property (nonatomic, copy)     NSString *        filePath;
@property (nonatomic, retain)   NSOutputStream *  fileStream;//输出流@end

@end

@implementation OtaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CFReadStreamRef ftpStream;
    NSURL *url;
    
    //获得地址
    url = [NSURL URLWithString:@"ftp://121.40.128.16/readme.txt"];//_serverInput.text];
    
    NSLog(@"url is %@",url);
    
    // 为文件存储路径打开流，filePath为文件写入的路径,hello为图片的名字
    self.filePath = @"/Users/billjiang/Desktop/hello.png";
    self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:NO];
    [self.fileStream open];
    
    // 打开CFFTPStream
    ftpStream = CFReadStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url);
    self.networkStream = (__bridge NSInputStream *) ftpStream;
    assert(ftpStream != NULL);
    
    // 设置代理
    self.networkStream.delegate = self;
    
    // 启动循环
    [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.networkStream open];
    
    CFRelease(ftpStream);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onUpgradeButton:(id)sender {
    //check firmware version on server and device, and then upgrade or not
    
}

#pragma mark NSStreamDelegate委托方法
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
        } break;
        case NSStreamEventHasBytesAvailable: {
            NSInteger bytesRead;
            uint8_t buffer[32768];//缓冲区的大小 32768可以设置，uint8_t为一个字节大小的无符号int类型
            
            // 读取数据
            bytesRead = [self.networkStream read:buffer maxLength:sizeof(buffer)];
            if (bytesRead == -1) {
                [self _stopReceiveWithStatus:@"读取网络数据出错"];
            } else if (bytesRead == 0) {
                NSLog(@"download succeed");
                //下载成功
                [self _stopReceiveWithStatus:nil];
            } else {
               // NSInteger   bytesWritten;//实际写入数据
                NSInteger   bytesWrittenSoFar;//当前数据写入位置
                
                // 写入文件
                bytesWrittenSoFar = 0;
                /*
                do {
                    bytesWritten = [self.fileStream write:&buffer[bytesWrittenSoFar] maxLength:bytesRead - bytesWrittenSoFar];
                    assert(bytesWritten != 0);
                    if (bytesWritten == -1) {
                        [self _stopReceiveWithStatus:@"文件写入出错"];
                        assert(NO);
                        break;
                    } else {
                        bytesWrittenSoFar += bytesWritten;
                    }
                } while (bytesWrittenSoFar != bytesRead);
                 */
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO);
        } break;
        case NSStreamEventErrorOccurred: {
            [self _stopReceiveWithStatus:@"打开出错，请检查路径"];
            assert(NO);
        case NSStreamEventEndEncountered: {
        } break;
        default:
            assert(NO);
            break;
        }
    }
}

#pragma mark 结果处理，关闭链接
- (void)_stopReceiveWithStatus:(NSString *)statusString
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    if(statusString == nil){
        statusString = @"下载成功";
        //_imageView.image = [UIImage imageWithContentsOfFile:self.filePath];
    }
    self.filePath = nil;
}

@end
