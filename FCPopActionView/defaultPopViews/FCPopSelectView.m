//
//  FCPopSelectView.m
//  FCPopActionView
//
//  Created by shiwei on 2018/12/20.
//  Copyright © 2018 shiwei. All rights reserved.
//

#import "FCPopSelectView.h"
#import "FCPopActionViewDef.h"

#define KCastToSelectable(c) ((id<FCPopItemSelectable>)c)

@interface FCPopSelectView (){
    NSMutableSet *_selectedItems;
    FCPopItemBox *_lastSelectedItem;
}

@end

@implementation FCPopSelectView

-(instancetype)init{
    if (self = [super init]) {
        _allowMultiSelect = YES;
        _selectedItems = [[NSMutableSet alloc] init];
    }
    return self;
}

-(void)reloadData{
    [super reloadData];
    
    [_selectedItems removeAllObjects];
    _lastSelectedItem = nil;
}

-(void)clickedItem:(FCPopItemBox *)itemBox{
    FCPopSelectType selectType = FCPopSelectTypeClick;
    if ([itemBox.controller respondsToSelector:@selector(selectType)]) {
        selectType = KCastToSelectable(itemBox.controller).selectType;
    }
    
    if (selectType == FCPopSelectTypeSelectable){
        //单选时，把之前选中的重置
        if (!_allowMultiSelect) {
            [KCastToSelectable(_lastSelectedItem.controller) selectStateChanged:NO];
        }
        
        _lastSelectedItem = itemBox;
        [_selectedItems addObject:itemBox.item];
        [KCastToSelectable(itemBox.controller) selectStateChanged:YES];
    }

    
    if (selectType != FCPopSelectTypeDisable) {
        [self noticeClickItem:itemBox];
    }
}

-(void)noticeClickItem:(FCPopItemBox *)itemBox{
    [super clickedItem:itemBox];
}

-(NSSet *)selectedItems{
    return [_selectedItems copy];
}

-(void)setSelectedItems:(NSSet *)selectedItems{
    _selectedItems = [selectedItems mutableCopy];
}

@end
