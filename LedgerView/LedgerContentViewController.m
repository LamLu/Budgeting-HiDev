//
//  LedgerContentViewController.m
//  LedgerView
//
//  Created by YenHsiang Wang on 10/27/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerContentViewController.h"

@interface LedgerContentViewController () 

@end

@implementation LedgerContentViewController
@synthesize transactionLongPressRecog;
@synthesize dateArray;
@synthesize ledgerDB;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //ledgerDB = [[LedgerDB alloc] initDB];
    [self setUpSubViews];
}

- (void) setUpSubViews
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    //do NOT change this order, their position are depending on each other.
    //set the summary title pos
    [self buildSummaryTitleView:
        CGRectMake(0,
                   screenHeight - [LedgerCell getCellSize].height * 3 - 16,
                   [LedgerCell getCellSize].width,
                   [LedgerCell getCellSize].height * 3)];
   
    //set the dateRow pos
    [self buildDateView:
        CGRectMake(self.summaryTitleView.frame.origin.x + [LedgerCell getCellSize].width + cellGap * 2,
                   0,
                   screenWidth - [LedgerCell getCellSize].width - 3 * cellGap,
                   [LedgerCell getCellSize].height * 2 - 2)];
    
    //set the summary content pos
    [self buildSummaryContentView:
        CGRectMake(self.dateView.frame.origin.x,
                   self.summaryTitleView.frame.origin.y,
                   self.dateView.frame.size.width,
                   self.summaryTitleView.frame.size.height)];
    
    //set the categoryColumn pos
    [self buildCategoryView:
        CGRectMake(self.summaryTitleView.frame.origin.x,
                   self.dateView.frame.size.height + cellGap * 2,
                   self.summaryTitleView.frame.size.width,
                   self.summaryTitleView.frame.origin.y - self.dateView.frame.size.height - cellGap * 4)];
    
    //set the transactionView pos
    [self buildTransactionsView:
        CGRectMake(self.dateView.frame.origin.x,
                   self.categoryView.frame.origin.y,
                   self.dateView.frame.size.width,
                   self.categoryView.frame.size.height)];
    
    [self setOffsetToPos:todayPos];
    [self.view addSubview:self.transactionView];
    [self.view addSubview:self.dateView];
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.summaryTitleView];
    [self.view addSubview:self.summaryContentView];
    self.transactionView.delegate = self;
}

- (void) buildDateView:(CGRect) aFrame
{
    [self.dateView setFrame: aFrame];
    [self.dateView setBackgroundColor: [UIColor brownColor]];
    [self.dateView setContentSize:
     CGSizeMake([dateArray count] * (cellWidth + cellGap) + 1,
                ((cellHeight + cellGap) + 1))];
    
    CGPoint pos = CGPointMake(1, 1);
    self->todayPos = CGPointMake(0,0);
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd\nEEEE"];
    
    for (int i = 0; i < [dateArray count]; i++) {
        [self.dateView addSubview:
         [[LedgerCell alloc] initWithFrame: CGRectMake(pos.x, pos.y, cellWidth, cellHeight * 2)
                                   andText: [dateFormat stringFromDate: dateArray[i]]
                               andProperty: DateCell]];
        if ([[dateFormat stringFromDate: dateArray[i]] isEqual: [dateFormat stringFromDate: today]]) {
            self->todayPos = CGPointMake(pos.x - cellGap * 2 - (aFrame.size.width - cellWidth) / 2, pos.y - cellGap);
            [((LedgerCell *)[[self.dateView subviews] objectAtIndex: [[self.dateView subviews] count] - 1]) setBackgroundColor: [UIColor grayColor]];
        }
        pos.x += cellWidth + cellGap;
    }
}

- (void) buildSummaryTitleView:(CGRect) aFrame
{
    [self.summaryTitleView setFrame: aFrame];
    [self.summaryTitleView setBackgroundColor: [UIColor brownColor]];
    CGPoint pos = CGPointMake(1, 1);
    NSArray *titleArray = [NSArray arrayWithObjects:@"Total:", @"Budget:", @"Availabale:", nil];
    for (int i = 0; i < [titleArray count]; i++) {
        [self.summaryTitleView addSubview:
         [[LedgerCell alloc] initWithFrame: CGRectMake(pos.x, pos.y, cellWidth, cellHeight)
                                   andText: [titleArray objectAtIndex:i]
                               andProperty: SummaryTitleCell]];
        pos.y += cellHeight + cellGap;
    }
}

