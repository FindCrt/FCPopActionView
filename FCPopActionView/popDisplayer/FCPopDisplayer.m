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
#define kBGViewAlpha 1
#define KClip(a, min, max) (a<min?min:(a>max?max:a))

@interface FCPopDisplayer ()
@property (nonatomic) UIView *bgView;

-(void)showCompleted;
-(void)hideCompleted;
@end

#pragma mark - 从屏幕边缘进入

@implementation FCPopDisplayer_screenEdge

-(void)setPosition:(FCPopDisplayPosition)position{
    if (position == FCPopDisplayPositionAuto) {
        position = FCPopDisplayPositionBottom;
    }
    
    super.position = position;
}

-(void)show{
    [super show];
    if (![self canDisplay]) {
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
            [self locatePopView];
            
            self.bgView.alpha = kBGViewAlpha;
        } completion:completion];
        
    }else if (self.position == FCPopDisplayPositionTop){
        popView.frame = CGRectMake(kScreenWidth/2.0-popView.frame.size.width/2.0, -popView.frame.size.height, popView.frame.size.width, popView.frame.size.height);
        
        [UIView animateWithDuration:self.duration animations:^{
            [self locatePopView];
            
            self.bgView.alpha = kBGViewAlpha;
        } completion:completion];
        
    }else if (self.position == FCPopDisplayPositionLeft){
        popView.frame = CGRectMake(-popView.frame.size.width, kScreenHeight/2.0-popView.frame.size.height/2.0, popView.frame.size.width, popView.frame.size.height);
        
        [UIView animateWithDuration:self.duration animations:^{
            [self locatePopView];
            
            self.bgView.alpha = kBGViewAlpha;
        } completion:completion];
        
    }else if (self.position == FCPopDisplayPositionRight){
        popView.frame = CGRectMake(kScreenWidth, kScreenHeight/2.0-popView.frame.size.height/2.0, popView.frame.size.width, popView.frame.size.height);
        
        [UIView animateWithDuration:self.duration animations:^{
            [self locatePopView];
            
            self.bgView.alpha = kBGViewAlpha;
        } completion:completion];
    }
}

-(void)locatePopView{
    
    CGRect frame = self.popView.frame;
    CGFloat gapSpace = self.gapSpace;
    
    if (self.position == FCPopDisplayPositionBottom) {
        
        frame = CGRectMake(kScreenWidth/2.0-frame.size.width/2.0, kScreenHeight-frame.size.height-gapSpace, frame.size.width, frame.size.height);
        
    }else if (self.position == FCPopDisplayPositionTop){
        frame = CGRectMake(kScreenWidth/2.0-frame.size.width/2.0, gapSpace, frame.size.width, frame.size.height);
        
    }else if (self.position == FCPopDisplayPositionLeft){
        frame = CGRectMake(gapSpace, kScreenHeight/2.0-frame.size.height/2.0, frame.size.width, frame.size.height);
        
    }else if (self.position == FCPopDisplayPositionRight){
        frame = CGRectMake(kScreenWidth-frame.size.width-gapSpace, kScreenHeight/2.0-frame.size.height/2.0, frame.size.width, frame.size.height);
    }
    self.popView.frame = frame;
}

-(void)hide{
    [super hide];
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

@interface FCPopDisplayer_point ()
@property (nonatomic) BOOL squeezeByScreen;
@property (nonatomic) void (^squeezeHandler)(FCPopDisplayer_point *displayer);
@end

@implementation FCPopDisplayer_point{
    CGRect _displayFrame;
    CGPoint _arrowPoint;
    CGPoint _preAnchor;
    
    UIView *_borderView;
}

+(void)showPopView:(UIView *)popView triggerView:(UIView *)triggerView{
    FCPopDisplayer_point *disp = [[FCPopDisplayer_point alloc] initWithPopView:popView position:(FCPopDisplayPositionAuto)];
    disp.triggerView = triggerView;
    [disp show];
}

+(void)showPopView:(UIView *)popView triggerFrame:(CGRect)triggerFrame{
    FCPopDisplayer_point *disp = [[FCPopDisplayer_point alloc] initWithPopView:popView position:(FCPopDisplayPositionAuto)];
    disp.triggerFrame = triggerFrame;
    [disp show];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showArrow = YES;
        _arrowSize = CGSizeMake(15, 10);
        _startScale = 0.7f;
    }
    return self;
}

