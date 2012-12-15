//
//  SummaryContentView.m
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/22/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerSummaryContentView.h"
#import "LedgerContentViewController.h"
#import "LedgerDB.h"

@implementation LedgerSummaryContentView
@synthesize columnBackgroundView;

- (id) initWithFrame:(CGRect)frame andDatabase: (LedgerDB *) aLedgerDB andDateView: (LedgerDateRowView *) aDateRowView andSummaryTitleView: (LedgerSummaryTitleView *) aSummaryTitleView
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialize instance
        ledgerDB = aLedgerDB;
        self.dateRowView = aDateRowView;
        self.summaryTitleView = aSummaryTitleView;
        //layout setup
        [self setBackgroundColor: [UIColor clearColor]];
        [self setBounces:false];
        [self setScrollEnabled:false];
        [self setContentSize: CGSizeMake([aDateRowView contentSize].width,
                                         [[aSummaryTitleView subviews] count] * (cellHeight - cellBorder * 2))];
        
        //adding cells;
        [self reloadView];
    }
    return self;
}

- (void) updateBudget:(LedgerCell *) budgetCell andNewBudget:(NSNumber *) newBudget {
    int dIndex = [[self subviews] indexOfObject:budgetCell] / 3;
    
    [ledgerDB insertBudget: [self.dateRowView.dateRange objectAtIndex:dIndex]
                 andBudget: [NSNumber numberWithDouble:[newBudget doubleValue]]];
    [ledgerDB updateBudget: [self.dateRowView.dateRange objectAtIndex:dIndex]
                 andBudget: [NSNumber numberWithDouble:[newBudget doubleValue]]];
    
    if ([ledgerDB succeed]) {
        [budgetCell setText:[NSString stringWithFormat:@"%.2f", [newBudget doubleValue]]];
        [self recalculate:dIndex];
    }
}

- (CGPoint) getCoordinate:(LedgerCell *) budgetCell {
    return CGPointMake ([budgetCell frame].origin.x / (cellWidth - cellBorder * 2),
                        [budgetCell frame].origin.y / (cellHeight - cellBorder * 2));
}

- (void) reloadView
{
    while ([[self subviews] count] != 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    NSArray *dateViewArray = self.dateRowView.subviews;
    NSArray *sumTitleViewArray = self.summaryTitleView.subviews;
    NSNumber *budget = [NSNumber alloc];
    NSNumber *total = [NSNumber alloc];
    
    for (int i = 0; i < [[self.dateRowView dateRange] count]; i++) {
        CGRect dateLabel = [[dateViewArray objectAtIndex:i] frame];
        
        // 0 = total; 1 = budget; 2 = available
        total = [ledgerDB getTotal:[self.dateRowView.dateRange objectAtIndex:i]];
        CGRect summaryTotalLabel = [[sumTitleViewArray objectAtIndex:0] frame];
        LedgerCell *totalCell = [[LedgerCell alloc] initWithPos: CGPointMake(dateLabel.origin.x, summaryTotalLabel.origin.y)
                                                        andText: [NSString stringWithFormat:@"%.2f", [total doubleValue]]
                                                    andProperty: SummaryContentCell];
        
        // budget
        budget = [ledgerDB getBudget:[self.dateRowView.dateRange objectAtIndex:i]];
        CGRect summaryBudgetLabel = [[sumTitleViewArray objectAtIndex:1] frame];
        LedgerCell *budgetCell = [[LedgerCell alloc] initWithPos: CGPointMake(dateLabel.origin.x, summaryBudgetLabel.origin.y)
                                                     andText: [NSString stringWithFormat:@"%.2f", [budget doubleValue]]
                                                 andProperty: SummaryBudgetCell];
         
        // available
        CGRect summaryAvaiLabel = [[sumTitleViewArray objectAtIndex:2] frame];
        LedgerCell *balanceCell = [[LedgerCell alloc] initWithPos: CGPointMake(dateLabel.origin.x, summaryAvaiLabel.origin.y)
                                                          andText: [NSString stringWithFormat:@"%.2f", [budget doubleValue] - [total doubleValue]]
                                                      andProperty: SummaryContentCell];
        [self addSubview: totalCell];
        [self addSubview: budgetCell];
        [self addSubview: balanceCell];
    }
    [self addColumnBackground];
}

-(void) recalculate: (int) day {
    int sIndex = day * 3;
    NSString *total = [(LedgerCell *)[[self subviews] objectAtIndex:sIndex + 1] text];
    NSString *budget = [(LedgerCell *)[[self subviews] objectAtIndex:sIndex + 2] text];
    [(LedgerCell *)[[self subviews] objectAtIndex:sIndex + 3] setText: [NSString stringWithFormat:@"%.2f", [budget doubleValue] - [total doubleValue]]];
}

- (void) addColumnBackground{
    CGPoint todayPos = self.dateRowView.todayPos;
    CGFloat backgroundHeight;
    if ([self contentSize].height <= [self frame].size.height) {
        backgroundHeight = [self frame].size.height;
    }
    else {
        backgroundHeight = [self contentSize].height;
    }
    
    if (todayPos.x != -1) {
        UIColor *c = [[UIColor alloc] initWithRed:0.125 green:0.125 blue:0.125 alpha:.25];
        [self setColumnBackgroundView:[[UIView alloc]initWithFrame:CGRectMake(todayPos.x, 0, cellWidth, backgroundHeight + cellHeight)]];
        [[self columnBackgroundView] setBackgroundColor:c];
        [self addSubview: self.columnBackgroundView];
        [self sendSubviewToBack:self.columnBackgroundView];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self reloadView];
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
