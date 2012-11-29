//
//  SummaryContentView.h
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/22/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerScrollView.h"
#import "LedgerDB.h"
#import "LedgerDateRowView.h"
#import "LedgerSummaryTitleView.h"

@interface LedgerSummaryContentView : LedgerScrollView{
    //LedgerDB *ledgerDB;
}
@property (weak, nonatomic) LedgerSummaryTitleView *summaryTitleView;
@property (weak, nonatomic) LedgerDateRowView *dateRowView;
@property (nonatomic) UIView *columnBackgroundView;

//@property (nonatomic, assign) LedgerDB *ledgerDB;

- (id) initWithFrame:(CGRect)frame andDatabase: (LedgerDB *) aLedgerDB andDateView: (LedgerDateRowView *) aDateRowView andSummaryTitleView: (LedgerSummaryTitleView *) aSummaryTitleView;
- (void) updateBudget:(LedgerCell *) budgetCell andNewBudget:(NSNumber *) newBudget;
- (CGPoint) getCoordinate:(LedgerCell *) budgetCell ;
- (void) reloadView;
- (void) recalculate: (int) day;

@end