-(void)squeezeByScreenWithSizeChangedHandler:(void (^)(FCPopDisplayer_point *))handler{
    _squeezeByScreen = YES;
    _squeezeHandler = handler;
}

//被屏幕遮挡后的可见程度
-(float)visibleRateForFrame:(CGRect)frame margins:(UIEdgeInsets)margins{
    CGFloat size = frame.size.width*frame.size.height;
    if (size == 0) {
        return 1;
    }
    
    CGFloat overlapW = MAX(0, MIN(kScreenWidth-margins.right, CGRectGetMaxX(frame))-MAX(margins.left, frame.origin.x));
    CGFloat overlapH = MAX(0, MIN(kScreenHeight-margins.bottom, CGRectGetMaxY(frame))-MAX(margins.top, frame.origin.y));
    
    return overlapH*overlapW/size;
}

-(CGRect)squeezeFrame:(CGRect)frame{
    CGRect sqFrame;
    sqFrame.origin.x = MAX(_margins.left, frame.origin.x);
    sqFrame.size.width = MIN(kScreenWidth-_margins.right, CGRectGetMaxX(frame)) -sqFrame.origin.x;
    sqFrame.origin.y = MAX(_margins.top, frame.origin.y);
    sqFrame.size.height = MIN(kScreenHeight-_margins.bottom, CGRectGetMaxY(frame)) - sqFrame.origin.y;
    
    return sqFrame;
}

-(CGPoint)arrowPointForFrame:(CGRect)frame point:(CGPoint)point position:(FCPopDisplayPosition)position{
    CGFloat minX = _arrowSize.width/2.0;
    CGFloat maxX = frame.size.width - _arrowSize.width/2.0;
    CGFloat minY = _arrowSize.width/2.0;
    CGFloat maxY = frame.size.height - _arrowSize.width/2.0;
    
    //先转成弹框坐标系下的位置，在做范围限制，箭头的中心点不能超出弹框范围
    CGPoint arrowPoint = CGPointMake(point.x-frame.origin.x, point.y-frame.origin.y);
    arrowPoint.x = KClip(arrowPoint.x, minX, maxX);
    arrowPoint.y = KClip(arrowPoint.y, minY, maxY);
    
    //把点映射到边缘上的点；弹框在下部，则箭头在顶部
    if (position == FCPopDisplayPositionBottom) {
        arrowPoint.y = 0;
    }else if (position == FCPopDisplayPositionTop){
        arrowPoint.y = frame.size.height;
    }else if (position == FCPopDisplayPositionLeft){
        arrowPoint.x = frame.size.width;
    }else if (position == FCPopDisplayPositionRight){
        arrowPoint.x = 0;
    }
    
    return arrowPoint;
}

-(CGRect)triggerFrame{
    if (CGRectEqualToRect(_triggerFrame, CGRectZero)) {
        return [self.triggerView convertRect:self.triggerView.bounds toView:[UIApplication sharedApplication].keyWindow];
    }
    
    return _triggerFrame;
}

