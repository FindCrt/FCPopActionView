//
//  ExampleViewController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/21.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "ExampleViewController.h"
#import "FCPopSimpleView.h"
#import "FCPopDisplayer.h"

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface ExampleViewController (){
    UIButton *_button1;
    FCPopSimpleView *_popView1;
    FCPopDisplayer *_displayer;
}

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //例子1： 右上角弹框，模拟从多个群组中选择一个的这种需求。
    //特点是：1. 多项内容，会充满屏幕，需要滚动支持 2. 压缩在屏幕范围内 3.单项选择
    [self setButton1];
    [self setPopView1];
}

-(void)setButton1{
    _button1 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-64, 0, 60, 40)];
    [_button1 addTarget:self action:@selector(showPopView1:) forControlEvents:(UIControlEventTouchUpInside)];
    [_button1 setTitle:@"选择" forState:(UIControlStateNormal)];
    [_button1 setTitleColor:[UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:1] forState:(UIControlStateNormal)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_button1];
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
    _popView1.topSpace = 10;
    _popView1.scrollRange = NSMakeRange(0, items.count);
    
    //点击修改popView的内容
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
    displayer.position = FCPopDisplayPositionBottom;
    displayer.popView = _popView1;
    displayer.triggerView = button;
    displayer.showArrow = YES;
    displayer.margins = UIEdgeInsetsMake(0, 0, 40, 4);

    __weak typeof(self) weakSelf = self;
    [displayer squeezeByScreenWithSizeChangedHandler:^(FCPopDisplayer_point *displayer) {
        __strong typeof(self) strongSelf = weakSelf;
        //大小被改变，需要重新布局; 这种情况就需要第2种类型布局方式了，因为不能改变弹框大小
        [strongSelf->_popView1 layoutWithNorm:(FCPopLayoutNormSettedFrame)];
    }];

    [displayer show];
}

@end
