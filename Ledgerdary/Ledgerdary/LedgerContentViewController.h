//
//  LedgerContentViewController.h
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/21/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LedgerSummaryTitleView.h"
#import "LedgerDateRowView.h"
#import "LedgerSummaryContentView.h"
#import "LedgerCategoryColumnView.h"
#import "LedgerTransactionView.h"
#import "LedgerDB.h"

static const double PAGE_BORDER_WIDTH = 1;

@interface LedgerContentViewController : UIViewController <UIScrollViewDelegate>
{
    LedgerDB *ledgerDB;
    NSMutableArray *dateArray;
}

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic) LedgerDB *ledgerDB;

@property (nonatomic, retain) LedgerSummaryTitleView *summaryTitleView;
@property (nonatomic, retain) LedgerDateRowView *dateRowView;
@property (nonatomic, retain) LedgerSummaryContentView *summaryContentView;
@property (nonatomic, retain) LedgerCategoryColumnView *categoryView;
@property (nonatomic, retain) LedgerTransactionView *transactionView;

- (id) initWithDB: (LedgerDB *)aLedgerDb andDateArray: (NSMutableArray *) aDateArray;
- (void) setUpSubViews;
- (void) updateCategoryColumn;
- (void) setOffsetAtDate:(NSDate *) date;
- (void) setOffsetToPos:(CGPoint) pos;
- (void) test;

@end