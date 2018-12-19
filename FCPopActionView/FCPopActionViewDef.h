//
//  FCPopActionViewDef.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#ifndef FCPopActionViewDef_h
#define FCPopActionViewDef_h

#import "FCPopItemController.h"

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
 
 @param actionView 弹出的操作视图
 @param item 数据
 @return 数据对应的控制器
 */
-(FCPopItemController *)popActionView:(FCPopActionView *)actionView itemControllerForItem:(id)item;

@end


#endif /* FCPopActionViewDef_h */
