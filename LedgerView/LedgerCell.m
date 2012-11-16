//
//  LedgerCell.m
//  LedgerView
//
//  Created by YenHsiang Wang on 10/28/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerCell.h"

@implementation LedgerCell
@synthesize longPressRecog;
@synthesize dragRecog;
@synthesize property;
@synthesize cellStatus;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { }
    return self;
}

- (id)initWithFrame:(CGRect)aFrame andText:(NSString *)aText andProperty: (int) aProperty
{
    self = [super init];
    [self setFrame:aFrame];
    [self setText:aText];
    cellProperty = aProperty;
    cellStatus = INITIAL_CELL;
    deletable = false;
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setTextColor:[UIColor darkGrayColor]];
    [self setBackgroundColor:[UIColor lightGrayColor]];
    
    self.longPressRecog = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(editing)];
    [self.longPressRecog setMinimumPressDuration:1];
    [self addGestureRecognizer:longPressRecog];
    self.dragRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translate)];
    [self addGestureRecognizer:dragRecog];
    
    
    if (cellProperty == DateCell) {
        editable = false;
        self.numberOfLines = 2;
        [self setTextAlignment:NSTextAlignmentCenter];
    }
    else if (cellProperty == CategoryCell) {
        self.userInteractionEnabled = YES;
        editable = true;
        deletable = true;
        [self setTextAlignment:NSTextAlignmentRight];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cellHeight / 2, cellHeight / 2)];
        [deleteButton setBackgroundColor: [UIColor grayColor]];
        [deleteButton setTitle:@"-" forState: UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:deleteButton];
        [deleteButton setHidden:true];
    }
    else if (cellProperty == TransactionCell) {
        self.userInteractionEnabled = YES;
        editable = true;
        deletable = true;
        [self setTextAlignment:NSTextAlignmentRight];
    }
    else if (cellProperty == SummaryTitleCell) {
        editable = false;
        [self setTextAlignment:NSTextAlignmentLeft];
    }
    else if (cellProperty == SummaryContentCell) {
        editable = false;
        [self setTextAlignment:NSTextAlignmentRight];
    }
    else if (cellProperty == SummaryBudgetCell) {
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
    return CGSizeMake(cellWidth + cellGap * 2, cellHeight + cellGap * 2);
}

