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
