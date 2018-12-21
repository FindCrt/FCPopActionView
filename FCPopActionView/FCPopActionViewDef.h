//
//  FCPopActionViewDef.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#ifndef FCPopActionViewDef_h
#define FCPopActionViewDef_h

@class FCPopItemController;

@protocol FCPopDisplayDelegate<NSObject>

@optional
/** 显示完成 */
-(void)popViewDidShow:(UIView *)view;
/** 隐藏完成 */
-(void)popViewDidHide:(UIView *)view;

@end


@class FCPopActionView;
@protocol FCPopActionViewDelegate<NSObject>

/**
 提供对应数据的控制器
 
 @param actionView 弹出的动作视图
 @param item 数据
 @return 数据对应的控制器
 */
-(FCPopItemController *)popActionView:(FCPopActionView *)actionView itemControllerForItem:(id)item;


/**
 某一项被点击时调用

 @param actionView 弹出的动作视图
 @param itemView 被点击的视图
 @param controller 相关的控制器
 */
-(void)popActionView:(FCPopActionView *)actionView clickedItemView:(UIView *)itemView relatedController:(FCPopItemController *)controller;

@end

/**
 * 布局的准则；一般按内容布局，即该展开的展开该显示的显示，就是第1种方式；但考虑到太大被屏幕遮挡，需要压缩大小，这时是总大小根据屏幕确定，要跟随这个伸缩滚动区域大小，就是第2种方式。
 * 一种由内像外布局，一种由外向内
 */
typedef NS_ENUM(NSInteger, FCPopLayoutNorm) {
    ///依据内容布局，按内容展开，最后修改ActionView的大小
    FCPopLayoutNormContent,
    ///依据已设定frame来布局，ActionView的大小不变，逐层往内布局，最后通过伸缩滚动区域的大小来布局
    FCPopLayoutNormSettedFrame,
};


/** 每一项的选择类型 */
typedef NS_ENUM(NSInteger, FCPopSelectType) {
    ///点击响应方法，但不被选中
    FCPopSelectTypeClick,
    ///点击会被选中
    FCPopSelectTypeSelectable,
    ///无交互，点击不响应方法
    FCPopSelectTypeDisable,
};

@protocol FCPopItemSelectable <NSObject>
/** 提供选择类型 */
-(FCPopSelectType)selectType;
/** 选中状态变化，修改itemView的样式 */
-(void)selectStateChanged:(BOOL)selected;

@end

#endif /* FCPopActionViewDef_h */
