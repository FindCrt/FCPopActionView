//
//  FCPopItemController.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/12.
//  Copyright © 2018年 shiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCPopItemController : NSObject

-(instancetype)initWithItem:(id)item;

@property (nonatomic) id item;

@property (nonatomic, readonly) UIView *displayView;

@end