- (void) buildSummaryContentView:(CGRect) aFrame
{
    [self.summaryContentView setFrame: aFrame];
    [self.summaryContentView setBackgroundColor: [UIColor brownColor]];
    [self.summaryContentView setContentSize:
     CGSizeMake([dateArray count] * (cellWidth + cellGap) + 1,
                ((cellHeight + cellGap) * 3 + 1))];
    [self reloadSummaryContentView];
}

- (void) buildCategoryView:(CGRect) aFrame
{
    [self.categoryView setFrame: aFrame];
    [self.categoryView setBackgroundColor: [UIColor brownColor]];
    [self reloadCategoryView];
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

- (void) buildTransactionsView:(CGRect) aFrame
{
    [self.transactionView setFrame: aFrame];
    [self.transactionView setBackgroundColor: [UIColor brownColor]];
    [self.transactionView setContentSize:
        CGSizeMake([self.dateView.subviews count] * (cellWidth + cellGap) + 1,
                   ([self.categoryView.subviews count] - 1)* (cellHeight + cellGap) + 1)];
    
    //Adding UILongPressGestureRecognizer
    self.transactionLongPressRecog = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addingTransaction)];
    [self.transactionLongPressRecog setMinimumPressDuration:1];
    [self.transactionView addGestureRecognizer:self.transactionLongPressRecog];
    self.transactionView.userInteractionEnabled = YES;
    
    [self reloadTransactionView];
}

