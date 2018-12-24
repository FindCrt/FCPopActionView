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
    CGRect _popViewFrame;
    CGPoint _arrowPoint;
    CGPoint _preAnchor;
    
//    UIView *_borderView;
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
        _startScale = 0.3f;
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
    CGFloat arrowSpace = _arrowTriggerSpace;
    
    CGRect frame = self.popView.frame;
    CGRect triggerFrame = self.triggerFrame;
    
    if (position == FCPopDisplayPositionBottom) {
        //先让弹框和触发view竖直中心线重合，如果超出屏幕，在左右移动调整
        frame.origin.x = CGRectGetMidX(triggerFrame)-frame.size.width/2.0;
        frame.origin.x = MAX(marginLeft, frame.origin.x); //防止左边超出屏幕
        //防止右边
        frame.origin.x = MIN(marginRight-frame.size.width, frame.origin.x);
        
        frame.origin.y = (self.overlap?CGRectGetMinY(triggerFrame):CGRectGetMaxY(triggerFrame))+arrowSpace;
        
    }else if (position == FCPopDisplayPositionTop){
        
        //先让弹框和触发view竖直中心线重合，如果超出屏幕，在左右移动调整
        frame.origin.x = CGRectGetMidX(triggerFrame)-frame.size.width/2.0;
        frame.origin.x = MAX(marginLeft, frame.origin.x); //防止左边超出屏幕
        //防止右边
        frame.origin.x = MIN(marginRight-frame.size.width, frame.origin.x);
        
        frame.origin.y = (self.overlap?CGRectGetMaxY(triggerFrame):CGRectGetMinY(triggerFrame))-frame.size.height-arrowSpace;
        
    }else if (position == FCPopDisplayPositionLeft){
        frame.origin.x = (self.overlap?CGRectGetMaxX(triggerFrame):CGRectGetMinX(triggerFrame))-frame.size.width-arrowSpace;
        
        frame.origin.y = CGRectGetMidY(triggerFrame)-frame.size.height/2.0;
        frame.origin.y = MAX(marginTop, frame.origin.y);
        frame.origin.y = MIN(marginBottom-frame.size.height, frame.origin.y);
        
    }else if (position == FCPopDisplayPositionRight){
        frame.origin.x = (self.overlap?CGRectGetMinX(triggerFrame):CGRectGetMaxX(triggerFrame))+arrowSpace;
        
        frame.origin.y = CGRectGetMidY(triggerFrame)-frame.size.height/2.0;
        frame.origin.y = MAX(marginTop, frame.origin.y);
        frame.origin.y = MIN(marginBottom-frame.size.height, frame.origin.y);
        
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
    
    [view addArrowBorderAt:position offset:offset width:_arrowSize.width height:_arrowSize.height cornerRadius:view.layer.cornerRadius];
}

//修改锚点是为了scale动画可以从某点逐渐放大，而不是默认的从中心放大
-(void)changeAnchorPoint{
    _preAnchor = self.popView.layer.anchorPoint;
    self.popView.layer.anchorPoint = CGPointMake(_arrowPoint.x/_popViewFrame.size.width, _arrowPoint.y/_popViewFrame.size.height);
    
    self.popView.frame = _popViewFrame;
}

-(void)show{
    [super show];
    if (![self canDisplay]) {
        return;
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.bgView];
    
    UIView *popView = self.popView;
    [keyWindow addSubview:popView];
    
    [self locatePopView];
    
    self.bgView.alpha = 0;
    float preAlpha = popView.alpha;
    
    if (_animationType == FCPopDisplayerAnimTypeScale ||
        _animationType == FCPopDisplayerAnimTypeScaleAndFade) {
        
        CGAffineTransform preTransform = popView.transform;
        [self changeAnchorPoint];
        
        popView.transform = CGAffineTransformScale(popView.transform, _startScale, _startScale);
        
        if (_animationType == FCPopDisplayerAnimTypeScaleAndFade) popView.alpha = 0;
        
        [UIView animateWithDuration:self.duration animations:^{
            
            popView.alpha = preAlpha;
            popView.transform = preTransform;
            self.bgView.alpha = kBGViewAlpha;
            
        } completion:^(BOOL finished) {
            [self showCompleted];
        }];
        
    }else if (_animationType == FCPopDisplayerAnimTypeFade){
        
        popView.alpha = 0;
        [UIView animateWithDuration:self.duration animations:^{
            
            popView.alpha = preAlpha;
            self.bgView.alpha = kBGViewAlpha;
            
        } completion:^(BOOL finished) {
            [self showCompleted];
        }];
    }
}

-(void)locatePopView{
    CGRect triggerFrame = self.triggerFrame;
    CGPoint triggerCenter = CGPointMake(triggerFrame.origin.x+triggerFrame.size.width/2.0, triggerFrame.origin.y+triggerFrame.size.height/2.0);
    
    FCPopDisplayPosition effPosition;
    _popViewFrame = [self calculateDispFrameWithPosition:self.position effectivePosition:&effPosition];
    CGSize preSize = _popViewFrame.size;
    if (_squeezeByScreen) {
        _popViewFrame = [self squeezeFrame:_popViewFrame];
    }
    _arrowPoint = [self arrowPointForFrame:_popViewFrame point:triggerCenter position:effPosition];
    
    self.popView.frame = _popViewFrame;
    if (_squeezeByScreen && _squeezeHandler && !CGSizeEqualToSize(preSize, _popViewFrame.size)) { //通知大小被压缩
        _squeezeHandler(self);
    }
    
    if (_showArrow && !_overlap) {
        [self addArrowBorderForView:self.popView at:_arrowPoint];
    }
}

-(void)hide{
    [super hide];
    UIView *popView = self.popView;
    float preAlpha = popView.alpha;
    
    if (_animationType == FCPopDisplayerAnimTypeScale ||
        _animationType == FCPopDisplayerAnimTypeScaleAndFade) {
        CGAffineTransform preTransform = popView.transform;

        
        BOOL fadeEffect = _animationType == FCPopDisplayerAnimTypeScaleAndFade;
        [UIView animateWithDuration:self.duration animations:^{
            
            if (fadeEffect) popView.alpha = 0;
            popView.transform = CGAffineTransformScale(popView.transform, self->_startScale, self->_startScale);
            self.bgView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [self.bgView removeFromSuperview];
            [self.popView removeFromSuperview];
            
            popView.alpha = preAlpha;
            popView.transform = preTransform;
            
            [self hideCompleted];
        }];
        
    }else if (_animationType == FCPopDisplayerAnimTypeFade){
        
        [UIView animateWithDuration:self.duration animations:^{
            
            popView.alpha = 0;
            self.bgView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [self.bgView removeFromSuperview];
            [self.popView removeFromSuperview];
            popView.alpha = preAlpha;
            
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

-(CASpringAnimation *)showAnim{
    if (!_showAnim) {
        _showAnim = [[CASpringAnimation alloc] init];
        _showAnim.duration = self.duration*2;
        _showAnim.keyPath = @"transform";
        _showAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(_preTransform, 0.3, 0.3, 1)];
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
        _hideAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(_preTransform, 0.3, 0.3, 1)];
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
    
    //正向执行
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
