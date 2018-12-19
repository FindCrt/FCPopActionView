//
//  ViewController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import "ViewController.h"
#import "FCPopDisplayer.h"
#import "FCPopActionView.h"
#import "FCPopTextController.h"
#import "UIColor+RandomColor.h"

@interface ViewController ()<FCPopDisplayDelegate, FCPopActionViewDelegate>{
    UILabel *_orangeView;
    FCPopDisplayer *_displayer;
    CGRect _transformedFrame;
    
    FCPopActionView *_actionView;
}
@property (weak, nonatomic) IBOutlet UIButton *triggerButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _orangeView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 800)];
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
    
//    [self.view insertSubview:_orangeView belowSubview:_triggerButton];
    
    [self setupActionView];
}

-(void)setupActionView{
    _actionView = [[FCPopActionView alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width-20, 200)];
    _actionView.delegate = self;
    
    UILabel *topView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
//    topView.backgroundColor = [UIColor orangeColor];
    topView.text = @"上网";
    topView.textAlignment = NSTextAlignmentCenter;
    _actionView.topView = topView;
    
    UIButton *bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
//    bottomView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [bottomView setTitle:@"取消" forState:(UIControlStateNormal)];
    [bottomView addTarget:self action:@selector(handleButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:(UIControlStateNormal)];
    _actionView.bottomView = bottomView;
    
    NSArray *items = @[@"中国联通\n175",@"中国移动\n+86158",@"中国移动\n+86158",@"中国移动\n+86158",@"中国移动\n+86158",@"中国移动\n+86158",@"中国移动\n+86158",@"中国移动\n+86158"];
    _actionView.items = items;
    _actionView.scrollRange = NSMakeRange(2, 7);
    _actionView.scrollZoneMaxHeight = 100;
    _actionView.cornerRadius = 10;
    _actionView.separateInsets = UIEdgeInsetsMake(0, 30, 0, 30);
}

-(void)handleButton:(UIButton *)button{
    NSLog(@"蘑菇云");
}

//测试1：popView的transform不是identify
-(void)changePopViewTransform{
//    _orangeView.transform = CGAffineTransformMakeScale(0.8, 0.2);
}

- (IBAction)showPopView:(id)sender {
    _displayer = [FCPopDisplayer displayerWithType:(FCPopDisplayTypeScreenEdge) position:(FCPopDisplayPositionBottom)];
    _displayer.delegate = self;
    
    _displayer.popView = _actionView;
//    _displayer.bgView.backgroundColor = [UIColor clearColor];
    
//    FCPopDisplayer_point *dispPoint = (FCPopDisplayer_point *)_displayer;
//    dispPoint.triggerView = sender;
//    dispPoint.showArrow = YES;
//    dispPoint.overlap = NO;
//    dispPoint.animationType = FCPopDisplayerAnimTypeScale;
//    dispPoint.squeezeByScreen = YES;
//    dispPoint.margins = UIEdgeInsetsMake(20, 30, 40, 50);
    
//    _actionView.showSeparateLine = !_actionView.showSeparateLine;
    UIEdgeInsets insets = _actionView.separateInsets;
    insets.left += 10;
    insets.right += 10;
    _actionView.separateInsets = insets;
    
    _actionView.separateColor = [UIColor randomColor];
    
    [_displayer show];
}

-(void)popViewDidShow:(UIView *)view{
    NSLog(@"showed");
}

-(void)popViewDidHide:(UIView *)view{
//    _orangeView.frame = _transformedFrame;
//    [self.view addSubview:_orangeView];
}

-(void)handleAction:(UIButton *)button{
    NSLog(@"handleAction");
}

#pragma mark - actionView delegate

-(FCPopItemController *)popActionView:(FCPopActionView *)actionView itemControllerForItem:(id)item{
    FCPopTextController *controller = [[FCPopTextController alloc] initWithItem:item];
    controller.margin = 30;
    controller.height = 60;
    return controller;
}

@end
