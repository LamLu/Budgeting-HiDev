//
//  LedgerContentViewController.h
//  LedgerView
//
//  Created by YenHsiang Wang on 10/27/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LedgerCell.h"
#import "LedgerDB.h"
#import "LedgerPageViewController.h"


@interface LedgerContentViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate> {
    LedgerDB *ledgerDB;
    CGPoint todayPos;
    NSMutableArray *dateArray; 
    UILongPressGestureRecognizer *transactionLongPressRecog;
}
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic) LedgerDB *ledgerDB;


@property (nonatomic, retain)  UILongPressGestureRecognizer *transactionLongPressRecog;
@property (weak, nonatomic)  UIScrollView *transactionView;
@property (weak, nonatomic)  UIScrollView *dateView;
@property (weak, nonatomic)  UIScrollView *categoryView;
@property (weak, nonatomic)  UIScrollView *summaryTitleView;
@property (weak, nonatomic)  UIScrollView *summaryContentView;

- (void) setUpSubViews;

- (void) reloadDB;
- (void) reloadCategoryView;
- (void) reloadTransactionView;
- (void) reloadSummaryContentView;

@end
