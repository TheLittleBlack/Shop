//
//  UIBarButtonItem+customItem.m
//  BuDeJie
//
//  Created by JianRen on 17/1/16.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import "UIBarButtonItem+customItem.h"

@implementation UIBarButtonItem (customItem)

+(instancetype)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName withTarget:(id)target action:(SEL)action
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if(highImageName)
    {
        [btn setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    }
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
    UIView *view =[[UIView alloc]initWithFrame:btn.bounds];
    [view addSubview:btn];
    
    return [[UIBarButtonItem alloc]initWithCustomView:view];
}


+(instancetype)BackButtonItemWithTarget:(id)target action:(SEL)action
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"navigationButtonReturnClick_15x21_"] forState:UIControlStateNormal];
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16.5];
    [backBtn sizeToFit];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    return [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

@end
