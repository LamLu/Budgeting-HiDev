//
//  LedgerDateRowView.m
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/22/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerDateRowView.h"

@implementation LedgerDateRowView
@synthesize dateRange;
@synthesize todayPos;

- (id) initWithFrame:(CGRect)frame andDatabase: (LedgerDB *) aLedgerDB andArray:(NSMutableArray *) aDateRange
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialize instance
        ledgerDB = aLedgerDB;
        
        //set DateRange
        [self setDateRange: aDateRange];
        
        //layout setup
        [self setBackgroundColor: [UIColor clearColor]];
        [self setBounces:false];
        [self setScrollEnabled:false];
        [self setContentSize: CGSizeMake([[self dateRange] count] * (cellWidth - cellBorder * 2), cellHeight)];
        
        //adding cells
        [self reloadView];
    }
    return self;
}

- (void) reloadView{
    while ([[self subviews] count] != 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    CGPoint pos = CGPointMake(0, 0);
    [self setTodayPos:CGPointMake(-1, 0)];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd\nEEEE"];
    
    for (int i = 0; i < [dateRange count]; i++) {
        [self addSubview:
         [[LedgerCell alloc] initWithPos: pos
                                 andText: [dateFormat stringFromDate: dateRange[i]]
                             andProperty: DateCell]];
        if ([[dateFormat stringFromDate: dateRange[i]] isEqual: [dateFormat stringFromDate: today]]) {
            [self setTodayPos:pos];
            
            UIColor *c = [[UIColor alloc] initWithRed:0.125 green:0.125 blue:0.125 alpha:.25];
            [((LedgerCell *)[[self subviews] objectAtIndex: [[self subviews] count] - 1]) setBackgroundColor: c];
        }
        pos.x += cellWidth - cellBorder * 2;
    }
}

@end