- (void) addingTransaction{
    if (self.transactionLongPressRecog.state != UIGestureRecognizerStateBegan) {
        return;
    }
    NSArray *dateViewArray = self.dateView.subviews;
    NSMutableArray *cateViewArray = [[NSMutableArray alloc] initWithArray:self.categoryView.subviews];
    [cateViewArray removeObjectAtIndex: [cateViewArray count] - 1];
    CGPoint pt = [self.transactionLongPressRecog locationInView: self.transactionView];
    int cIndex = (int) (pt.y / (cellHeight + cellGap));
    int dIndex = (int) (pt.x / (cellWidth + cellGap));
    
    if (cIndex < [cateViewArray count] && dIndex < [dateViewArray count]) {
        UIAlertView *addingTransaction = [[UIAlertView alloc] init];
        [addingTransaction setDelegate:self];
        [addingTransaction setTitle: [NSString stringWithFormat:@"$ for %@ on \n%@",
                [[cateViewArray objectAtIndex:cIndex] text], [[dateViewArray objectAtIndex:dIndex] text]]];
        [addingTransaction addButtonWithTitle:@"Cancel"];
        [addingTransaction addButtonWithTitle:@"Done"];
        
        [addingTransaction setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[addingTransaction textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
        [[addingTransaction textFieldAtIndex:0] setPlaceholder:@"0.00"];
        [addingTransaction show];
        CGPoint cellPt = CGPointMake([[dateViewArray objectAtIndex:dIndex] frame].origin.x, [[cateViewArray objectAtIndex:cIndex] frame].origin.y);
        LedgerCell *addedTransaction =
        [[LedgerCell alloc]initWithFrame:CGRectMake(cellPt.x, cellPt.y, cellWidth, cellHeight)
                                 andText:[NSString stringWithFormat:@"0.00"]
                             andProperty:TransactionCell];
        [self.transactionView addSubview:addedTransaction];
    }
}

- (void) setOffsetToPos:(CGPoint) pos
{
    [self.dateView setContentOffset:pos];
    [self.transactionView setContentOffset:pos];
    [self.summaryContentView setContentOffset:pos];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = [self.transactionView contentOffset];
    [self.dateView setContentOffset:CGPointMake(offset.x, 0) animated:NO];
    [self.summaryContentView setContentOffset:CGPointMake(offset.x, 0) animated:NO];
    [self.categoryView setContentOffset:CGPointMake(0, offset.y) animated:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSString *placeHolder = [[alertView textFieldAtIndex:0] placeholder];
    
    if([title isEqualToString:@"Done"] && [placeHolder isEqualToString:@"New Category"])
    {
        NSMutableArray *cateViewArray = [[NSMutableArray alloc] initWithArray:self.categoryView.subviews];
        int cIndex = [cateViewArray count] - 1;
        CGPoint pt = CGPointMake([[cateViewArray objectAtIndex:cIndex] frame].origin.x,
                                 [[cateViewArray objectAtIndex:cIndex] frame].origin.y);
        
        LedgerCell *aNewCategory =
        [[LedgerCell alloc] initWithFrame: CGRectMake(pt.x, pt.y, cellWidth, cellHeight)
                                  andText: [[alertView textFieldAtIndex:0] text]
                              andProperty: CategoryCell];
        
        [self.categoryView insertSubview:aNewCategory atIndex:cIndex];
        
        [[cateViewArray objectAtIndex:cIndex] setCenter:
         CGPointMake([[cateViewArray objectAtIndex:cIndex] center].x,
                     [[cateViewArray objectAtIndex:cIndex] center].y + cellHeight + cellGap)];
        
        [ledgerDB insertCategory: [[alertView textFieldAtIndex:0] text]];
        
        [self.categoryView setContentSize:
         CGSizeMake([self.categoryView frame].size.width,
                    ([self.categoryView.subviews count] - 1)* (cellHeight + cellGap) + 1)];
        
        [self.transactionView setContentSize:
         CGSizeMake([self.dateView.subviews count] * (cellWidth + cellGap) + 1,
                    ([self.categoryView.subviews count])* (cellHeight + cellGap) + 1)];
    }
    else if ([title isEqualToString:@"Done"] && [placeHolder isEqualToString:@"0.00"]) {
        NSArray *transactionViewArray = self.transactionView.subviews;
        LedgerCell *temp = [transactionViewArray objectAtIndex: [transactionViewArray count] - 1];
        [temp setText: [NSString stringWithFormat:@"%.2f", [[[alertView textFieldAtIndex:0] text] doubleValue]]];
        
        //inserting data to the database
        NSMutableArray *cateViewArray = [[NSMutableArray alloc] initWithArray:self.categoryView.subviews];
        [cateViewArray removeObjectAtIndex: [cateViewArray count] - 1];
        int cIndex = (int) ([temp frame].origin.y / (cellHeight + cellGap));
        int dIndex = (int) ([temp frame].origin.x / (cellWidth + cellGap));
    
        [ledgerDB insertBudget: dateArray[dIndex] andBudget:0];
        [ledgerDB insertTransactions: dateArray[dIndex]
                              andCID: [ledgerDB getCID:[((LedgerCell *)[cateViewArray objectAtIndex:cIndex]) text]]
                           andAmount: [NSNumber numberWithDouble:[[temp text] doubleValue]]];
        
        //Update summary view
        NSArray *summViewArray = self.summaryContentView.subviews;
        NSNumber *total, *budget;
        total = [ledgerDB getTotal:[dateArray objectAtIndex:dIndex]];
        budget = [ledgerDB getBudget:[dateArray objectAtIndex:dIndex]];
        
        //Index of Total Label
        int sIndex = dIndex * 3;
        [((LedgerCell *)[summViewArray objectAtIndex:sIndex]) setText: [total stringValue]];
        //Index of Available Label
        sIndex += 2;
        [((LedgerCell *)[summViewArray objectAtIndex:sIndex]) setText: [NSString stringWithFormat:@"%.2f", [budget doubleValue] - [total doubleValue]]];
    }
    else if ([title isEqualToString:@"Cancel"] && [placeHolder isEqualToString:@"0.00"]) {
        [[self.transactionView.subviews objectAtIndex:[self.transactionView.subviews count] - 1] removeFromSuperview];
    }
}

- (void) reloadDB {
    [self reloadCategoryView];
    [self reloadSummaryContentView];
    [self reloadTransactionView];
}

- (void) reloadCategoryView {
    while ([[self.categoryView subviews] count] != 0) {
        [[[self.categoryView subviews] objectAtIndex:0] removeFromSuperview];
    }
    NSMutableArray *categories = [ledgerDB getCategories];
    CGPoint pos = CGPointMake(1, 1);
    for (int i = 0; i < [categories count]; i++) {
        [self.categoryView addSubview:
         [[LedgerCell alloc] initWithFrame: CGRectMake(pos.x, pos.y, cellWidth, cellHeight)
                                   andText: [categories objectAtIndex:i]
                               andProperty: CategoryCell]];
        pos.y += cellHeight + cellGap;
    }
    
    UIButton *addCategory = [[UIButton alloc] initWithFrame:CGRectMake(pos.x, pos.y, cellWidth, cellHeight)];
    
    [addCategory setBackgroundColor: [UIColor grayColor]];
    [addCategory setTitle:@"+" forState: UIControlStateNormal];
    [addCategory addTarget:self action:@selector(addNewCategory) forControlEvents:UIControlEventTouchUpInside];
    
    [self.categoryView addSubview:addCategory];
}

- (void) reloadTransactionView {
    while ([[self.transactionView subviews] count] != 0) {
        [[[self.transactionView subviews] objectAtIndex:0] removeFromSuperview];
    }
    NSMutableArray *cNameList = [ledgerDB getCategories];
    NSArray *dateViewArray = self.dateView.subviews;
    NSMutableArray *cateViewArray = [[NSMutableArray alloc] initWithArray:self.categoryView.subviews];
    [cateViewArray removeObjectAtIndex: [cateViewArray count] - 1];
    NSNumber *amount = [NSNumber alloc];
    NSMutableDictionary *transactions = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i <[dateArray count]; i++){
        transactions = [ledgerDB getTransactions:[dateArray objectAtIndex:i]];
        for (int j = 0; j < [[transactions allKeys] count]; j++) {
            NSString *cName = [[transactions allKeys] objectAtIndex:j];
            NSInteger cIndex = [cNameList indexOfObject: cName];
            amount = [transactions objectForKey:cName];
            
            if (amount != nil) {
                CGPoint pt = CGPointMake([[dateViewArray objectAtIndex:i] frame].origin.x, [[cateViewArray objectAtIndex:cIndex] frame].origin.y);
                [self.transactionView addSubview:
                 [[LedgerCell alloc] initWithFrame: CGRectMake(pt.x, pt.y, cellWidth, cellHeight)
                                           andText: [NSString stringWithFormat:@"%.2f", [amount doubleValue]]
                                       andProperty: TransactionCell]];
            }
        }
    }
}

- (void) reloadSummaryContentView {
    while ([[self.summaryContentView subviews] count] != 0) {
        [[[self.summaryContentView subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    NSArray *dateViewArray = self.dateView.subviews;
    NSArray *sumTitleViewArray = self.summaryTitleView.subviews;
    NSNumber *budget = [NSNumber alloc];
    NSNumber *total = [NSNumber alloc];
    
    for (int i = 0; i < [dateArray count]; i++) {
        CGRect dateLabel = [[dateViewArray objectAtIndex:i] frame];
        
        // 0 = total; 1 = budget; 2 = available
        total = [ledgerDB getTotal:[dateArray objectAtIndex:i]];
        CGRect summaryTotalLabel = [[sumTitleViewArray objectAtIndex:0] frame];
        [self.summaryContentView addSubview:
         [[LedgerCell alloc] initWithFrame: CGRectMake(dateLabel.origin.x, summaryTotalLabel.origin.y, cellWidth, cellHeight)
                                   andText: [NSString stringWithFormat:@"%.2f", [total doubleValue]]
                               andProperty: SummaryContentCell]];
        // budget
        budget = [ledgerDB getBudget:[dateArray objectAtIndex:i]];
        CGRect summaryBudgetLabel = [[sumTitleViewArray objectAtIndex:1] frame];
        [self.summaryContentView addSubview:
         [[LedgerCell alloc] initWithFrame: CGRectMake(dateLabel.origin.x, summaryBudgetLabel.origin.y, cellWidth, cellHeight)
                                   andText: [NSString stringWithFormat:@"%.2f", [budget doubleValue]]
                               andProperty: SummaryBudgetCell]];
        // available
        CGRect summaryAvaiLabel = [[sumTitleViewArray objectAtIndex:2] frame];
        
        [self.summaryContentView addSubview:
         [[LedgerCell alloc] initWithFrame: CGRectMake(dateLabel.origin.x, summaryAvaiLabel.origin.y, cellWidth, cellHeight)
                                   andText: [NSString stringWithFormat:@"%.2f", [budget doubleValue] - [total doubleValue]]
                               andProperty: SummaryContentCell]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
