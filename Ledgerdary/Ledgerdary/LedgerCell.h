//
//  LedgerCell.h
//  LedgerView
//
//  Created by YenHsiang Wang on 10/28/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LedgerContentViewController.h"
#import <QuartzCore/QuartzCore.h>

static const double cellWidth = 104;
static const double cellHeight = 28;
static const double cellGap = 0;
static const double cellBorder = .5;


@interface LedgerCell : UILabel <UIAlertViewDelegate> {
    BOOL editable;
    BOOL selected;
    NSString *text;
    int cellProperty;
    UILongPressGestureRecognizer *longPressRecog;
    UIPanGestureRecognizer *dragRecog;
    UISwipeGestureRecognizer *swipeRecog;
    
    UIActionSheet *datePickerSheet;
}

@property BOOL selected;
@property int cellStatus;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPressRecog;
@property (nonatomic, retain) UIPanGestureRecognizer *dragRecog;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeRecog;
@property (nonatomic, retain) NSString *property;

typedef enum {
    DateCell,
    CategoryCell,
    TransactionCell,
    SummaryContentCell,
    SummaryTitleCell,
    SummaryBudgetCell
} CellProperty;

- (id) initWithPos:(CGPoint) pt andText: (NSString *)aText andProperty: (int) aProperty;
- (void) rePosition: (CGPoint) pt;
- (void) editing;
//- (void) translate;
+ (CGSize) getCellSize;
-(int)getIndexFor:(int) aProperty;
@end