-(CGRect)calculateDispFrameWithPosition:(FCPopDisplayPosition)position effectivePosition:(FCPopDisplayPosition *)effPosition{
    
    *effPosition = position;
    
    CGFloat marginLeft = _margins.left;
    CGFloat marginRight = kScreenWidth-_margins.right;
    CGFloat marginTop = _margins.top;
    CGFloat marginBottom = kScreenHeight-_margins.bottom;
    
    //给箭头腾出空间
    CGFloat arrowHeight = _showArrow?_arrowSize.height:0;
    CGFloat arrowSpace = _arrowTriggerSpace;
    
    CGRect frame = _borderView.frame;
    CGRect triggerFrame = self.triggerFrame;
    
    if (position == FCPopDisplayPositionBottom) {
        //先让弹框和触发view竖直中心线重合，如果超出屏幕，在左右移动调整
        frame.origin.x = CGRectGetMidX(triggerFrame)-frame.size.width/2.0;
        frame.origin.x = MAX(marginLeft, frame.origin.x); //防止左边超出屏幕
        //防止右边
        frame.origin.x = MIN(marginRight-frame.size.width, frame.origin.x);
        
        frame.origin.y = (self.overlap?CGRectGetMinY(triggerFrame):CGRectGetMaxY(triggerFrame))+arrowSpace;
        
        //高度增加一点，把箭头本身的空间让出来
        frame.size.height += arrowHeight;
        
    }else if (position == FCPopDisplayPositionTop){
        
        //先让弹框和触发view竖直中心线重合，如果超出屏幕，在左右移动调整
        frame.origin.x = CGRectGetMidX(triggerFrame)-frame.size.width/2.0;
        frame.origin.x = MAX(marginLeft, frame.origin.x); //防止左边超出屏幕
        //防止右边
        frame.origin.x = MIN(marginRight-frame.size.width, frame.origin.x);
        
        frame.origin.y = (self.overlap?CGRectGetMaxY(triggerFrame):CGRectGetMinY(triggerFrame))-frame.size.height-arrowSpace;
        frame.size.height += arrowHeight;
        
    }else if (position == FCPopDisplayPositionLeft){
        frame.origin.x = (self.overlap?CGRectGetMaxX(triggerFrame):CGRectGetMinX(triggerFrame))-frame.size.width-arrowSpace;
        
        frame.origin.y = CGRectGetMidY(triggerFrame)-frame.size.height/2.0;
        frame.origin.y = MAX(marginTop, frame.origin.y);
        frame.origin.y = MIN(marginBottom-frame.size.height, frame.origin.y);
        frame.size.width += arrowHeight;
        
    }else if (position == FCPopDisplayPositionRight){
        frame.origin.x = (self.overlap?CGRectGetMinX(triggerFrame):CGRectGetMaxX(triggerFrame))+arrowSpace;
        
        frame.origin.y = CGRectGetMidY(triggerFrame)-frame.size.height/2.0;
        frame.origin.y = MAX(marginTop, frame.origin.y);
        frame.origin.y = MIN(marginBottom-frame.size.height, frame.origin.y);
        frame.size.width += arrowHeight;
        
    }else if (position == FCPopDisplayPositionAuto){
        
        //最大可见度
        float maxRate = 0;
        CGRect maxRateFrame = frame;
        FCPopDisplayPosition position;
        
        NSArray*positions = @[@(FCPopDisplayPositionBottom), @(FCPopDisplayPositionTop), @(FCPopDisplayPositionLeft), @(FCPopDisplayPositionRight)];
        
        for (NSNumber *num in positions) {
            CGRect targetFrame = [self calculateDispFrameWithPosition:[num integerValue] effectivePosition:&position];
            UIEdgeInsets margins = _squeezeByScreen?_margins:UIEdgeInsetsZero;
            float rate = [self visibleRateForFrame:targetFrame margins:margins];
            
            NSLog(@"%@ %.2f",@[@"auto",@"top",@"left",@"bottom",@"right"][[num integerValue]], rate);
            //才去可见度最大的方案
            if (rate > maxRate) {
                maxRate = rate;
                maxRateFrame = targetFrame;
                *effPosition = position;
            }
            
            if (rate == 1) {
                return targetFrame;
            }
        }
        
        return maxRateFrame;
    }
    
    return frame;
}

///根据箭头的位置：1. 添加箭头 2.设置popView的位置
-(void)addArrowBorderWithPosition:(FCPopDisplayPosition)position{
    
    FCBorderPosition arrowPosition = FCBorderPositionTop;
    CGFloat offset = 0;
    CGRect popviewFrame = _borderView.bounds;
    CGFloat arrowHeight = _showArrow?_arrowSize.height:0;
    
    if (position == FCPopDisplayPositionRight) {
        arrowPosition = FCBorderPositionLeft;
        offset = _arrowPoint.y;
        
        popviewFrame.origin.x += arrowHeight;
        popviewFrame.size.width -= arrowHeight;
    }else if (position == FCPopDisplayPositionLeft){
        arrowPosition = FCBorderPositionRight;
        offset = _arrowPoint.y;

        popviewFrame.size.width -= arrowHeight;
    }else if (position == FCPopDisplayPositionBottom){
        arrowPosition = FCBorderPositionTop;
        offset = _arrowPoint.x;

        popviewFrame.origin.y += arrowHeight;
        popviewFrame.size.height -= arrowHeight;
    }else if (position == FCPopDisplayPositionTop){
        arrowPosition = FCBorderPositionBottom;
        offset = _arrowPoint.x;

        popviewFrame.size.height -= arrowHeight;
    }
    
    if (_showArrow) {
        if (!_borderColor) {
            _borderColor = [UIColor colorWithCGColor:self.popView.layer.borderColor];
            _borderWidth = self.popView.layer.borderWidth;
            self.popView.layer.borderWidth = 0;
        }
        
        [_borderView addArrowBorderAt:arrowPosition offset:offset width:_arrowSize.width height:_arrowSize.height cornerRadius:self.popView.layer.cornerRadius borderWidth:_borderWidth borderColor:_borderColor];
    }
    
    CGSize preSize = self.popView.frame.size;
    self.popView.frame = popviewFrame;
    if (_squeezeByScreen && _squeezeHandler && !CGSizeEqualToSize(preSize, popviewFrame.size)) { //通知大小被压缩
        _squeezeHandler(self);
    }
}

