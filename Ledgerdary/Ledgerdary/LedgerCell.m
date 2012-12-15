//
//  LedgerCell.m
//  LedgerView
//
//  Created by YenHsiang Wang on 10/28/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerCell.h"
#import "LedgerContentViewController.h"
#import "LedgerPageViewController.h"

@implementation LedgerCell
@synthesize longPressRecog;
@synthesize dragRecog;
@synthesize swipeRecog;
@synthesize selected;
@synthesize property;
@synthesize cellStatus;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { }
    return self;
}
- (id) initWithPos:(CGPoint) pt andText: (NSString *)aText andProperty: (int) aProperty
{
    self = [super init];
    [self setText:aText];
    cellProperty = aProperty;
    editable = false;
    selected = false;
    UIColor *c = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:.5];
    [[self layer] setBorderColor:c.CGColor];
    [[self layer] setBorderWidth:1];
    
    [self setTextColor:[UIColor blackColor]];
    [self setBackgroundColor:[UIColor clearColor]];
    
    // adding the gesture recognizer
    self.longPressRecog = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleting)];
    [self.longPressRecog setMinimumPressDuration:1];
    
    //self.dragRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translate)];
    //[self addGestureRecognizer:dragRecog];
    
    if (cellProperty == DateCell) {
        [self setFrame:CGRectMake(pt.x, pt.y, cellWidth, cellHeight * 2)];
        self.userInteractionEnabled = YES;
        editable = true;
        self.numberOfLines = 2;
        [self setTextAlignment:NSTextAlignmentCenter];
    }
    else if (cellProperty == CategoryCell) {
        [self setFrame:CGRectMake(pt.x, pt.y, cellWidth, cellHeight)];
        self.userInteractionEnabled = YES;
        editable = true;
        [self setTextAlignment:NSTextAlignmentRight];
        [self addGestureRecognizer:longPressRecog];
    }
    else if (cellProperty == TransactionCell) {
        [self setFrame:CGRectMake(pt.x, pt.y, cellWidth, cellHeight)];
        self.userInteractionEnabled = YES;
        editable = true;
        [self setTextAlignment:NSTextAlignmentRight];
        [self addGestureRecognizer:longPressRecog];
    }
    else if (cellProperty == SummaryTitleCell) {
        [self setFrame:CGRectMake(pt.x, pt.y, cellWidth, cellHeight)];
        [self setTextAlignment:NSTextAlignmentLeft];
    }
    else if (cellProperty == SummaryContentCell) {
        [self setFrame:CGRectMake(pt.x, pt.y, cellWidth, cellHeight)];
        [self setTextAlignment:NSTextAlignmentRight];
    }
    else if (cellProperty == SummaryBudgetCell) {
        [self setFrame:CGRectMake(pt.x, pt.y, cellWidth, cellHeight)];
        self.userInteractionEnabled = YES;
        editable = true;
        [self setTextAlignment:NSTextAlignmentRight];
    }
    
    return self;
}

- (void) rePosition: (CGPoint) pt{
    self.frame = CGRectMake(pt.x, pt.y, cellWidth, cellHeight);
}

+ (CGSize) getCellSize {
    return CGSizeMake(cellWidth, cellHeight);
}

- (void) deleting {
    if ((self.longPressRecog.state == UIGestureRecognizerStateBegan) && ![[self text] isEqualToString:@""]) {
        UIAlertView *deleteCategory = [[UIAlertView alloc] init];
        
        [deleteCategory setDelegate:self];
        [deleteCategory addButtonWithTitle:@"Cancel"];
        [deleteCategory addButtonWithTitle:@"Done"];
        if (cellProperty == CategoryCell) {
            [deleteCategory setTitle: [NSString stringWithFormat: @"Delete Category: %@", [self text]]];
            [deleteCategory setMessage:@"This will delete all transactions that are under this category."];
        }
        else if (cellProperty == TransactionCell) {
            LedgerTransactionView *tempTV = (LedgerTransactionView *)[self superview];
            int cIndex = [self getIndexFor: CategoryCell];
            int dIndex = [self getIndexFor: DateCell];
            
            [deleteCategory setTitle: [NSString stringWithFormat: @"Delete $: %@", [self text]]];
            [deleteCategory setMessage:[NSString stringWithFormat:@"$ for %@ on \n%@",
                                       [[[tempTV categoryColumnView] categories] objectAtIndex:cIndex],
                                       [(LedgerCell *)[[[tempTV dateRowView] subviews] objectAtIndex:dIndex] text]]];
        }
        [deleteCategory show];
    }
}

