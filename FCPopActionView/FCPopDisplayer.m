//
//  FCPopDisplayer.m
//  UIView<FCPopDisplayDelegate>
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import "FCPopDisplayer.h"

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kBGViewAlpha 0.5f

#pragma mark - 从屏幕边缘进入

@interface FCPopDisplayer_screenEdge : FCPopDisplayer

@end

@implementation FCPopDisplayer_screenEdge

-(void)show{
    if (!self.popView) {
        return;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:self.bgView];
    self.bgView.alpha = 0;
    
    UIView *popView = self.popView;
    [keyWindow addSubview:popView];
    
    if (self.position == FCPopDisplayPositionBottom) {
        
        popView.frame = CGRectMake(kScreenWidth/2.0-popView.frame.size.width/2.0, kScreenHeight, popView.frame.size.width, popView.frame.size.height);
        
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = popView.frame;
            frame.origin.y -= frame.size.height;
            popView.frame = frame;
            
            self.bgView.alpha = kBGViewAlpha;
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(popViewDidShow:)]) {
                [self.delegate popViewDidShow:popView];
            }
        }];
    }
}

-(void)hide{
    
    UIView *popView = self.popView;
    
    if (self.position == FCPopDisplayPositionBottom) {
        
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = popView.frame;
            frame.origin.y += frame.size.height;
            popView.frame = frame;
            
            self.bgView.alpha = 0;
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(popViewDidHide:)]) {
                [self.delegate popViewDidHide:popView];
            }
        }];
    }
}

@end

#pragma mark - 从某个点弹出

@interface FCPopDisplayer_point : FCPopDisplayer

@end

@implementation FCPopDisplayer_point

@end

#pragma mark - 显示在屏幕中央

@interface FCPopDisplayer_center : FCPopDisplayer

@end

@implementation FCPopDisplayer_center

@end


#pragma mark - 基类

@interface FCPopDisplayer ()
@property (nonatomic) UIView *bgView;
@end

@implementation FCPopDisplayer

+(instancetype)displayerWithType:(FCPopDisplayType)type position:(FCPopDisplayPosition)position{
    
    if (type == FCPopDisplayTypeScreenEdge) {
        FCPopDisplayer_screenEdge *displayer = [[FCPopDisplayer_screenEdge alloc] init];
        displayer.position = position;
        return displayer;
    }else if (type == FCPopDisplayTypePoint){
        FCPopDisplayer_point *displayer = [[FCPopDisplayer_point alloc] init];
        displayer.position = position;
        return displayer;
    }else if (type == FCPopDisplayTypeCenter){
        FCPopDisplayer_center *displayer = [[FCPopDisplayer_center alloc] init];
        displayer.position = position;
        return displayer;
    }
    
    return nil;
}

-(instancetype)init{
    if (self = [super init]) {
        _duration = 0.25f;
    }
    return self;
}

///基类不做任何处理
-(void)show{
    
}

///基类不做任何处理
-(void)hide{
    
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = kBGViewAlpha;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tap];
    }
    
    return _bgView;
}

@end
