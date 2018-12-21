//
//  UIView+FCPopDisplayer.h
//  FCPopActionView
//
//  Created by shiwei on 2018/12/21.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FCPopDisplayer;
@interface UIView (FCPopDisplayer)

@property (nonatomic, nullable) FCPopDisplayer *displayer;

-(void)show;
-(void)hide;

@end

NS_ASSUME_NONNULL_END
