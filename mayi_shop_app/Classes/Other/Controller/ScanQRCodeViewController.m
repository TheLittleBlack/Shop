//
//  ScanQRCodeViewController.m
//  mayi_shop_app
//
//  Created by JayJay on 2018/1/28.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIBarButtonItem+customItem.h"
#import "ScanCodeBuyViewController.h"
#import "ScanAddToCartViewController.h"

/**
 *  屏幕 高 宽 边界
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds

#define TOP (SCREEN_HEIGHT-220)/2
#define LEFT (SCREEN_WIDTH-220)/2

#define kScanRect CGRectMake(LEFT, TOP - 64, 220, 220)

@interface ScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
    BOOL isAddView;
}

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (strong,nonatomic)UIImageView *QRLogin;
@property (nonatomic, strong) UIImageView * line;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [Hud showLoading];
    
    self.title = @"扫一扫";
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setBarButtonItem];
    

    
    
}

-(void)setBarButtonItem
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BackButtonItemWithTarget:self action:@selector(back)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"image222"] style:UIBarButtonItemStylePlain target:self action:@selector(choosePicture)];
    
}


-(void)configView{
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), ScreenWidth, 50)];
    label.text = @"将二维码放进框内，即可自动扫描";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    
//    [self.view addSubview:self.QRLogin];
//    [self.QRLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//        make.height.and.width.mas_equalTo(40);
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(label.mas_bottom).with.offset(22);
//
//    }];
    
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}


-(UIImageView *)QRLogin
{
    if(!_QRLogin)
    {
        _QRLogin = [UIImageView new];
        _QRLogin.image = [UIImage imageNamed:@"We"];
    }
    return _QRLogin;
}



-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (2*num == 200) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


//黑色背景
- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    
    
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
}

- (void)setupCamera
{
    

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        [Hud stop];
        
        return;
    }
    
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域
    CGFloat top = (TOP-64)/SCREEN_HEIGHT;
    CGFloat left = LEFT/SCREEN_WIDTH;
    CGFloat width = 220/SCREEN_WIDTH;
    CGFloat height = 220/SCREEN_HEIGHT;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top ,left , height, width)];
    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    
    NSArray *typeArray = @[AVMetadataObjectTypeQRCode,// 二维码
                           AVMetadataObjectTypeCode128Code, // 条形码
                           ];
    // 类型
    [_output setMetadataObjectTypes:typeArray];

    // 所有条形码类型
//    AVMetadataObjectTypeEAN13Code,
//    AVMetadataObjectTypeEAN8Code,
//    AVMetadataObjectTypeUPCECode,
//    AVMetadataObjectTypeCode39Code,
//    AVMetadataObjectTypeCode39Mod43Code,
//    AVMetadataObjectTypeCode93Code,
//    AVMetadataObjectTypeCode128Code,
//    AVMetadataObjectTypePDF417Code
    
    

    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
    
    if(!isAddView)
    {
        [self configView];
        isAddView = YES;
    }
    
    [Hud stop];
    
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        [timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        MyLog(@"扫描结果：%@",stringValue);
        
        //        NSArray *arry = metadataObject.corners;
        //        for (id temp in arry) {
        //            MyLog(@"%@",temp);
        //        }
        

        
        [self dealQRString:stringValue];
        
        
    }
    
    
}

//处理扫描到的信息
-(void)dealQRString:(NSString *)QRString
{
    
    BOOL canAddToCart = [[NSUserDefaults standardUserDefaults] boolForKey:@"canAddToCart"];
    
    // 判断扫描结果  http://test.m.mayi118.com/scan_code_purchase/index/sc/100013
    if([QRString containsString:@"http://"])
    {

        ScanCodeBuyViewController *SMGVC = [ScanCodeBuyViewController new];
        SMGVC.urlString = QRString;
        [self.navigationController pushViewController:SMGVC animated:YES];
    
    }
    else if(canAddToCart)
    {
        
        ScanAddToCartViewController *SATC = [ScanAddToCartViewController new];
        SATC.urlString = [NSString stringWithFormat:@"%@%@",[MayiURLManage MayiWebURLManageWithURL:ScanAddToCard],QRString];
        [self.navigationController pushViewController:SATC animated:YES];
        

    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先扫描门店二维码，进入门店购买商品！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_session startRunning];
                timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
            });
            


        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    

    
    

    
    
    
    
    
}

//选择相片
-(void)choosePicture
{
    
    UIImagePickerController *imagrPicker = [[UIImagePickerController alloc]init];
    imagrPicker.delegate = self;
    imagrPicker.allowsEditing = YES;
    //将来源设置为相册
    imagrPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagrPicker animated:YES completion:nil];
    
    
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取选中的照片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //初始化  将类型设置为二维码
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //设置数组，放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(image)]];
        //判断是否有数据（即是否是二维码）
        if (features.count >= 1)
        {
            //取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature *feature = features[0];
            NSString *scannedResult = feature.messageString;
            //处理二维码信息
            [self dealQRString:scannedResult];
        }
        //不是二维码
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"这好像不是二维码" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"搞错了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
    }];
}

//点击取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
        [timer fire];
        
    }];
    
}

//由于要写两次，所以就封装了一个方法
-(void)alertControllerMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self setCropRect:kScanRect];
    
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopTimer];
    
    [self removeView];
    
    
}

//移除扫描的相关控件
-(void)removeView
{
    [_session stopRunning];
    [_preview removeFromSuperlayer];
    [cropLayer removeFromSuperlayer];
    _preview = nil;
    _session = nil;
    cropLayer = nil;
}

//停止定时器
-(void)stopTimer
{
    [timer invalidate];
    timer = nil;
}

-(void)dealloc
{
    
}

@end
