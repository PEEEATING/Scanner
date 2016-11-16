//
//  ViewController.m
//  Scanner
//
//  Created by EATING on 2016/11/16.
//  Copyright © 2016年 EATING. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WebVC.h"


@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong,nonatomic) AVCaptureSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:input];
    [self.session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    //扫描框的位置和大小
    layer.frame = CGRectMake(40, 100, 250, 250);
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [self.session startRunning];
    
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"%s",__func__);
    if (metadataObjects.count>0) {
        
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        
        //停止扫描
        [self.session stopRunning];
        
        
        //跳转控制器
        WebVC *webVC = [[WebVC alloc] init];
        webVC.urlString = metadataObject.stringValue;
        [self.navigationController pushViewController:webVC animated:YES];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
