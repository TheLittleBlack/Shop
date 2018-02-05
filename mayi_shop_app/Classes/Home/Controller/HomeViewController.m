//
//  HomeViewController.m
//  mayi_shop_app
//
//  Created by JayJay on 2018/1/24.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "HomeViewController.h"

#define ADTime 3  //广告时间

@interface HomeViewController ()

@property(nonatomic,strong)UIButton *daoJiShiButton;
@property(nonatomic,strong)UIImageView *imageView ;
@property(nonatomic,strong)UIWindow *window;
@property(nonatomic,weak)NSTimer *timer;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLoadImage];
    // 清空暂存的 outTradeNo
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"outTradeNo"];
    
}

-(void)addLoadImage
{
    
    self.window = [UIApplication sharedApplication].keyWindow;
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_splash"]];
    [self.window addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight);
        make.center.equalTo(self.window);
        
    }];
    self.imageView.userInteractionEnabled = YES;
    
    [self createButton];
    
}

#pragma mark 创建按钮
-(void)createButton
{
    _daoJiShiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _daoJiShiButton.frame = CGRectMake(ScreenWidth-85, 20, 70, 36);
    _daoJiShiButton.backgroundColor = MyColor(0, 0, 0, 0.5);
    _daoJiShiButton.layer.cornerRadius = 18;
    _daoJiShiButton.layer.masksToBounds = YES;
    _daoJiShiButton.layer.borderWidth = 1.5;
    _daoJiShiButton.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor;
    [_daoJiShiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_daoJiShiButton setTitle:[NSString stringWithFormat:@"跳过  %d",ADTime] forState:UIControlStateNormal];
    _daoJiShiButton.titleLabel.font = [UIFont systemFontOfSize:15.5];
    [_daoJiShiButton addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchDown];
    [self.imageView addSubview:_daoJiShiButton];
    
    //创建定时器
    [self createTimer];
    
}

#pragma mark 创建定时器
-(void)createTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daoJiShi:) userInfo:nil repeats:YES];
}


//定时器响应事件
-(void)daoJiShi:(NSTimer *)sender
{
    
    static int i = ADTime;
    
    if(i<=0)
    {
        return ;
    }
    
    i--;
    [_daoJiShiButton setTitle:[NSString stringWithFormat:@"跳过  %d",i] forState:UIControlStateNormal];
    if(i==0)
    {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //延时1秒后移除
            [self goToHome];
            
        });
        
    }
}

-(void)goToHome
{
    [self.timer invalidate];
    self.timer = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
     
        self.imageView.alpha = 0;
        self.imageView.My_x = -(self.view.My_Width * 0.4)/2;
        self.imageView.My_y = -(self.view.My_Height * 0.4)/2;
        self.imageView.My_Width = self.view.My_Width * 1.4;
        self.imageView.My_Height = self.view.My_Height *1.4;
        
    } completion:^(BOOL finished) {
        
        [self.imageView removeFromSuperview];
        
    }];
    
    
    
}

//// 设置cookie
//- (void)setCookie:(NSString *)token{
//
//    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//    [cookieProperties setObject:@"ASESSIONID" forKey:NSHTTPCookieName];
//    [cookieProperties setObject:token forKey:NSHTTPCookieValue];
//    [cookieProperties setObject:MainURL forKey:NSHTTPCookieDomain];
//    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
//    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
//    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:60*60*24] forKey:NSHTTPCookieExpires];
//
//    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
//}




@end
