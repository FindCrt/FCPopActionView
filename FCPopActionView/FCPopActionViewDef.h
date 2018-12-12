//
//  FCPopActionViewDef.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#ifndef FCPopActionViewDef_h
#define FCPopActionViewDef_h

@protocol FCPopDisplayDelegate<NSObject>

@optional
/** 显示完成 */
-(void)popViewDidShow:(UIView *)view;
/** 隐藏完成 */
-(void)popViewDidHide:(UIView *)view;

@end


#endif /* FCPopActionViewDef_h */
