//
//  FCPopItemController.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import "FCPopItemController.h"

@implementation FCPopItemController

-(instancetype)init{
    return [self initWithItem:nil];
}

-(instancetype)initWithItem:(id)item{
    if (self = [super init]) {
        self.item = item;
    }
    return self;
}

-(void)layoutDisplayView{
    [self.displayView layoutIfNeeded];
}

@end
