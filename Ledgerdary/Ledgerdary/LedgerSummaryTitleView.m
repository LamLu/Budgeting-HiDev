//
//  LedgerSummaryTitleView.m
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/21/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerSummaryTitleView.h"

@implementation LedgerSummaryTitleView

- (id) initWithFrame:(CGRect)frame andDatabase: (LedgerDB *) aLedgerDB
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialize instance
        ledgerDB = aLedgerDB;
        
        //Layout setup
        [self setBounces:false];
        [self setScrollEnabled:false];
        [self setBackgroundColor: [UIColor clearColor]];
        
        //adding cells
        [self addCells];
    }
    return self;
}

-(void) addCells {
    CGPoint pos = CGPointMake(0, 0);
    NSArray *titleArray = [NSArray arrayWithObjects:@"Total:", @"Budget:", @"Balance:", nil];
    for (int i = 0; i < [titleArray count]; i++) {
        [self addSubview:
         [[LedgerCell alloc] initWithPos: pos
                                 andText: [titleArray objectAtIndex:i]
                             andProperty: SummaryTitleCell]];
        pos.y += cellHeight - cellBorder * 2;
    }
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
