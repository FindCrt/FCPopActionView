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
    
    _orangeView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 500)];
    _orangeView.backgroundColor = [UIColor orangeColor];
    _orangeView.font = [UIFont systemFontOfSize:30];
    _orangeView.text = @"HELLO";
    _orangeView.textAlignment = NSTextAlignmentCenter;
    _orangeView.textColor = [UIColor whiteColor];
    
    [self changePopViewTransform];
    _transformedFrame = _orangeView.frame;
    
    [self.view insertSubview:_orangeView belowSubview:_triggerButton];
}

//测试1：popView的transform不是identify
-(void)changePopViewTransform{
    _orangeView.transform = CGAffineTransformMakeScale(1, 0.2);
}

- (IBAction)showPopView:(id)sender {
    _displayer = [FCPopDisplayer displayerWithType:(FCPopDisplayTypeScreenEdge) position:(FCPopDisplayPositionBottom)];
    _displayer.delegate = self;
    _displayer.duration = 1.5;

    _displayer.popView = _orangeView;
    [_displayer show];
    
//    _orangeView.frame = CGRectMake(0, 667, 375, _orangeView.frame.size.height);
//    _orangeView.transform = CGAffineTransformConcat(_orangeView.transform, CGAffineTransformMakeTranslation(0, -_orangeView.frame.size.height));
}

-(void)popViewDidShow:(UIView *)view{
    NSLog(@"showed");
}

-(void)popViewDidHide:(UIView *)view{
    _orangeView.frame = _transformedFrame;
    [self.view addSubview:_orangeView];
}


@end
