//
//  CenterExampleViewController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/24.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "CenterExampleViewController.h"
#import "FCPopSimpleView.h"
#import "FCPopDisplayer.h"

@interface CenterExampleViewController ()

@end

@implementation CenterExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 100, 100, 50)];
    [showBtn addTarget:self action:@selector(show) forControlEvents:(UIControlEventTouchUpInside)];
    showBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [showBtn setTitle:@"alert" forState:(UIControlStateNormal)];
    [showBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    [self.view addSubview:showBtn];
    
    //TODO: 加滑块来调节duration和startScale等的效果
}

-(void)show{
    FCPopSimpleView *popView = [[FCPopSimpleView alloc]initWithFrame:CGRectMake(180, 0, 200, 100)];
    popView.title = @"提醒";
    popView.items = [FCPopSimpleItem activeItemWithIcons:@[@"q1",@"",@"q2",@"q3"] titles:@[@"A",@"B",@"C",@"D",@"E",@"F"]];
    
    FCPopDisplayer_center *disp = [[FCPopDisplayer_center alloc] initWithPopView:popView];
    [disp show];
}

@end
