//
//  BaseViewController.m
//  mayi_shop_app
//
//  Created by JayJay on 2018/1/24.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"新零兽";
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_xiaoxi01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonAction)];
    
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_xiaoxi01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(scanButtonAction)];
    
    
    self.navigationItem.rightBarButtonItems = @[searchButton,scanButton];
    
    
}

-(void)searchButtonAction
{
    MyLog(@"查找");
}

-(void)scanButtonAction
{
    MyLog(@"扫一扫");
}

@end