- (void) editing
{
    if ((self.longPressRecog.state != UIGestureRecognizerStateBegan) &&
        (self.longPressRecog.state != UIGestureRecognizerStatePossible)) {
        return;
    }
    [self setBackgroundColor: [UIColor grayColor]];
    
    if (editable) {
        if (cellProperty == DateCell) {
            
        }
        else {
            UIAlertView *updateCell = [[UIAlertView alloc] init];
            
            [updateCell setDelegate:self];
            [updateCell addButtonWithTitle:@"Cancel"];
            [updateCell addButtonWithTitle:@"Done"];
            //[updateCell addButtonWithTitle:@"Delete"];
            
            [updateCell setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [[updateCell textFieldAtIndex:0] setClearsOnBeginEditing:true];
            
            if (cellProperty == CategoryCell) {
                [updateCell setTitle: [NSString stringWithFormat: @"Change Name: \n%@", [self text]]];
                [[updateCell textFieldAtIndex:0] setKeyboardType: UIKeyboardTypeAlphabet];
                [[updateCell textFieldAtIndex:0] setPlaceholder: [NSString stringWithFormat:@"%@", [self text]]];
            }
            else if (cellProperty == TransactionCell) {
                LedgerContentViewController *ledgerPage = (LedgerContentViewController *)[[[self superview] superview] nextResponder];
                NSArray *dateViewArray = [ledgerPage.dateView subviews];
                NSMutableArray *cateViewArray =  [[NSMutableArray alloc] initWithArray:[ledgerPage.categoryView subviews]];
                CGPoint pt = [self frame].origin;
                int cIndex = (int) (pt.y / (cellHeight + cellGap));
                int dIndex = (int) (pt.x / (cellWidth + cellGap));
                
                [updateCell setTitle: [NSString stringWithFormat:@"$ for %@ on \n%@",
                                       [[cateViewArray objectAtIndex:cIndex] text],[[dateViewArray objectAtIndex:dIndex] text]]];
                [[updateCell textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
                
                if ([[self text] isEqual:@"0"])
                    [[updateCell textFieldAtIndex:0] setPlaceholder:@"0.00"];
                else
                    [[updateCell textFieldAtIndex:0] setPlaceholder:[self text]];
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

- (void) translate {
    CGPoint displace = [self.dragRecog translationInView: self.superview];
    //int index = [[self.superview subviews] indexOfObject: self];
    //CGPoint pt = [self.transactionLongPressRecog locationInView: self.transactionView];
    
    if ((self.dragRecog.state == UIGestureRecognizerStateBegan)) {
        [self setBackgroundColor: [UIColor grayColor]];
    }
    
    if ((self.dragRecog.state == UIGestureRecognizerStateEnded)) {
        [self setBackgroundColor: [UIColor lightGrayColor]];
    }
    
    if (cellProperty == CategoryCell) {
        //NSMutableArray *cateViewArray = [[NSMutableArray alloc] initWithArray:[self.superview subviews]];
        [self setCenter: CGPointMake(self.center.x + displace.x, self.center.y)];
        [self.dragRecog setTranslation:CGPointMake(0, 0) inView:self.superview];
        
        if ((self.dragRecog.state == UIGestureRecognizerStateEnded)) {
            if (self.center.x >= self.superview.frame.size.width || self.center.x <= self.superview.frame.origin.x){
                
                //[[[self subviews] objectAtIndex:0] setHidden:false];
                
                UIAlertView *deleteCategory = [[UIAlertView alloc] init];
                
                [deleteCategory setDelegate:self];
                [deleteCategory addButtonWithTitle:@"Cancel"];
                [deleteCategory addButtonWithTitle:@"Done"];
                [deleteCategory setTitle: [NSString stringWithFormat: @"Delete Category: %@", [self text]]];
                [deleteCategory setMessage:@"This will delete all transactions that are under this category."];
                [deleteCategory show];
            }
            
            [self setCenter: CGPointMake(self.superview.frame.origin.x + cellWidth / 2 + cellGap, self.center.y)];
        }
    }
    else if (cellProperty == TransactionCell) {
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LedgerContentViewController *ledgerPage = (LedgerContentViewController *)[[[self superview] superview] nextResponder];
    LedgerDB *db = [ledgerPage ledgerDB];
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Done"]) {
        if ([alertView alertViewStyle] == UIAlertViewStylePlainTextInput) {
            if(cellProperty == CategoryCell)
            {
                [db updateCategory: [self text] andNewName:[[alertView textFieldAtIndex:0] text]];
                if ([db succeed])
                    [self setText:[[alertView textFieldAtIndex:0] text]];
            }
            else if (cellProperty == TransactionCell) {
                NSString *amount = [[alertView textFieldAtIndex:0] text];
                NSMutableArray *cateViewArray =  [[NSMutableArray alloc] initWithArray:[ledgerPage.categoryView subviews]];
                
                int cIndex = (int) ([self frame].origin.y / (cellHeight + cellGap));
                int dIndex = (int) ([self frame].origin.x / (cellWidth + cellGap));
                
                [db updateTransactions: ledgerPage.dateArray[dIndex]
                                andCID: [db getCID:[((LedgerCell *)[cateViewArray objectAtIndex:cIndex]) text]]
                             andAmount: [NSNumber numberWithDouble:[amount doubleValue]]];
                
                if ([db succeed]) {
                    [self setText:[NSString stringWithFormat:@"%.2f", [amount doubleValue]]];
                    //Update summary view
                    NSArray *summViewArray = ledgerPage.summaryContentView.subviews;
                    NSNumber *total, *budget;
                    total = [db getTotal:[ledgerPage.dateArray objectAtIndex:dIndex]];
                    budget = [db getBudget:[ledgerPage.dateArray objectAtIndex:dIndex]];
                    
                    //Index of Total Label
                    int sIndex = dIndex * 3;
                    [((LedgerCell *)[summViewArray objectAtIndex:sIndex]) setText: [total stringValue]];
                    //Index of Available Label
                    sIndex += 2;
                    [((LedgerCell *)[summViewArray objectAtIndex:sIndex]) setText: [NSString stringWithFormat:@"%.2f", [budget doubleValue] - [total doubleValue]]];
                }
            }
            else if (cellProperty == SummaryBudgetCell) {
                NSArray *summArray = [[self superview] subviews];
                int sIndex = ([summArray indexOfObject:self] - 1) / 3;
                NSNumber *total = [NSNumber numberWithDouble:[[((LedgerCell*)[summArray objectAtIndex:sIndex * 3]) text] doubleValue]];
                NSNumber *budget = [[NSNumber alloc] init];
                
                if ([[[alertView textFieldAtIndex:0] text] isEqual:@""]) {
                    budget = [NSNumber numberWithDouble:[[[alertView textFieldAtIndex:0] placeholder] doubleValue]];
                }
                else {
                    budget = [NSNumber numberWithDouble:[[[alertView textFieldAtIndex:0] text] doubleValue]];
                }
                [db updateBudget:ledgerPage.dateArray[sIndex] andBudget: budget];
                if ([db succeed]) {
                    [self setText:[NSString stringWithFormat:@"%.2f", [budget doubleValue]]];
                    [((LedgerCell*)[summArray objectAtIndex:sIndex * 3 + 2]) setText: [NSString stringWithFormat:@"%.2f", [budget doubleValue] - [total doubleValue]]];
                }
            }
        }
        else if ([alertView alertViewStyle] == UIAlertViewStyleDefault){
            [self deleteCell:db];
        }
    }
    
    cellStatus = INITIAL_CELL;
    [self setBackgroundColor: [UIColor lightGrayColor]];
}

-(void) deleteCell {
    if (cellProperty == CategoryCell) {
        LedgerContentViewController *ledgerPage = (LedgerContentViewController *)[[[self superview] superview] nextResponder];
        LedgerDB *db = [ledgerPage ledgerDB];
        [db deleteCategory:[self text]];
        if([db succeed]) {
            [ledgerPage reloadDB];
        }
    }
    else if (cellProperty == TransactionCell) {
        
    }
}

- (void) hideButton {
    NSLog(@"Test");
    [[[self subviews] objectAtIndex:0] setHidden: true];
}
-(void) deleteCell: (LedgerDB *) db{
    if (cellProperty == CategoryCell) {
        LedgerContentViewController *ledgerPage = (LedgerContentViewController *)[[[self superview] superview] nextResponder];
        [db deleteCategory:[self text]];
        if([db succeed]) {
            [ledgerPage reloadDB];
        }
    }
    else if (cellProperty == TransactionCell) {
    
    }
}
@end
