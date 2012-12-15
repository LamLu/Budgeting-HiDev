//
//  LedgerContentViewController.m
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/21/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerContentViewController.h"
#import "LedgerPageViewController.h"
#import "LedgerCell.h"

@interface LedgerContentViewController ()

@end

@implementation LedgerContentViewController
@synthesize dateArray;
@synthesize ledgerDB;


- (id) initWithDB: (LedgerDB *)aLedgerDb andDateArray: (NSMutableArray *) aDateArray 
{
    self = [super init];
    if (self) {
        [self setLedgerDB: aLedgerDb];
        [self setDateArray:aDateArray];
        [self setUpSubViews];
        [self initialize];
        [self creatingObservers];
        [self.view setUserInteractionEnabled:true];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) setUpSubViews
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    //do NOT change this order, their position are depending on each other.
    //set the summary title pos
    self.summaryTitleView = [[LedgerSummaryTitleView alloc]
                            initWithFrame: CGRectMake( 0,
                                                       screenHeight - [LedgerCell getCellSize].height * 3 - 18,
                                                       [LedgerCell getCellSize].width,
                                                       [LedgerCell getCellSize].height * 3)
                              andDatabase: ledgerDB];
    
    self.dateRowView = [[LedgerDateRowView alloc]
                            initWithFrame: CGRectMake( self.summaryTitleView.frame.size.width,
                                                       0,
                                                       screenWidth - [LedgerCell getCellSize].width,
                                                       [LedgerCell getCellSize].height * 2)
                              andDatabase: ledgerDB
                                 andArray: [self dateArray]];
    
    self.summaryContentView = [[LedgerSummaryContentView alloc]
                            initWithFrame: CGRectMake( self.dateRowView.frame.origin.x,
                                                       self.summaryTitleView.frame.origin.y,
                                                       self.dateRowView.frame.size.width,
                                                       self.summaryTitleView.frame.size.height)
                              andDatabase: ledgerDB
                              andDateView: self.dateRowView
                      andSummaryTitleView: self.summaryTitleView];
    
    self.categoryView = [[LedgerCategoryColumnView alloc]
                            initWithFrame: CGRectMake( self.summaryTitleView.frame.origin.x,
                                                       self.dateRowView.frame.size.height,
                                                       self.summaryTitleView.frame.size.width,
                                                       self.summaryTitleView.frame.origin.y - self.dateRowView.frame.size.height)
                              andDatabase: self.ledgerDB
                              andDateView: self.dateRowView
                      andSummaryTitleView: self.summaryTitleView];
   
    self.transactionView = [[LedgerTransactionView alloc]
                            initWithFrame: CGRectMake( self.dateRowView.frame.origin.x,
                                                       self.categoryView.frame.origin.y,
                                                       self.dateRowView.frame.size.width,
                                                       self.categoryView.frame.size.height)
                              andDatabase: self.ledgerDB
                              andDateView: self.dateRowView
                    andCategoryColumnView: self.categoryView];
}

- (void) initialize {
    CGPoint tempP = CGPointMake(self.dateRowView.todayPos.x - (self.dateRowView.frame.size.width - cellWidth) / 2,
                                0);
    
    if (tempP.x < 0) {
        tempP.x = 0;
    }
    
    [self setOffsetToPos:tempP];
    [self.view addSubview:self.summaryTitleView];
    [self.view addSubview:self.dateRowView];
    [self.view addSubview:self.summaryContentView];
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.transactionView];
}

- (void) creatingObservers {
    //add observers on transactionView
    [self.transactionView addObserver:self.summaryContentView forKeyPath:@"transaction_Update" options:NSKeyValueObservingOptionOld context:nil];
}

- (void) setOffsetAtDate:(NSDate *) date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd"];
    
    int dIndex = [[dateFormat stringFromDate: date] integerValue] - 1;
    LedgerCell *cell = [[self.dateRowView subviews] objectAtIndex:dIndex];

    CGPoint tempP = CGPointMake(cell.frame.origin.x - (self.dateRowView.frame.size.width - cellWidth) / 2, 0);
    [self setOffsetToPos:tempP];
}

- (void) setOffsetToPos:(CGPoint) pos {
    if (pos.x < 0) {
        pos.x = 0;
    }
    [self.dateRowView setContentOffset:pos];
    [self.transactionView setContentOffset:CGPointMake(pos.x, [self.transactionView contentOffset].y)];
    [self.summaryContentView setContentOffset:pos];
}

- (void) dealloc
{
    //deallocate transactionview's observers
    [self.transactionView removeObserver:self.summaryContentView forKeyPath:@"transaction_Update"];
}

- (void) updateCategoryColumn
{
    NSArray *tempViewControllers = [[self parentViewController] childViewControllers];
    for (int i = 0; i < [tempViewControllers count]; i++) {
        [[[tempViewControllers objectAtIndex:i] categoryView] reloadView];
    }
    [self.transactionView reloadView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) test {
    NSLog(@"%@", [[[self parentViewController] parentViewController] class ]);
}
@end
