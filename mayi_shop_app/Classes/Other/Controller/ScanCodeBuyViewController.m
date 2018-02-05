//
//  ScanCodeBuyViewController.m
//  mayi_shop_app
//
//  Created by JayJay on 2018/2/2.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "ScanCodeBuyViewController.h"

@interface ScanCodeBuyViewController ()

@end

@implementation ScanCodeBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 扫码进入到门店后，允许扫描条形码
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"canAddToCart"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"navigationButtonReturnClick_15x21_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
}

-(void)dealloc
{
    
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"canAddToCart"];
    
    
}


-(void)backAction
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"canAddToCart"];
    [self.navigationController popToRootViewControllerAnimated:YES];

}


@end
