//
//  UIBarButtonItem+customItem.h
//  BuDeJie
//
//  Created by JianRen on 17/1/16.
//  Copyright © 2017年 伟健. All rights reserved.
//




#import <UIKit/UIKit.h>

@interface UIBarButtonItem (customItem)

/*
 
 通过图片快速创建自定义BarButtonItem 带有Button所有的功能 并且点击范围跟图片大小一致
 将一个普通button添加到view上 再将view包装成BarButtonItem
 如果直接将button包装成BarButtonItem 它的点击范围变得异常
 
 */
+(instancetype)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName withTarget:(id)target action:(SEL)action;


// 快速创建返回按钮
+(instancetype)BackButtonItemWithTarget:(id)target action:(SEL)action;

@end
