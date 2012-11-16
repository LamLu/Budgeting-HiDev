//
//  LedgerCell.h
//  LedgerView
//
//  Created by YenHsiang Wang on 10/28/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LedgerContentViewController.h"


@interface LedgerCell : UILabel <UIAlertViewDelegate> {
    bool editable;
    bool deletable;
    NSString *text;
    int cellProperty;
    int cellStatus;
    UILongPressGestureRecognizer *longPressRecog;
    UIPanGestureRecognizer *dragRecog;
    
}
@property int cellStatus;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPressRecog;
@property (nonatomic, retain) UIPanGestureRecognizer *dragRecog;
@property (nonatomic, retain) NSString *property;

typedef enum {
    DateCell,
    CategoryCell,
    TransactionCell,
    SummaryContentCell,
    SummaryTitleCell,
    SummaryBudgetCell,
} CellProperty;

typedef enum {
    INITIAL_CELL,
    UPDATING_CELL,
    INSERTING_CELL
} CellStatus;


- (id) initWithFrame:(CGRect)aFrame andText:(NSString *)aText andProperty: (int) aProperty;
- (void) rePosition: (CGPoint) pt;
- (void) editing;
- (void) translate;
+ (CGSize) getCellSize;

@end

static const double cellWidth = 105;
static const double cellHeight = 32;
static const double cellGap = 1;