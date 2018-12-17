//
//  UIView+Border.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/13.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import "UIView+Border.h"
#import <objc/runtime.h>

static NSString *FCBorderLayerKey = @"FCBorderLayerKey";
static NSString *FCBorderMaskName = @"FCBorderMaskName";

@implementation UIView (Border)

///两个layer，一个实现边框线，一个切掉圆角外的内容的mask；
//mask是属性，本身唯一，用名字标记即可；边框线layer通过runtime关联变量来做标记
-(void)markFCBorder:(CALayer *)layer{
    [self removeFCBorder];
    
    objc_setAssociatedObject(self, &FCBorderLayerKey, layer, OBJC_ASSOCIATION_RETAIN);
}

-(void)removeFCBorder{
    if ([self.layer.mask.name isEqualToString:FCBorderMaskName]) {
        self.layer.mask = nil;
    }
    
    CAShapeLayer *oldLayer = objc_getAssociatedObject(self, &FCBorderLayerKey);
    if (oldLayer) [oldLayer removeFromSuperlayer];
}

-(void)addBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth andPostion:(FCBorderPosition)position corners:(UIRectCorner)corners radius:(CGFloat)radius{
    
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.strokeColor = color.CGColor;
    shape.lineWidth = borderWidth;
    shape.frame = CGRectMake(borderWidth/2.0, borderWidth/2.0, self.bounds.size.width-borderWidth, self.bounds.size.height-borderWidth);
    [self.layer addSublayer:shape];
    
    [self markFCBorder:shape];
    
    //去掉圆角外多余的
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.frame = self.bounds;
    mask.name = FCBorderMaskName;
    self.layer.mask = mask;
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    CGFloat width = shape.frame.size.width;
    CGFloat height = shape.frame.size.height;
    
    //上边
    if (position & FCBorderPositionTop) {
        [path moveToPoint:CGPointMake(radius, 0)];
        [path addLineToPoint:CGPointMake(width-radius, 0)];
    }
    //右边
    if (position & FCBorderPositionRight) {
        [path moveToPoint:CGPointMake(width, radius)];
        [path addLineToPoint:CGPointMake(width, height-radius)];
    }
    //左边
    if (position & FCBorderPositionLeft) {
        [path moveToPoint:CGPointMake(0, radius)];
        [path addLineToPoint:CGPointMake(0, height-radius)];
    }
    //底边
    if (position & FCBorderPositionBottom) {
        [path moveToPoint:CGPointMake(radius, height)];
        [path addLineToPoint:CGPointMake(width-radius, height)];
    }
    
    UIRectCorner maskCorner = 0;
    
    //右上角
    if ((position & FCBorderPositionTop) && (position & FCBorderPositionRight) && (corners & UIRectCornerTopRight)) { //使用圆角
        
        [path moveToPoint:CGPointMake(width, radius)];
        [path addArcWithCenter:CGPointMake(width-radius, radius) radius:radius startAngle:0 endAngle:-M_PI_2 clockwise:0];
        
        maskCorner |= UIRectCornerTopRight;
    }else {
        if (position & FCBorderPositionRight){
            [path moveToPoint:CGPointMake(width, radius)];
            [path addLineToPoint:CGPointMake(width, 0)];
        }
        if (position & FCBorderPositionTop) {
            [path moveToPoint:CGPointMake(width, 0)];
            [path addLineToPoint:CGPointMake(width-radius, 0)];
        }
    }
    
    //左上角
    if ((position & FCBorderPositionTop) && (position & FCBorderPositionLeft) && (corners & UIRectCornerTopLeft)) {
        
        [path moveToPoint:CGPointMake(radius, 0)];
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:-M_PI_2 endAngle:M_PI clockwise:0];
        
        maskCorner |= UIRectCornerTopLeft;
    }else{
        if (position & FCBorderPositionTop) {
            [path moveToPoint:CGPointMake(radius, 0)];
            [path addLineToPoint:CGPointMake(0, 0)];
        }
        if (position & FCBorderPositionLeft) {
            [path moveToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(0, radius)];
        }
    }
    
    //左下角
    if ((position & FCBorderPositionBottom) && (position & FCBorderPositionLeft) && (corners & UIRectCornerBottomLeft)) {
        
        [path moveToPoint:CGPointMake(0, height-radius)];
        [path addArcWithCenter:CGPointMake(radius, height-radius) radius:radius startAngle:M_PI endAngle:M_PI_2 clockwise:0];
        
        maskCorner |= UIRectCornerBottomLeft;
    }else{
        if (position & FCBorderPositionLeft) {
            [path moveToPoint:CGPointMake(0, height-radius)];
            [path addLineToPoint:CGPointMake(0, height)];
        }
        if (position & FCBorderPositionBottom) {
            [path moveToPoint:CGPointMake(0, height)];
            [path addLineToPoint:CGPointMake(radius, height)];
        }
    }
    
    //右下角
    if ((position & FCBorderPositionBottom) && (position & FCBorderPositionRight) && (corners & UIRectCornerBottomLeft)) {
        
        [path moveToPoint:CGPointMake(width-radius, height)];
        [path addArcWithCenter:CGPointMake(width-radius, height-radius) radius:radius startAngle:M_PI_2 endAngle:0 clockwise:0];
        
        maskCorner |= UIRectCornerBottomRight;
    }else{
        if (position & FCBorderPositionBottom) {
            [path moveToPoint:CGPointMake(width-radius, height)];
            [path addLineToPoint:CGPointMake(width, height)];
        }
        if (position & FCBorderPositionRight) {
            [path moveToPoint:CGPointMake(width, height)];
            [path addLineToPoint:CGPointMake(width, height-radius)];
        }
    }
    
    shape.path = [path CGPath];
    mask.path = [[UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:maskCorner cornerRadii:CGSizeMake(radius, radius)] CGPath];
}

