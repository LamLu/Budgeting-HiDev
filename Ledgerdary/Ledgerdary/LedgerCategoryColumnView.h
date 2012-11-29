//
//  LedgerCategoryColumnView.h
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/22/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerScrollView.h"
#import "LedgerDB.h"
#import "LedgerDateRowView.h"
#import "LedgerSummaryTitleView.h"

@interface LedgerCategoryColumnView : LedgerScrollView <UIAlertViewDelegate>{
    NSMutableArray *categoryies;
    //LedgerDB *ledgerDB;
}
@property (nonatomic) NSMutableArray *categories;
@property (weak, nonatomic)  LedgerSummaryTitleView *summaryTitleView;
@property (weak, nonatomic)  LedgerDateRowView *dateRowView;

- (id) initWithFrame:(CGRect)frame andDatabase: (LedgerDB *) aLedgerDB andDateView: (LedgerDateRowView *) aDateRowView andSummaryTitleView: (LedgerSummaryTitleView *) aSummaryTitleView;
- (void) deleteCategory: (LedgerCell *) category;
- (void) updateCategory: (LedgerCell *) category andNewCategory: (NSString *) name;;
- (void) reloadView;

@end
