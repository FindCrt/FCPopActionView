//
//  FCPopDisplayer.m
//  UIView<FCPopDisplayDelegate>
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import "FCPopDisplayer.h"
#import "UIView+Border.h"

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kBGViewAlpha 0.5f

@interface FCPopDisplayer ()
@property (nonatomic) UIView *bgView;

-(void)showCompleted;
-(void)hideCompleted;
@end

#pragma mark - 从屏幕边缘进入

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
    
    id completion = ^(BOOL finished){
        [self showCompleted];
    };
    
    if (self.position == FCPopDisplayPositionBottom) {
        
        popView.frame = CGRectMake(kScreenWidth/2.0-popView.frame.size.width/2.0, kScreenHeight, popView.frame.size.width, popView.frame.size.height);
        
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = popView.frame;
            frame.origin.y -= frame.size.height;
            popView.frame = frame;
            
            self.bgView.alpha = kBGViewAlpha;
        } completion:completion];
        
    }else if (self.position == FCPopDisplayPositionTop){
        popView.frame = CGRectMake(kScreenWidth/2.0-popView.frame.size.width/2.0, -popView.frame.size.height, popView.frame.size.width, popView.frame.size.height);
        
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = popView.frame;
            frame.origin.y = 0;
            popView.frame = frame;
            
            self.bgView.alpha = kBGViewAlpha;
        } completion:completion];
        
    }else if (self.position == FCPopDisplayPositionLeft){
        popView.frame = CGRectMake(-popView.frame.size.width, kScreenHeight/2.0-popView.frame.size.height/2.0, popView.frame.size.width, popView.frame.size.height);
        
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = popView.frame;
            frame.origin.x += frame.size.width;
            popView.frame = frame;
            
            self.bgView.alpha = kBGViewAlpha;
        } completion:completion];
        
    }else if (self.position == FCPopDisplayPositionRight){
        popView.frame = CGRectMake(kScreenWidth, kScreenHeight/2.0-popView.frame.size.height/2.0, popView.frame.size.width, popView.frame.size.height);
        
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = popView.frame;
            frame.origin.x -= frame.size.width;
            popView.frame = frame;
            
            self.bgView.alpha = kBGViewAlpha;
        } completion:completion];
    }
}

-(void)hide{
    
    UIView *popView = self.popView;
    
    id completion = ^(BOOL finished){
        [self.bgView removeFromSuperview];
        [self.popView removeFromSuperview];
        [self hideCompleted];
    };
    
    if (self.position == FCPopDisplayPositionBottom) {
        
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = popView.frame;
            frame.origin.y += frame.size.height;
            popView.frame = frame;
            
            self.bgView.alpha = 0;
        } completion:completion];
        
    }else if (self.position == FCPopDisplayPositionTop){
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = popView.frame;
            frame.origin.y = -frame.size.height;
            popView.frame = frame;
            
            self.bgView.alpha = 0;
        } completion:completion];
        
    }else if (self.position == FCPopDisplayPositionLeft){
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = popView.frame;
            frame.origin.x -= frame.size.width;
            popView.frame = frame;
            
            self.bgView.alpha = 0;
        } completion:completion];
        
    }else if (self.position == FCPopDisplayPositionRight){
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = popView.frame;
            frame.origin.x += frame.size.width;
            popView.frame = frame;
            
            self.bgView.alpha = 0;
        } completion:completion];
    }
}

@end

#pragma mark - 从某个点弹出

@implementation FCPopDisplayer_point{
    CGRect _popViewFrame;
    CGPoint _arrowPoint;
    CGPoint _preAnchor;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrowSize = CGSizeMake(10, 10);
    }
    return self;
}

//被屏幕遮挡后的可见程度
-(float)visibleRateForFrame:(CGRect)frame{
    CGFloat size = frame.size.width*frame.size.height;
    
    CGFloat overlapW = MAX(0, MIN(kScreenWidth, CGRectGetMaxX(frame))-MAX(0, frame.origin.x));
    CGFloat overlapH = MAX(0, MIN(kScreenHeight, CGRectGetMaxY(frame))-MAX(0, frame.origin.y));
    
    return overlapH*overlapW/size;
}

