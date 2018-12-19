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
#import "FCPopIconTextController.h"
#import "UIColor+RandomColor.h"

@interface ViewController ()<FCPopDisplayDelegate, FCPopActionViewDelegate>{
    UILabel *_orangeView;
    FCPopDisplayer *_displayer;
    CGRect _transformedFrame;
    
    FCPopActionView *_actionView;
    FCPopActionView *_weChatPopView;
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
    
    UIButton *action = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-40, 00, 40, 30)];
    action.backgroundColor = [UIColor whiteColor];
    [action setTitle:@"+" forState:(UIControlStateNormal)];
    [action setTitleColor:[UIColor purpleColor] forState:(UIControlStateNormal)];
    [action addTarget:self action:@selector(handleAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_orangeView addSubview:action];
    
    [self changePopViewTransform];
    _transformedFrame = _orangeView.frame;
    
//    [self.view insertSubview:_orangeView belowSubview:_triggerButton];
    
    [self setWeChatPopView];
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
    
    NSArray *items = @[@"中国联通\n175",@"中国移动\n+86158"];
    _actionView.items = items;
    _actionView.scrollRange = NSMakeRange(2, 7);
    _actionView.scrollZoneMaxHeight = 100;
    _actionView.cornerRadius = 10;
}

-(void)handleButton:(UIButton *)button{
    NSLog(@"蘑菇云");
}

//测试1：popView的transform不是identify
-(void)changePopViewTransform{
//    _orangeView.transform = CGAffineTransformMakeScale(0.8, 0.2);
}

- (IBAction)showPopView:(id)sender {
    
    [self showWeChatPopView:sender];
//    _actionView.showSeparateLine = !_actionView.showSeparateLine;
    
//    FCPopDisplayer_screenEdge *dispScreen = (FCPopDisplayer_screenEdge *)_displayer;
//    dispScreen.gapSpace = 10;
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

#pragma mark - 微信弹框样式

-(void)showWeChatPopView:(UIButton *)sender{
    _displayer = [FCPopDisplayer displayerWithType:(FCPopDisplayTypePoint) position:(FCPopDisplayPositionBottom)];
    _displayer.delegate = self;
    
    _displayer.duration = 0.15;
    _displayer.popView = _weChatPopView;
    _displayer.bgView.backgroundColor = [UIColor clearColor];
    
    FCPopDisplayer_point *dispPoint = (FCPopDisplayer_point *)_displayer;
    dispPoint.triggerView = sender;
    dispPoint.showArrow = NO;
    dispPoint.overlap = NO;
    dispPoint.animationType = FCPopDisplayerAnimTypeScaleAndFade;
    dispPoint.squeezeByScreen = YES;
    dispPoint.margins = UIEdgeInsetsMake(0, 0, 0, 20);
    dispPoint.startScale = 0.7;
    
    [_displayer show];
}

-(void)setWeChatPopView{
    _weChatPopView = [[FCPopActionView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    NSArray *items = @[
                       @[@"1",@"发起群聊"],
                       @[@"2",@"添加朋友"],
                       @[@"3",@"扫一扫"],
                       @[@"4",@"收付款"],
                       @[@"5",@"帮助与反馈"]
                       ];
    _weChatPopView.items = items;
    _weChatPopView.delegate = self;
    //55 58 65, 43 46 53
    _weChatPopView.separateColor = [UIColor colorWithRed:43.0f/255 green:46.0f/255 blue:53.0f/255 alpha:1];
}

#pragma mark - actionView delegate

-(FCPopItemController *)popActionView:(FCPopActionView *)actionView itemControllerForItem:(id)item{
    
    if (actionView == _actionView) {
        FCPopTextController *controller = [[FCPopTextController alloc] initWithItem:item];
        controller.margin = 30;
        controller.height = 60;
        return controller;
        
    }else if (actionView == _weChatPopView){
        NSArray *info = item;
        FCPopIconTextController *controller = [[FCPopIconTextController alloc] initWithItem:item];
        controller.iconView.image = [UIImage imageNamed:info.firstObject];
        controller.titleLabel.text = info[1];
        controller.titleLabel.textColor = [UIColor whiteColor];
        controller.backgroundColor = [UIColor colorWithRed:55.0f/255 green:58.0f/255 blue:65.0f/255 alpha:1];
        
        return controller;
    }
    
    return nil;
}

@end
