//
//  LedgerScrollView.m
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/21/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerScrollView.h"

@implementation LedgerScrollView

- (id) initWithFrame:(CGRect)frame andDatabase: (LedgerDB *) aLedgerDB
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialize instance
        ledgerDB = aLedgerDB;
        
        //Layout setup
        [self setBounces:false];
        [self setScrollEnabled:false];
        [self setUserInteractionEnabled:false];
        [self setBackgroundColor: [UIColor clearColor]];
        
        //adding cells
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
