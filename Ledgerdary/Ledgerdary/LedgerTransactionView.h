//
//  LedgerTransactionView.h
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/22/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerScrollView.h"
#import "LedgerDB.h"
#import "LedgerDateRowView.h"
#import "LedgerCategoryColumnView.h"

@interface LedgerTransactionView : LedgerScrollView <UIScrollViewDelegate>{
    //LedgerDB *ledgerDB;
}
@property (nonatomic) BOOL transaction_Update;
@property (weak, nonatomic) LedgerDateRowView *dateRowView;
@property (weak, nonatomic) LedgerCategoryColumnView *categoryColumnView;
@property (nonatomic) UIView *columnBackgroundView;
@property (nonatomic) UIView *rowBackgroundView;

- (id) initWithFrame:(CGRect)frame andDatabase: (LedgerDB *) aLedgerDB andDateView: (LedgerDateRowView *) aDateRowView andCategoryColumnView: (LedgerCategoryColumnView *) aCategoryView;
- (void) updateTransaction: (LedgerCell *) transaction andNewAmount: (NSString *) newAmount;
- (void) deleteTransaction: (LedgerCell *) transaction;
- (CGPoint) getCoordinate: (LedgerCell *) transaction;
- (void) reloadView;
- (void) scrollViewDidScroll:(UIScrollView *)scrollView;
@end
