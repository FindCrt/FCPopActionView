//
//  ExampleViewController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/21.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "PointExampleViewController.h"
#import "FCPopSimpleView.h"
#import "FCPopDisplayer.h"

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface PointExampleViewController (){
    FCPopSimpleView *_popView1;
    FCPopDisplayer *_displayer;
}

@end

@implementation PointExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //例子1： 右上角弹框，模拟从多个群组中选择一个的这种需求。
    //特点是：1. 多项内容，会充满屏幕，需要滚动支持 2. 压缩在屏幕范围内 3.单项选择
    [self setButtons];
    [self setPopView1];
}

-(void)setButtons{
    
    CGPoint points[] = {
        {10, 80},
        {10, 300},
        {10, 600},
        {150, 80},
        {150, 300},
        {150, 590},
        {kScreenWidth-70, 80},
        {kScreenWidth-70, 300},
        {kScreenWidth-70, 500},
    };
    
    for (int i = 0; i<sizeof(points)/sizeof(CGPoint); i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(points[i].x, points[i].y, 60, 40)];
        [button addTarget:self action:@selector(showPopView1:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:1] forState:(UIControlStateNormal)];
        button.backgroundColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.5 alpha:1];
        
        [self.view addSubview:button];
    }
}

-(void)setPopView1{
    _popView1 = [[FCPopSimpleView alloc] initWithFrame:CGRectMake(0, 0, 180, 100)];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (int i = 0; i<15; i++) {
        //模拟一个群组的信息
        NSString *groupName = [NSString stringWithFormat:@"group_%c",'A'+arc4random()%26];
        NSInteger memberCount = arc4random()%1000;
        
        FCPopSimpleItem *item = [[FCPopSimpleItem alloc] init];
        item.title = [NSString stringWithFormat:@"%@(%ld)",groupName, memberCount];
        [items addObject:item];
    }
    _popView1.title = @"选择分组";
    _popView1.items = items;
    _popView1.scrollRange = NSMakeRange(0, items.count);
    
    //点击修改popView的内容,1、内容更新 2、布局调整
    _popView1.clickBlock = ^(FCPopSimpleView * _Nonnull actionView, FCPopSimpleItem * _Nonnull item) {
        
        NSMutableArray *curItems = [actionView.items mutableCopy];
        
        FCPopSimpleItem *itemCopy = [[FCPopSimpleItem alloc] init];
        itemCopy.title = [NSString stringWithFormat:@"复制 %@",item.title];
        [curItems insertObject:itemCopy atIndex:0];
        
        actionView.items = curItems;
        actionView.scrollRange = NSMakeRange(0, curItems.count);
        
        [actionView.displayer locatePopView];
    };
}

-(void)showPopView1:(UIButton *)button{
    FCPopDisplayer_point *displayer = [[FCPopDisplayer_point alloc] init];
    displayer.position = FCPopDisplayPositionAuto;
    displayer.popView = _popView1;
    displayer.showArrow = YES;
    //注意：边距太大，会把弹框挤得脱离按钮，会很奇怪
    displayer.margins = UIEdgeInsetsMake(10, 10, 70, 10);
    displayer.triggerView = button;
    
    displayer.arrowTriggerSpace = -10;


    __weak typeof(self) weakSelf = self;
    [displayer squeezeByScreenWithSizeChangedHandler:^(FCPopDisplayer_point *displayer) {
        __strong typeof(self) strongSelf = weakSelf;
        //大小被改变，需要重新布局; 这种情况就需要第2种类型布局方式了，因为不能改变弹框大小
        [strongSelf->_popView1 layoutWithNorm:(FCPopLayoutNormSettedFrame)];
    }];

    [displayer show];
}

@end
