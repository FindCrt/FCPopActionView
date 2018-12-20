//
//  FCPopSimpleItem.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopSimpleItem.h"

@implementation FCPopSimpleItem

+(NSArray<FCPopSimpleItem *> *)activeItemWithIcons:(NSArray<UIImage *> *)icons titles:(NSArray<NSString *> *)titles{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<icons.count; i++) {
        FCPopSimpleItem *item = [[FCPopSimpleItem alloc] init];
        if ([icons[i] isKindOfClass:[NSString class]]) {
            item.icon = [UIImage imageNamed:icons[i]];
        }else{
            item.icon = icons[i];
        }
        
        item.title = titles[i];
        
        [items addObject:item];
    }
    
    return items;
}

@end