-(void)locatePopView{
    CGRect triggerFrame = self.triggerFrame;
    CGPoint triggerCenter = CGPointMake(triggerFrame.origin.x+triggerFrame.size.width/2.0, triggerFrame.origin.y+triggerFrame.size.height/2.0);
    
    _borderView.frame = self.popView.frame;
    
    FCPopDisplayPosition effPosition;
    _displayFrame = [self calculateDispFrameWithPosition:self.position effectivePosition:&effPosition];
    if (_squeezeByScreen) {
        _displayFrame = [self squeezeFrame:_displayFrame];
    }
    _arrowPoint = [self arrowPointForFrame:_displayFrame point:triggerCenter position:effPosition];
    
    _borderView.frame = _displayFrame;
    
    [self addArrowBorderWithPosition:effPosition];
}

//修改锚点是为了scale动画可以从某点逐渐放大，而不是默认的从中心放大
-(void)changeAnchorPoint{
    _preAnchor = _borderView.layer.anchorPoint;
    _borderView.layer.anchorPoint = CGPointMake(_arrowPoint.x/_displayFrame.size.width, _arrowPoint.y/_displayFrame.size.height);
    
    _borderView.frame = _displayFrame;
}

-(void)show{
    [super show];
    if (![self canDisplay]) {
        return;
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.bgView];
    
    //因为箭头用mask实现，会切掉一部分内容，所以使用一个_borderView，它把真的popView包起来，箭头加到_borderView上，这样原本的popView就是完整的了
    _borderView = [[UIView alloc] init];
    _borderView.backgroundColor = self.popView.backgroundColor;
    [keyWindow addSubview:_borderView];
    [_borderView addSubview:self.popView];
    
    [self locatePopView];
    
    self.bgView.alpha = 0;
    UIView *displayView = _borderView;
    
    if (_animationType == FCPopDisplayerAnimTypeScale ||
        _animationType == FCPopDisplayerAnimTypeScaleAndFade) {
        
        [self changeAnchorPoint];
        
        displayView.transform = CGAffineTransformMakeScale(_startScale, _startScale);
        
        if (_animationType == FCPopDisplayerAnimTypeScaleAndFade) displayView.alpha = 0;
        
        [UIView animateWithDuration:self.duration animations:^{
            
            displayView.alpha = 1;
            displayView.transform = CGAffineTransformIdentity;
            self.bgView.alpha = kBGViewAlpha;
            
        } completion:^(BOOL finished) {
            [self showCompleted];
        }];
        
    }else if (_animationType == FCPopDisplayerAnimTypeFade){
        
        displayView.alpha = 0;
        [UIView animateWithDuration:self.duration animations:^{
            
            displayView.alpha = 1;
            self.bgView.alpha = kBGViewAlpha;
            
        } completion:^(BOOL finished) {
            [self showCompleted];
        }];
    }
}

-(void)hide{
    [super hide];
    
    UIView *displayView = _borderView;
    
    if (_animationType == FCPopDisplayerAnimTypeScale ||
        _animationType == FCPopDisplayerAnimTypeScaleAndFade) {
        
        BOOL fadeEffect = _animationType == FCPopDisplayerAnimTypeScaleAndFade;
        [UIView animateWithDuration:self.duration animations:^{
            
            if (fadeEffect) displayView.alpha = 0;
            displayView.transform = CGAffineTransformMakeScale(self->_startScale, self->_startScale);
            self.bgView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [displayView removeFromSuperview];
            [self.bgView removeFromSuperview];
            [self.popView removeFromSuperview];
            
            displayView.alpha = 1;
            displayView.transform = CGAffineTransformIdentity;
            
            [self hideCompleted];
        }];
        
    }else if (_animationType == FCPopDisplayerAnimTypeFade){
        
        [UIView animateWithDuration:self.duration animations:^{
            
            displayView.alpha = 0;
            self.bgView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [displayView removeFromSuperview];
            [self.bgView removeFromSuperview];
            [self.popView removeFromSuperview];
            displayView.alpha = 1;
            
            [self hideCompleted];
            
        }];
    }
}

