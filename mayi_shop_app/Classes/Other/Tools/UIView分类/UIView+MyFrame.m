//
//  UIView+MyFrame.m
//  BuDeJie
//
//  Created by JianRen on 17/1/16.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import "UIView+MyFrame.h"

@implementation UIView (MyFrame)

- (CGFloat)My_Width{
    return self.frame.size.width;
}

- (void)setMy_Width:(CGFloat)My_Width{
    CGRect frame = self.frame;
    frame.size.width = My_Width;
    self.frame = frame;
}

- (CGFloat)My_Height{
    return self.frame.size.height;
}

- (void)setMy_Height:(CGFloat)My_Height{
    CGRect frame = self.frame;
    frame.size.height = My_Height;
    self.frame = frame;
}

- (CGFloat)My_x{
    return self.frame.origin.x;
}

- (void)setMy_x:(CGFloat)My_x{
    CGRect frame = self.frame;
    frame.origin.x = My_x;
    self.frame = frame;
}

- (CGFloat)My_y{
    return self.frame.origin.y;
}

- (void)setMy_y:(CGFloat)My_y{
    CGRect frame = self.frame;
    frame.origin.y = My_y;
    self.frame = frame;
}

- (CGFloat)My_centerX{
    return self.center.x;
}

- (void)setMy_centerX:(CGFloat)My_centerX{
    CGPoint center = self.center;
    center.x = My_centerX;
    self.center = center;
}

- (CGFloat)My_centerY{
    return self.center.y;
}

- (void)setMy_centerY:(CGFloat)My_centerY{
    CGPoint center = self.center;
    center.y = My_centerY;
    self.center = center;
}

- (CGFloat)My_right{
    
    return self.My_x + self.My_Width;
}

- (void)setMy_right:(CGFloat)My_right{
    
    self.My_x = My_right - self.My_Width;
}

- (CGFloat)My_bottom{
    
    return self.My_y + self.My_Height;
}

- (void)setMy_bottom:(CGFloat)My_bottom{
    
    self.My_y = My_bottom - self.My_Height;
}

@end
