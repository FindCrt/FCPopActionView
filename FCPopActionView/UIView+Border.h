//
//  UIView+Border.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/13.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 边框位置 */
typedef NS_ENUM(NSInteger, FCBorderPosition) {
    FCBorderPositionTop     = 1 << 0,
    FCBorderPositionLeft    = 1 << 1,
    FCBorderPositionBottom  = 1 << 2,
    FCBorderPositionRight   = 1 << 3,
};

@interface UIView (Border)


/**
 添加边框并设置圆角
 
 @param color 颜色
 @param borderWidth 宽度
 @param position 哪些边加边框
 @param corners 哪些叫加圆角
 @param radius 圆角的半径
 */
- (void)addBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth andPostion:(FCBorderPosition)position corners:(UIRectCorner)corners radius:(CGFloat)radius;

/** 移除之前的边框 */
-(void)removeFCBorder;


/**
 给view添加一个带箭头的边框
 
 @param direction 箭头朝向
 @param offset 箭头的坐标，如果是在左右朝向，传箭头中心位置的y值；如果是上下朝向，传箭头中心位置x值
 @param width 箭头的宽度
 @param height 箭头的高度
 @param cornerRadius 圆角半径，<=0不设圆角
 */
- (void)addArrowBorderAt:(FCBorderPosition)direction offset:(CGFloat)offset width:(CGFloat)width height:(CGFloat)height cornerRadius:(CGFloat)cornerRadius;


@end