-(void)addArrowBorderAt:(FCBorderPosition)direction offset:(CGFloat)offset width:(CGFloat)width height:(CGFloat)height cornerRadius:(CGFloat)cornerRadius{
    
    //只有一个mask层
    CAShapeLayer *mask = [[CAShapeLayer alloc] init];
    mask.frame = self.bounds;
    mask.name = FCBorderMaskName;
    self.layer.mask = mask;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat minX = 0, minY = 0, maxX = self.bounds.size.width, maxY = self.bounds.size.height;
    if (direction == FCBorderPositionTop) {
        minY = height;
    }else if (direction == FCBorderPositionRight){
        maxX -= height;
    }else if (direction == FCBorderPositionLeft){
        minX += height;
    }else if (direction == FCBorderPositionBottom){
        maxY -= height;
    }
    
    //上边
    [path moveToPoint:CGPointMake(minX+cornerRadius, minY)];
    if (direction == FCBorderPositionTop) {
        [path addLineToPoint:CGPointMake(offset-width/2, minY)];
        [path addLineToPoint:CGPointMake(offset, minY-height)];
        [path addLineToPoint:CGPointMake(offset+width/2, minY)];
    }
    [path addLineToPoint:CGPointMake(maxX-cornerRadius, minY)];
    
    //右上角
    if (cornerRadius>0) {
        [path addArcWithCenter:CGPointMake(maxX-cornerRadius, minY+cornerRadius) radius:cornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    }
    
    
    
    //右边
    if (direction == FCBorderPositionRight) {
        [path addLineToPoint:CGPointMake(maxX, offset-width/2)];
        [path addLineToPoint:CGPointMake(maxX+height, offset)];
        [path addLineToPoint:CGPointMake(maxX, offset+width/2)];
    }
    [path addLineToPoint:CGPointMake(maxX, maxY-cornerRadius)];
    
    //右下角
    if (cornerRadius>0) {
        [path addArcWithCenter:CGPointMake(maxX-cornerRadius, maxY-cornerRadius) radius:cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    }
    
    
    
    //下边
    if (direction == FCBorderPositionBottom) {
        [path addLineToPoint:CGPointMake(offset-width/2, maxY)];
        [path addLineToPoint:CGPointMake(offset, maxY+height)];
        [path addLineToPoint:CGPointMake(offset+width/2, maxY)];
    }
    [path addLineToPoint:CGPointMake(minX+cornerRadius, maxY)];
    
    //左下角
    if (cornerRadius>0) {
        [path addArcWithCenter:CGPointMake(minX+cornerRadius, maxY-cornerRadius) radius:cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    }
    
    
    //右边
    if (direction == FCBorderPositionLeft) {
        [path addLineToPoint:CGPointMake(minX, offset-width/2)];
        [path addLineToPoint:CGPointMake(minX-height, offset)];
        [path addLineToPoint:CGPointMake(minX, offset+width/2)];
    }
    [path addLineToPoint:CGPointMake(minX, minY+cornerRadius)];
    
    //右下角
    if (cornerRadius>0) {
        [path addArcWithCenter:CGPointMake(minX+cornerRadius, minY+cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:M_PI_2*3 clockwise:YES];
    }
    
    mask.path = [path CGPath];
}


@end