-(void)hideCompleted{
    if (self.showArrow) {
//        [_borderView removeFromSuperview];
//        _borderView = nil;
    }
}

@end

#pragma mark - 显示在屏幕中央

static NSString *FCPopCenterShowAnimKey = @"FCPopCenterShowAnimKey";
static NSString *FCPopCenterHideAnimKey = @"FCPopCenterHideAnimKey";

@interface FCPopDisplayer_center ()<CAAnimationDelegate>{
    CATransform3D _preTransform;
    BOOL _showing;
}

@property (nonatomic) CASpringAnimation *showAnim;
@property (nonatomic) CABasicAnimation *hideAnim;
@end

@implementation FCPopDisplayer_center

-(instancetype)init{
    if (self = [super init]) {
        _startScale = 0.7f;
    }
    return self;
}

-(CASpringAnimation *)showAnim{
    if (!_showAnim) {
        _showAnim = [[CASpringAnimation alloc] init];
        _showAnim.duration = self.duration*2;
        _showAnim.keyPath = @"transform";
        _showAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(_preTransform, _startScale, _startScale, 1)];
        _showAnim.toValue = [NSValue valueWithCATransform3D:_preTransform];
        _showAnim.delegate = self;
        
        _showAnim.stiffness = 200;
        _showAnim.damping = 15;
    }
    
    return _showAnim;
}

-(CABasicAnimation *)hideAnim{
    if (!_hideAnim) {
        _hideAnim = [[CABasicAnimation alloc] init];
        _hideAnim.duration = self.duration;
        _hideAnim.keyPath = @"transform";
        _hideAnim.fromValue = [NSValue valueWithCATransform3D:_preTransform];
        _hideAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(_preTransform, _startScale, _startScale, 1)];
        _hideAnim.delegate = self;
        _hideAnim.removedOnCompletion = NO;
        _hideAnim.fillMode = kCAFillModeForwards;
    }
    
    return _hideAnim;
}

-(void)show{
    [super show];
    if (![self canDisplay]) {
        return;
    }
    
    _showing = YES;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:self.bgView];
    self.bgView.alpha = 0;
    
    UIView *popView = self.popView;
    [keyWindow addSubview:popView];
    
    popView.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    _preTransform = popView.layer.transform;
    
    [popView.layer addAnimation:self.showAnim forKey:FCPopCenterShowAnimKey];
    
    [UIView animateWithDuration:self.duration animations:^{
        self.bgView.alpha = kBGViewAlpha;
    }];
}

-(void)hide{
    [super hide];
    _showing = NO;
    
    [self.popView.layer addAnimation:self.hideAnim forKey:FCPopCenterHideAnimKey];
    
    [UIView animateWithDuration:self.duration animations:^{
        self.bgView.alpha = 0;
    }];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (_showing) {
        self.popView.layer.transform = _preTransform;
        [self showCompleted];
    }else{
        [self.popView.layer removeAnimationForKey:FCPopCenterHideAnimKey];
        [self.bgView removeFromSuperview];
        [self.popView removeFromSuperview];
        self.popView.layer.transform = _preTransform;
        
        [self hideCompleted];
    }
}

@end


#pragma mark - 基类

@implementation FCPopDisplayer


-(instancetype)init{
    if (self = [super init]) {
        _duration = 0.25f;
        _position = FCPopDisplayPositionBottom;
    }
    return self;
}

-(instancetype)initWithPopView:(UIView *)popView{
    return [self initWithPopView:popView position:(FCPopDisplayPositionBottom)];
}

-(instancetype)initWithPopView:(UIView *)popView position:(FCPopDisplayPosition)position{
    if (self = [self init]) {
        self.popView = popView;
        _position = position;
    }
    
    return self;
}

-(void)show{
    //用引用循环来避免自身被释放
    self.popView.displayer = self;
}

-(void)hide{
    
}

-(BOOL)canDisplay{
    if (!_popView) {
        return NO;
    }
    
    [_popView setNeedsLayout];
    [_popView layoutIfNeeded];
    if (_popView.frame.size.width == 0 || _popView.frame.size.height == 0) {
        return NO;
    }
    
    return YES;
}

-(void)locatePopView{
    
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
    
    //解除引用循环
    self.popView.displayer = nil;
    self.popView = nil;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _bgView.alpha = kBGViewAlpha;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tap];
    }
    
    return _bgView;
}

@end