- (void) editing
{
    UIColor *c = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:.5];
    
    [self setBackgroundColor: c];
    
    if (editable) {
        if (cellProperty == DateCell) {
            datePickerSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:nil];
            
            
            UIToolbar *datePickerControlBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, datePickerSheet.frame.size.width, 45)];
            [datePickerControlBar setBarStyle:UIBarStyleBlack];
            [datePickerControlBar sizeToFit];
            
            //UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithTitle:nil style:0 target:nil action:nil];
            
            UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDatePicker)];
            
            UIBarButtonItem *select = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleDone target:self action:@selector(doneDatePicker)];
            
            [datePickerControlBar setItems:[NSArray arrayWithObjects:cancel, select, nil] animated:NO];
            
            CGRect datePickerFrame = CGRectMake(0,datePickerControlBar.frame.origin.y + datePickerControlBar.frame.size.height,0,0);
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            
            [datePickerSheet addSubview:datePickerControlBar];
            [datePickerSheet addSubview:datePicker];
            [datePickerSheet showInView:self ];
            [datePickerSheet setFrame:CGRectMake(0,100, 360, 150)];

        }
        else {
            UIAlertView *updateCell = [[UIAlertView alloc] init];
            
            [updateCell setDelegate:self];
            [updateCell addButtonWithTitle:@"Cancel"];
            [updateCell addButtonWithTitle:@"Done"];
            
            [updateCell setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [[updateCell textFieldAtIndex:0] setClearsOnBeginEditing:true];
            
            if (cellProperty == CategoryCell) {
                [updateCell setTitle: [NSString stringWithFormat: @"Change Name: \n%@", [self text]]];
                [[updateCell textFieldAtIndex:0] setKeyboardType: UIKeyboardTypeAlphabet];
                [[updateCell textFieldAtIndex:0] setPlaceholder: [NSString stringWithFormat:@"%@", [self text]]];
            }
            else if (cellProperty == TransactionCell) {
                LedgerTransactionView *tempTV = (LedgerTransactionView *)[self superview];
                int cIndex = [self getIndexFor: CategoryCell];
                int dIndex = [self getIndexFor: DateCell];
                
                [updateCell setTitle: [NSString stringWithFormat:@"$ for %@ on \n%@",
                                       [[[tempTV categoryColumnView] categories] objectAtIndex:cIndex],
                                       [(LedgerCell *)[[[tempTV dateRowView] subviews] objectAtIndex:dIndex] text]]];
                [[updateCell textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
                
                if ([[self text] isEqualToString:@""])
                    [[updateCell textFieldAtIndex:0] setPlaceholder:@"0.00"];
                else {
                    [[updateCell textFieldAtIndex:0] setPlaceholder:[self text]];
                }
            }
            else if (cellProperty == SummaryBudgetCell) {
                [updateCell setTitle: [NSString stringWithFormat:@"Change Budget: \n%@", [self text]]];
                [[updateCell textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
                [[updateCell textFieldAtIndex:0] setPlaceholder:[NSString stringWithFormat:@"%@", [self text]]];
            }
            [updateCell show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    BOOL deleting = false;
    if ([buttonTitle isEqualToString:@"Done"]) {
        if ([alertView alertViewStyle] == UIAlertViewStylePlainTextInput) {
            if(cellProperty == CategoryCell)
            {
                [(LedgerCategoryColumnView *)[self superview] updateCategory:self andNewCategory:[[alertView textFieldAtIndex:0] text]];
            }
            else if (cellProperty == TransactionCell) {
                if ([[[alertView textFieldAtIndex:0] text] doubleValue] != 0) {
                    [(LedgerTransactionView *)[self superview] updateTransaction:self andNewAmount:[[alertView textFieldAtIndex:0] text]];
                }
                else {
                    deleting = true;
                    [self deleteCell];
                }
            }
            else if (cellProperty == SummaryBudgetCell) {
                NSNumber *budget = [[NSNumber alloc] init];
                if ([[[alertView textFieldAtIndex:0] text] isEqual:@""]) {
                    budget = [NSNumber numberWithDouble:0];
                }
                else {
                    budget = [NSNumber numberWithDouble:[[[alertView textFieldAtIndex:0] text] doubleValue]];
                }
                
                [(LedgerSummaryContentView *)[self superview] updateBudget:self andNewBudget: budget];
            }
        }
        else if ([alertView alertViewStyle] == UIAlertViewStyleDefault){
            deleting = true;
            [self deleteCell];
        }
    }
    if (!deleting)
        [self setBackgroundColor: [UIColor clearColor]];
}

- (void) deleteCell {
    if (cellProperty == CategoryCell) {
        [(LedgerCategoryColumnView *)[self superview] deleteCategory: self];
    }
    else if (cellProperty == TransactionCell) {
        [(LedgerTransactionView *) [self superview] deleteTransaction: self];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    NSUInteger tapCount = [touch tapCount];

    switch (tapCount) {
        case 1:
            [self setSelected: !selected];
            
            if (selected) {
                UIColor *c = [[UIColor alloc] initWithRed:0.125 green:0.125 blue:0.125 alpha:.25];
                [self setBackgroundColor:c];
            }
            else {
                [self setBackgroundColor:[UIColor clearColor]];
            }
            break;
        case 2:
            [self editing];
            break;
        default :
            break;
    }
}

-(int)getIndexFor:(int) aProperty {
    if (aProperty == CategoryCell) {
        return ((int) (([self frame].origin.y ) / (cellHeight - cellBorder * 2)));
    }
    else if (aProperty == DateCell) {
        return ( (int) (([self frame].origin.x )/ (cellWidth - cellBorder * 2)));
    }
    else {
        return [[[self superview] subviews] indexOfObject: self];
    }
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 2, 0, 2};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


-(void) cancelDatePicker {
    [datePickerSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self setBackgroundColor: [UIColor clearColor]];
}

-(void) doneDatePicker {
    NSArray *subViewList = [datePickerSheet subviews];
    for (UIView *subview in subViewList) {
        if ([subview isKindOfClass:[UIDatePicker class]]) {
            NSDate *selectedDate = [(UIDatePicker*) subview date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyyMM"];
            if ( [[dateFormat stringFromDate: selectedDate] isEqualToString:[dateFormat stringFromDate: [[(LedgerDateRowView *)[self superview] dateRange] objectAtIndex:0]]]) {
                LedgerContentViewController *ledgerPage = (LedgerContentViewController *)[[[self superview] superview]nextResponder];
                [ledgerPage setOffsetAtDate:selectedDate];
            }
            else
            {
                LedgerContentViewController *ledgerPage = (LedgerContentViewController *)[[[self superview] superview ]nextResponder];
                LedgerPageViewController *pageViewController = (LedgerPageViewController *)[[ledgerPage parentViewController]parentViewController];
                [pageViewController goToDate:selectedDate];
                [(LedgerDateRowView *)[self superview] reloadView];
            }
            break;
        }
    }
    [datePickerSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self setBackgroundColor: [UIColor clearColor]];
}
@end
