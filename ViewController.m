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
#import "FCPopTitleView.h"
#import "UIView+Border.h"

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()<FCPopDisplayDelegate, FCPopActionViewDelegate>{
    UILabel *_orangeView;
    FCPopDisplayer *_displayer;
    CGRect _transformedFrame;
    
    //微信弹框
    UIButton *_weChatButton;
    FCPopActionView *_weChatPopView;
    
    //小米底部弹框
    UIButton *_miButton;
    FCPopActionView *_miBottomPopView;
    
    //QQ弹框(箭头+圆角+无分割线)
    UIButton *_qqButton;
    FCPopActionView *_qqPopView;
    
    //网易云音乐底部弹框(滚动+标题+半圆角)
    UIButton *_wyButton;
    FCPopActionView *_wyPopView;
}
@property (weak, nonatomic) IBOutlet UIButton *triggerButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //微信弹框
    [self setWeChatButton];
    [self setWeChatPopView];
    
    //小米底部弹框
    [self setMiButton];
    [self setMiBottomPopView];
    
    //QQ弹框
    [self setQQButton];
    [self setQQPopView];
    
    //网易云音乐
    [self setWyButton];
    [self setWyBottomPopView];
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

-(void)setWeChatButton{
    _weChatButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-64, 20, 60, 44)];
    [_weChatButton setTitle:@"微信+" forState:(UIControlStateNormal)];
    _weChatButton.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
    [_weChatButton addTarget:self action:@selector(showWeChatPopView:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_weChatButton];
}

