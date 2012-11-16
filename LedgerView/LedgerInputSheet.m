//
//  LedgerInputSheet.m
//  LedgerView
//
//  Created by YenHsiang Wang on 11/13/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerInputSheet.h"

@implementation LedgerInputSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)aFrame andAction: (int) anAction
{
    self = [super initWithTitle:@""
                       delegate:nil
              cancelButtonTitle:@"Cancel"
         destructiveButtonTitle:nil
              otherButtonTitles:@"Done", nil];
    action = anAction;
    
    if (action == PICKING_DATE) {
        [self setTitle:@"Picking a date"];
        UITextField *tf = [[UITextField alloc] init];
        [tf setPlaceholder:@"TESTING"];
        [self addSubview:tf];
        
    }
    else if (action == UPDATING_CATEGORY) {
    
    }
    else if (action == UPDATING_BUDGET) {
    
    }
    else if (action == UPDATING_TRANSACTION) {
    
    }
    else if (action == ADDING_CATEGORY) {
    
    }
    else if (action == ADDING_TRANSACTION) {
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
