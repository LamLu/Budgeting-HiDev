//
//  LedgerCategoryColumnView.m
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/22/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerCategoryColumnView.h"
#import "LedgerContentViewController.h"

@implementation LedgerCategoryColumnView
@synthesize categories;

- (id) initWithFrame:(CGRect)frame andDatabase: (LedgerDB *) aLedgerDB andDateView: (LedgerDateRowView *) aDateRowView andSummaryTitleView: (LedgerSummaryTitleView *) aSummaryTitleView
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialize instance
        ledgerDB = aLedgerDB;
        self.dateRowView = aDateRowView;
        self.summaryTitleView = aSummaryTitleView;
        [self setCategories:[ledgerDB getCategories]];
        
        //layout setup
        [self setScrollsToTop:false];
        [self setBackgroundColor: [UIColor clearColor]];
        [self setBounces:false];
        [self setScrollEnabled:false];
        [self setContentSize: CGSizeMake([self.summaryTitleView frame].size.width,
                                         [[self categories] count] * (cellHeight - cellBorder * 2))];
        
        //adding cells;
        [self reloadView];
    }
    return self;
}

- (void) reloadView {
    while ([[self subviews] count] != 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    [self setCategories:[ledgerDB getCategories]];
    CGPoint pos = CGPointMake(0, 0);
    for (int i = 0; i < [categories count]; i++) {
        LedgerCell *tempCell = [[LedgerCell alloc] initWithPos: pos
                                                       andText: [categories objectAtIndex:i]
                                                   andProperty: CategoryCell];
        [self addSubview: tempCell];
        pos.y += cellHeight - cellBorder * 2;
    }
    
    UIButton *addCategory = [[UIButton alloc] initWithFrame:CGRectMake(pos.x, pos.y, cellWidth, cellHeight)];
    
    UIColor *c2 = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:.25];
    [[addCategory layer] setBorderWidth:1];
    [[addCategory layer] setBorderColor:c2.CGColor];
    
    [addCategory setBackgroundColor: c2];
    [addCategory setTitle:@"+" forState: UIControlStateNormal];
    [addCategory addTarget:self action:@selector(addNewCategory) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addCategory];
    
    [self setContentSize: CGSizeMake([self frame].size.width,
                                     [[self subviews] count] * (cellHeight - cellBorder * 2) + 1)];
}

- (void) addNewCategory {
    UIAlertView *addingCategory = [[UIAlertView alloc] init];
    [addingCategory setDelegate:self];
    [addingCategory setTitle:@"Add a new category"];
    [addingCategory addButtonWithTitle:@"Cancel"];
    [addingCategory addButtonWithTitle:@"Done"];
    
    [addingCategory setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[addingCategory textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
    [[addingCategory textFieldAtIndex:0] setPlaceholder:@"New Category"];
    [addingCategory show];
}

- (void) updateCategory:(LedgerCell *) category andNewCategory:(NSString *) name{
    [ledgerDB updateCategory: [category text] andNewName:name];
    if ([ledgerDB succeed]) {
        [category setText:name];
    }
    [(LedgerContentViewController *) [[self superview] nextResponder] updateCategoryColumn];
}

- (void) deleteCategory:(LedgerCell *) category {
    [ledgerDB deleteCategory:[category text]];
    [self reloadView];
    [(LedgerContentViewController *) [[self superview] nextResponder] updateCategoryColumn];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Done"]) {
        [ledgerDB insertCategory: [[alertView textFieldAtIndex:0] text]];
        if ([ledgerDB succeed]) {
            [[self categories] addObject: [[alertView textFieldAtIndex:0] text]];
            [self reloadView];
        }
        [(LedgerContentViewController *) [[self superview] nextResponder] updateCategoryColumn];
    }
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
