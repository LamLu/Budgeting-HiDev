//
//  LedgerTransactionView.m
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/22/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerTransactionView.h"
#import "LedgerContentViewController.h"

@implementation LedgerTransactionView
@synthesize rowBackgroundView;
@synthesize columnBackgroundView;

- (id) initWithFrame:(CGRect)frame andDatabase: (LedgerDB *) aLedgerDB andDateView: (LedgerDateRowView *) aDateRowView andCategoryColumnView: (LedgerCategoryColumnView *) aCategoryView
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialize instance
        ledgerDB = aLedgerDB;
        self.dateRowView = aDateRowView;
        self.categoryColumnView = aCategoryView;
        
        //layout setup
        [self setScrollsToTop:false];
        [self setBackgroundColor: [UIColor clearColor]];
        [self setBounces:false];
        [self setScrollEnabled:true];
        [self setContentSize: CGSizeMake([aDateRowView contentSize].width,
                                         [aCategoryView contentSize].height)];
        self.userInteractionEnabled = YES;
        self.showsHorizontalScrollIndicator = false;
        self.showsVerticalScrollIndicator = false;
        [self setDelegate:self];
    
        //adding cells;
        [self reloadView];
    }
    return self;
}

- (void) updateTransaction: (LedgerCell *) transaction andNewAmount: (NSString *) newAmount {
    [self willChangeValueForKey:@"transaction_Update"];
    CGPoint coordinate = [self getCoordinate:transaction];
    
    if (![[transaction text] isEqualToString:@""]){
        [ledgerDB updateTransactions: [[self.dateRowView dateRange] objectAtIndex: (int)coordinate.x]
                              andCID: [ledgerDB getCID: [[self.categoryColumnView categories] objectAtIndex: (int)coordinate.y]]
                           andAmount: [NSNumber numberWithDouble:[newAmount doubleValue]]];
    }
    else {
        [ledgerDB insertBudget:[[self.dateRowView dateRange] objectAtIndex:(int)coordinate.x] andBudget:0];
        [ledgerDB insertTransactions: [[self.dateRowView dateRange] objectAtIndex:(int)coordinate.x]
                              andCID: [ledgerDB getCID:[[self.categoryColumnView categories] objectAtIndex:(int)coordinate.y]]
                           andAmount: [NSNumber numberWithDouble:[newAmount doubleValue]]];
    }
    if ([ledgerDB succeed]) {
        [transaction setText:[NSString stringWithFormat:@"%.2f", [newAmount doubleValue]]];
        [self didChangeValueForKey:@"transaction_Update"];
    }
}

- (void) deleteTransaction: (LedgerCell *) transaction {
    [self willChangeValueForKey:@"transaction_Update"];
    CGPoint coordinate = [self getCoordinate:transaction];
    [ledgerDB deleteTransactions:[[self.dateRowView dateRange] objectAtIndex: (int)coordinate.x]
                    andCID:[ledgerDB getCID: [[self.categoryColumnView categories] objectAtIndex: (int)coordinate.y]]];
    
    if ([ledgerDB succeed]) {
        [transaction setText:@""];
        [self didChangeValueForKey:@"transaction_Update"];
    }
}

- (CGPoint) getCoordinate:(LedgerCell *) transaction {
    return CGPointMake ([transaction frame].origin.x / (cellWidth - cellBorder * 2),
                   [transaction frame].origin.y / (cellHeight - cellBorder * 2));
}

- (void) reloadView
{
    [self willChangeValueForKey:@"transaction_Update"];
    while ([[self subviews] count] != 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }

    [self addColumnBackground];
    
    [self setContentSize: CGSizeMake([self.dateRowView contentSize].width,
                                     [self.categoryColumnView contentSize].height)];
    
    NSMutableDictionary *transactions = [[NSMutableDictionary alloc]init];
    for (int i = 0; i <[[self.dateRowView dateRange] count]; i++){
        transactions = [ledgerDB getTransactions:[[self.dateRowView dateRange] objectAtIndex:i]];
        for (int j = 0; j < [[self.categoryColumnView categories] count]; j++) {
            NSString *amountStr = @"";
            NSString *cName = [[self.categoryColumnView categories] objectAtIndex:j];
            
            if ([transactions count] != 0 && [[transactions allKeys] containsObject:cName]) {
                amountStr = [NSString stringWithFormat:@"%.2f", [[transactions objectForKey:cName] doubleValue]];
            }

            CGPoint pt = CGPointMake([[[self.dateRowView subviews] objectAtIndex:i] frame].origin.x,
                                     [[[self.categoryColumnView subviews] objectAtIndex:j] frame].origin.y);
            
            [self addSubview: [[LedgerCell alloc] initWithPos: pt
                                                      andText: amountStr
                                                  andProperty: TransactionCell]];
        }
        /*
        for (int j = 0; j < [[transactions allKeys] count]; j++) {
            NSString *cName = [[transactions allKeys] objectAtIndex:j];
            NSInteger cIndex = [[self.categoryColumnView categories] indexOfObject: cName];
            NSString *amountStr = [NSString stringWithFormat:@"%.2f", [[transactions objectForKey:cName] doubleValue]];
            
            if (![amountStr isEqual: nil]) {
                CGPoint pt = CGPointMake([[[self.dateRowView subviews] objectAtIndex:i] frame].origin.x,
                                         [[[self.categoryColumnView subviews] objectAtIndex:cIndex] frame].origin.y);
                [self addSubview: [[LedgerCell alloc] initWithPos: pt
                                                         andText: amountStr
                                                     andProperty: TransactionCell]];
            }             
        }
         */
    }
    
    [self setContentSize: CGSizeMake([self.dateRowView contentSize].width,
                                     [self.categoryColumnView contentSize].height)];
    [self didChangeValueForKey:@"transaction_Update"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = [self contentOffset];
    LedgerContentViewController *ledgerPage = (LedgerContentViewController *)[[self superview] nextResponder];
    
    [ledgerPage.dateRowView setContentOffset:CGPointMake(offset.x, 0) ];
    [ledgerPage.summaryContentView setContentOffset:CGPointMake(offset.x, 0) ];
    NSArray *tempViewControllers = [[ledgerPage parentViewController] childViewControllers];

    for (int i = 0; i < [tempViewControllers count]; i++) {
        [[[tempViewControllers objectAtIndex:i] categoryView] setContentOffset:CGPointMake(0, offset.y) animated:NO];
    }
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
        [self setColumnBackgroundView:[[UIView alloc]initWithFrame:CGRectMake(todayPos.x, 0, cellWidth, backgroundHeight + cellHeight)]];
        UIColor *c = [[UIColor alloc] initWithRed:0.125 green:0.125 blue:0.125 alpha:.25];
        [[self columnBackgroundView] setBackgroundColor:c];
        [self addSubview: self.columnBackgroundView];
        [self sendSubviewToBack: self.columnBackgroundView];
    }
}

- (void) addRowBackground: (CGPoint) pos{
    [self setRowBackgroundView:[[UIView alloc]initWithFrame:CGRectMake(0, pos.y, [self contentSize].width, cellHeight)]];
    UIColor *c = [[UIColor alloc] initWithRed:0.125 green:0.125 blue:0.125 alpha:.25];
    [[self rowBackgroundView] setBackgroundColor:c];
    [self addSubview: self.rowBackgroundView];
    [self sendSubviewToBack: self.rowBackgroundView];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   // NSLog(@"YEah");//[self reloadView];
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
