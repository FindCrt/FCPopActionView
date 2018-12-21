//
//  FCPopDisplayer.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCPopActionViewDef.h"
#import "UIView+FCPopDisplayer.h"

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

/** 弹框下的背景视图 */
@property (nonatomic, readonly) UIView *bgView;

/** 弹框视图 */
@property (nonatomic) UIView *popView;
/** 委托对象 */
@property (nonatomic) id<FCPopDisplayDelegate> delegate;

/** 子类需要调用super */
-(void)show;
-(void)hide;

/** 是否可显示 */
-(BOOL)canDisplay;

/** 定位弹框显示时的位置和大小，弹框大小变化后可能需要调用 */
-(void)locatePopView;

@end


#pragma mark - 默认子类

@interface FCPopDisplayer_screenEdge : FCPopDisplayer

/** 和屏幕的间距 */
@property (nonatomic) CGFloat gapSpace;

@end




typedef NS_ENUM(NSInteger, FCPopDisplayerAnimType) {
    FCPopDisplayerAnimTypeScaleAndFade,
    FCPopDisplayerAnimTypeScale,
    FCPopDisplayerAnimTypeFade,
};

/** 从一点或一个小区域触发弹窗，类似微信右上角“+”，Xcode的补全提示框等*/
@interface FCPopDisplayer_point : FCPopDisplayer

/** 是否显示箭头 */
@property (nonatomic) BOOL showArrow;
/** 箭头的大小,默认为(15, 10); 注意会受到弹框view的scale因素影响 */
@property (nonatomic) CGSize arrowSize;


/** 触发弹框的view */
@property (nonatomic) UIView *triggerView;
/** 触发点在window坐标系下的位置 */
@property (nonatomic) CGPoint triggerPoint;

/** 弹框是否重叠triggerView */
@property (nonatomic) BOOL overlap;

/**
 设置如果超出屏幕，则缩小size挤压在屏幕内
 @param handler 大小被改变时的回调
 */
-(void)squeezeByScreenWithSizeChangedHandler:(void(^)(FCPopDisplayer_point *displayer))handler;
/** 边距 */
@property (nonatomic) UIEdgeInsets margins;


/** 动画形式 */
@property (nonatomic) FCPopDisplayerAnimType animationType;
/** 缩放动画的其实缩放程度，默认0.3 */
@property (nonatomic) float startScale;

@end



@interface FCPopDisplayer_center : FCPopDisplayer

/** 这两个参数同CASpringAnimation, 修改这些数据调节弹出动画效果 */
@property (nonatomic) CGFloat stiffness;
@property (nonatomic) CGFloat damping;

@end
