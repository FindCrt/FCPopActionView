//
//  FCPopDisplayer.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCPopActionViewDef.h"

/** 默认的一些常用显示弹框的方式 */
typedef NS_ENUM(NSInteger, FCPopDisplayType) {
    ///从屏幕的边缘进来，如系统的actionSheet样式
    FCPopDisplayTypeScreenEdge,
    ///从某个点弹出，如微信右上角加号"+"弹框
    FCPopDisplayTypePoint,
    ///显示在屏幕中间，如系统的alertView样式
    FCPopDisplayTypeCenter,
};

/** 显示弹框的位置，配合显示类型使用 */
typedef NS_ENUM(NSInteger, FCPopDisplayPosition) {
    ///自动计算
    FCPopDisplayPositionAuto,
    ///顶部
    FCPopDisplayPositionTop,
    ///左侧
    FCPopDisplayPositionLeft,
    ///底部
    FCPopDisplayPositionBottom,
    ///右侧
    FCPopDisplayPositionRight,
};

@interface FCPopDisplayer : NSObject

/** 构建默认类型的工厂方法 */
+(instancetype)displayerWithType:(FCPopDisplayType)type position:(FCPopDisplayPosition)position;

@property (nonatomic) FCPopDisplayPosition position;

/** 显示的动画时间，默认0.25s */
@property (nonatomic) float duration;

/** 触发弹框的view，对于point类型有用 */
@property (nonatomic) UIView *triggerView;

/** 弹框下的背景视图 */
@property (nonatomic, readonly) UIView *bgView;

-(void)show;
-(void)hide;

@property (nonatomic) UIView *popView;
@property (nonatomic) id<FCPopDisplayDelegate> delegate;

@end