-(CGRect)calculateDispFrameWithPosition:(FCPopDisplayPosition)position arrowPoint:(CGPoint *)pointP{
    
    CGRect frame = self.popView.frame;
    //转到window坐标系, self.triggerView为空，则定位到坐标原点
    CGRect triggerFrame = [self.triggerView convertRect:self.triggerView.bounds toView:[UIApplication sharedApplication].keyWindow];
    
    if (position == FCPopDisplayPositionBottom) {
        //先让弹框和触发view竖直中心线重合，如果超出屏幕，在左右移动调整
        frame.origin.x = CGRectGetMidX(triggerFrame)-frame.size.width/2.0;
        frame.origin.x = MAX(0, frame.origin.x); //防止左边超出屏幕
        //防止右边
        frame.origin.x = MIN(kScreenWidth-frame.size.width, frame.origin.x);
        
        frame.origin.y = self.overlap?CGRectGetMinY(triggerFrame):CGRectGetMaxY(triggerFrame);
        
        *pointP = CGPointMake(CGRectGetMidX(triggerFrame)-frame.origin.x, 0);
        
    }else if (position == FCPopDisplayPositionTop){
        
        //先让弹框和触发view竖直中心线重合，如果超出屏幕，在左右移动调整
        frame.origin.x = CGRectGetMidX(triggerFrame)-frame.size.width/2.0;
        frame.origin.x = MAX(0, frame.origin.x); //防止左边超出屏幕
        //防止右边
        frame.origin.x = MIN(kScreenWidth-frame.size.width, frame.origin.x);
        
        frame.origin.y = (self.overlap?CGRectGetMaxY(triggerFrame):CGRectGetMinY(triggerFrame))-frame.size.height;
        
        *pointP = CGPointMake(CGRectGetMidX(triggerFrame)-frame.origin.x, frame.size.height);
        
    }else if (position == FCPopDisplayPositionLeft){
        frame.origin.x = (self.overlap?CGRectGetMaxX(triggerFrame):CGRectGetMinX(triggerFrame))-frame.size.width;
        
        frame.origin.y = CGRectGetMidY(triggerFrame)-frame.size.height/2.0;
        frame.origin.y = MAX(0, frame.origin.y);
        frame.origin.y = MIN(kScreenHeight-frame.size.height, frame.origin.y);
        
        *pointP = CGPointMake(frame.size.width, CGRectGetMidY(triggerFrame)-frame.origin.y);
        
    }else if (position == FCPopDisplayPositionRight){
        frame.origin.x = self.overlap?CGRectGetMinX(triggerFrame):CGRectGetMaxX(triggerFrame);
        
        frame.origin.y = CGRectGetMidY(triggerFrame)-frame.size.height/2.0;
        frame.origin.y = MAX(0, frame.origin.y);
        frame.origin.y = MIN(kScreenHeight-frame.size.height, frame.origin.y);
        
        *pointP = CGPointMake(0, CGRectGetMidY(triggerFrame)-frame.origin.y);
        
    }else if (position == FCPopDisplayPositionAuto){
        
        //最大可见度
        float maxRate = 0;
        CGRect maxRateFrame = frame;
        CGPoint point;
        
        NSArray*positions = @[@(FCPopDisplayPositionBottom), @(FCPopDisplayPositionTop), @(FCPopDisplayPositionLeft), @(FCPopDisplayPositionRight)];
        
        for (NSNumber *num in positions) {
            CGRect targetFrame = [self calculateDispFrameWithPosition:[num integerValue] arrowPoint:&point];
            float rate = [self visibleRateForFrame:targetFrame];
            
            if (rate > maxRate) {
                maxRate = rate;
                maxRateFrame = targetFrame;
                *pointP = point;
            }
            
            if (rate == 1) {
                return targetFrame;
            }
        }
        
        return maxRateFrame;
    }
    
    return frame;
}