-(void)setWeChatPopView{
    _weChatPopView = [[FCPopActionView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    //只需要提供最关键的数据就可以了，核心在于怎么解析，解析靠的就是“FCPopItemController”
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

#pragma mark - 小米底部弹框样式

-(void)setMiButton{
    _miButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, kScreenWidth-20, 40)];
    [_miButton setTitle:@"小米 上网卡" forState:(UIControlStateNormal)];
    [_miButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:(UIControlStateNormal)];
    _miButton.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    _miButton.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    _miButton.layer.borderWidth = 0.5;
    
    [_miButton addTarget:self action:@selector(showMiBottomPopView:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:_miButton];
}

-(void)setMiBottomPopView{
    _miBottomPopView = [[FCPopActionView alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width-20, 200)];
    _miBottomPopView.delegate = self;
    
    UILabel *topView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    topView.text = @"上网";
    topView.textAlignment = NSTextAlignmentCenter;
    topView.font = [UIFont boldSystemFontOfSize:17];
    _miBottomPopView.topView = topView;
    
    UIButton *bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [bottomView setTitle:@"取消" forState:(UIControlStateNormal)];
    [bottomView addTarget:self action:@selector(handleButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:(UIControlStateNormal)];
    _miBottomPopView.bottomView = bottomView;
    
    NSArray *items = @[@"中国联通\n175",@"中国移动\n+86158"];
    _miBottomPopView.items = items;
    _miBottomPopView.scrollRange = NSMakeRange(2, 7);
    _miBottomPopView.scrollZoneMaxHeight = 100;
    _miBottomPopView.cornerRadius = 10;
}

-(void)showMiBottomPopView:(UIButton *)button{
    _displayer = [FCPopDisplayer displayerWithType:(FCPopDisplayTypeScreenEdge) position:(FCPopDisplayPositionBottom)];
    _displayer.delegate = self;
    _displayer.popView = _miBottomPopView;
    
    FCPopDisplayer_screenEdge *dispScreen = (FCPopDisplayer_screenEdge*)_displayer;
    dispScreen.gapSpace = 10;
    
    [_displayer show];
}

#pragma mark - QQ弹框样式

-(void)setQQButton{
    _qqButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-64, 140, 60, 44)];
    [_qqButton setTitle:@"QQ+" forState:(UIControlStateNormal)];
    _qqButton.backgroundColor = [UIColor colorWithRed:38.0f/255 green:166.0f/255 blue:255.0f/255 alpha:1];
    [_qqButton addTarget:self action:@selector(showQQPopView:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_qqButton];
}

-(void)setQQPopView{
    _qqPopView = [[FCPopActionView alloc] initWithFrame:CGRectMake(0, 0, 180, 100)];
    NSArray *items = @[
                       @[@"q1",@"创建群聊"],
                       @[@"q2",@"加好友/群"],
                       @[@"q3",@"扫一扫"],
                       @[@"q4",@"面对面快传"],
                       @[@"q5",@"收付款"]
                       ];
    _qqPopView.items = items;
    _qqPopView.delegate = self;
    _qqPopView.topSpace = 10;  //给箭头留出的空间
    _qqPopView.separateColor = [UIColor colorWithWhite:0.9 alpha:1];
    _qqPopView.cornerRadius = 5;
    _qqPopView.showSeparateLine = NO;
}

-(void)showQQPopView:(UIButton *)sender{
    _displayer = [FCPopDisplayer displayerWithType:(FCPopDisplayTypePoint) position:(FCPopDisplayPositionBottom)];
    _displayer.delegate = self;
    
    _displayer.popView = _qqPopView;
    _displayer.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    
    FCPopDisplayer_point *dispPoint = (FCPopDisplayer_point *)_displayer;
    dispPoint.triggerView = sender;
    dispPoint.showArrow = YES;
    dispPoint.arrowSize = CGSizeMake(18, 10);
    dispPoint.overlap = NO;
    dispPoint.animationType = FCPopDisplayerAnimTypeScaleAndFade;
    dispPoint.margins = UIEdgeInsetsMake(0, 0, 0, 5);
    dispPoint.startScale = 0.7;
    
    [_displayer show];
}

#pragma mark - 网易云弹框样式

-(void)setWyButton{
    _wyButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 140, 100, 44)];
    [_wyButton setTitle:@"网易云音乐" forState:(UIControlStateNormal)];
    [_wyButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _wyButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    _wyButton.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
    
    [_wyButton addTarget:self action:@selector(showWyBottomPopView:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:_wyButton];
}

///样式稍有区别，头部是固定的，如果要头部滚动，就把头部也作为items之一，然后纳入滚动区域，而不是作为topView
-(void)setWyBottomPopView{
    //只有宽度是有意义的，其他的会根据类型调整
    _wyPopView = [[FCPopActionView alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width, 100)];
    _wyPopView.delegate = self;
    _wyPopView.backgroundColor = [UIColor colorWithWhite:243.0f/255 alpha:1];
    
    FCPopTitleView *titleView = [[FCPopTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    titleView.titleLabel.text = @"歌曲: 像我这样的人";
    titleView.subtitleLabel.text = @"您已开通音乐包，可下载且仅可在音乐包有效期内离线播放";
    titleView.titleLabel.textColor = [UIColor colorWithWhite:100.0/255 alpha:1];
    titleView.titleLabel.font = [UIFont systemFontOfSize:14];
    titleView.margins = UIEdgeInsetsMake(10, 10, 0, 10);
    _wyPopView.topView = titleView;
    
    NSArray *items = @[
                       @[@"wy1",@"收藏到歌单"],
                       @[@"wy2",@"歌手:毛不易"],
                       @[@"wy1",@"专辑:平凡的一天"],
                       @[@"wy2",@"来源:专辑「平凡的一天」"],
                       @[@"wy1",@"音质:自动选择"],
                       @[@"wy2",@"鲸云音效"],
                       @[@"wy1",@"查看视频"],
                       @[@"wy2",@"相似推荐"],
                       @[@"wy1",@"定时停止播放"],
                       @[@"wy2",@"打开驾驶模式"],
                       ];
    _wyPopView.items = items;
    _wyPopView.scrollRange = NSMakeRange(0, items.count);
    _wyPopView.scrollZoneMaxHeight = 350;
    _wyPopView.separateInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    
    //    _wyPopView.cornerRadius = 10;
    //只有上面两个角是圆角;这个方法依赖于当前的layer的大小，不会自动变化
    [_wyPopView layoutIfNeeded];
    [_wyPopView addBorderWithColor:[UIColor whiteColor] andWidth:0 andPostion:(FCBorderPositionAll) corners:(UIRectCornerTopLeft | UIRectCornerTopRight) radius:10];
}

-(void)showWyBottomPopView:(UIButton *)button{
    _displayer = [FCPopDisplayer displayerWithType:(FCPopDisplayTypeScreenEdge) position:(FCPopDisplayPositionBottom)];
    _displayer.delegate = self;
    _displayer.popView = _wyPopView;
    _displayer.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [_displayer show];
}

#pragma mark - actionView delegate

-(FCPopItemController *)popActionView:(FCPopActionView *)actionView itemControllerForItem:(id)item{
    
    if (actionView == _miBottomPopView) {
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
        
    }else if (actionView == _qqPopView){
        NSArray *info = item;
        FCPopIconTextController *controller = [[FCPopIconTextController alloc] initWithItem:item];
        controller.iconView.image = [UIImage imageNamed:info.firstObject];
        controller.titleLabel.text = info[1];
        controller.titleLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
        controller.backgroundColor = [UIColor whiteColor];
        
        return controller;
        
    }else if (actionView == _wyPopView){
        NSArray *info = item;
        FCPopIconTextController *controller = [[FCPopIconTextController alloc] initWithItem:item];
        controller.iconView.image = [UIImage imageNamed:info.firstObject];
        controller.titleLabel.text = info[1];
        controller.titleLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        controller.titleLabel.font = [UIFont systemFontOfSize:16];
        
        return controller;
    }
    
    return nil;
}

@end
