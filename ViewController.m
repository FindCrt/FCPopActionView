//
//  ViewController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import "ViewController.h"
#import "FCPopDisplayer.h"

@interface ViewController ()<FCPopDisplayDelegate>{
    UILabel *_orangeView;
    FCPopDisplayer *_displayer;
    CGRect _transformedFrame;
}
@property (weak, nonatomic) IBOutlet UIButton *triggerButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _orangeView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 80)];
    _orangeView.backgroundColor = [UIColor orangeColor];
    _orangeView.font = [UIFont systemFontOfSize:30];
    _orangeView.text = @"HELLO";
    _orangeView.textAlignment = NSTextAlignmentCenter;
    _orangeView.textColor = [UIColor whiteColor];
    _orangeView.userInteractionEnabled = YES;
    
    UIButton *action = [[UIButton alloc] initWithFrame:CGRectMake(40, 00, 40, 30)];
    action.backgroundColor = [UIColor whiteColor];
    [action setTitle:@"action" forState:(UIControlStateNormal)];
    [action setTitleColor:[UIColor purpleColor] forState:(UIControlStateNormal)];
    [action addTarget:self action:@selector(handleAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_orangeView addSubview:action];
    
    [self changePopViewTransform];
    _transformedFrame = _orangeView.frame;
    
    [self.view insertSubview:_orangeView belowSubview:_triggerButton];
}

//测试1：popView的transform不是identify
-(void)changePopViewTransform{
//    _orangeView.transform = CGAffineTransformMakeScale(0.8, 0.2);
}

- (IBAction)showPopView:(id)sender {
    _displayer = [FCPopDisplayer displayerWithType:(FCPopDisplayTypeCenter) position:(FCPopDisplayPositionAuto)];
    _displayer.delegate = self;
    
    _displayer.popView = _orangeView;
//    _displayer.bgView.backgroundColor = [UIColor clearColor];
    
//    FCPopDisplayer_point *dispPoint = (FCPopDisplayer_point *)_displayer;
//    dispPoint.triggerView = sender;
//    dispPoint.showArrow = YES;
//    dispPoint.overlap = NO;
//    dispPoint.animationType = FCPopDisplayerAnimTypeFade;
    
    [_displayer show];
}

-(void)popViewDidShow:(UIView *)view{
    NSLog(@"showed");
}

-(void)popViewDidHide:(UIView *)view{
    _orangeView.frame = _transformedFrame;
    [self.view addSubview:_orangeView];
}

-(void)handleAction:(UIButton *)button{
    NSLog(@"handleAction");
}

@end