-(void)addArrowBorderForView:(UIView *)view at:(CGPoint)arrowPoint{
    FCBorderPosition position = FCBorderPositionTop;
    CGFloat offset = 0;
    CGRect frame = view.frame;
    
    if (arrowPoint.x == 0) {
        position = FCBorderPositionLeft;
        offset = arrowPoint.y;
        
    }else if (arrowPoint.x == frame.size.width){
        position = FCBorderPositionRight;
        offset = arrowPoint.y;
        
    }else if (arrowPoint.y == 0){
        position = FCBorderPositionTop;
        offset = arrowPoint.x;
    }else if (arrowPoint.y == frame.size.height){
        position = FCBorderPositionBottom;
        offset = arrowPoint.x;
    }
    //TODO: 圆角的处理
    [view addArrowBorderAt:position offset:offset width:_arrowSize.width height:_arrowSize.height cornerRadius:0];
}

-(void)changeAnchorPoint{
    _preAnchor = self.popView.layer.anchorPoint;
    self.popView.layer.anchorPoint = CGPointMake(_arrowPoint.x/_popViewFrame.size.width, _arrowPoint.y/_popViewFrame.size.height);
    
    //修正anchorPoint修改后显示的偏移,原本锚点在中心，现在在arrowPoint
    self.popView.frame = _popViewFrame;
}

-(void)resetAnchorPoint{
    self.popView.layer.anchorPoint = _preAnchor;
    self.popView.frame = _popViewFrame;
}

-(void)show{
    
    if (!self.popView) {
        return;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:self.bgView];
    self.bgView.alpha = 0;
    
    UIView *popView = self.popView;
    [keyWindow addSubview:popView];
    
    _popViewFrame = [self calculateDispFrameWithPosition:self.position arrowPoint:&_arrowPoint];
    popView.frame = _popViewFrame;
    
    if (_showArrow && !_overlap) {
        [self addArrowBorderForView:popView at:_arrowPoint];
    }
    
    if (_animationType == FCPopDisplayerAnimTypeScale) {
        
        //TODO: spring animation
        
        CGAffineTransform preTransform = popView.transform;
        NSLog(@"1: frame: %@, trans: %@, anchor: %@",NSStringFromCGRect(popView.frame), NSStringFromCGAffineTransform(popView.transform),NSStringFromCGPoint(popView.layer.anchorPoint));
        [self changeAnchorPoint];
        NSLog(@"2: frame: %@, trans: %@, anchor: %@",NSStringFromCGRect(popView.frame), NSStringFromCGAffineTransform(popView.transform),NSStringFromCGPoint(popView.layer.anchorPoint));
        
        popView.transform = CGAffineTransformScale(popView.transform, 0.3, 0.3);
        
        [UIView animateWithDuration:self.duration animations:^{
            
            popView.transform = preTransform;
            self.bgView.alpha = kBGViewAlpha;
            
        } completion:^(BOOL finished) {
//            [self resetAnchorPoint];
            [self showCompleted];
        }];
    }
}

-(void)hide{
    UIView *popView = self.popView;
    
    if (_animationType == FCPopDisplayerAnimTypeScale) {
        CGAffineTransform preTransform = popView.transform;
        [self changeAnchorPoint];
        [UIView animateWithDuration:self.duration animations:^{
            
            popView.transform = CGAffineTransformScale(popView.transform, 0.1, 0.1);
            self.bgView.alpha = kBGViewAlpha;
            
        } completion:^(BOOL finished) {
            popView.transform = preTransform;
//            [self resetAnchorPoint];
            
            [self.bgView removeFromSuperview];
            [self.popView removeFromSuperview];
            if (self.showArrow) {
                [self.popView removeFCBorder];
            }
            [self hideCompleted];

        }];
    }
}

@end

#pragma mark - 显示在屏幕中央

@implementation FCPopDisplayer_center

@end


#pragma mark - 基类

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

-(void)showCompleted{
    if ([self.delegate respondsToSelector:@selector(popViewDidShow:)]) {
        [self.delegate popViewDidShow:self.popView];
    }
}

-(void)hideCompleted{
    if ([self.delegate respondsToSelector:@selector(popViewDidHide:)]) {
        [self.delegate popViewDidHide:self.popView];
    }
    
    self.popView = nil;
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
