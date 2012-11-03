//
//  LedgerContentViewController.m
//  LedgerView
//
//  Created by YenHsiang Wang on 10/27/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerContentViewController.h"

@interface LedgerContentViewController (private)
- (void) setUpSubViews;
- (void) buildDateView:(CGRect) aFrame;
- (void) buildSummaryTitleView:(CGRect) aFrame;
- (void) buildSummaryContentView:(CGRect) aFrame;
- (void) buildCategoryView:(CGRect) aFrame;
- (void) buildTransactionsView:(CGRect) aFrame;
- (UILabel *) createCell: (NSString *) value andPos: (CGPoint) position andSize: (CGSize) size;
@end

static const int cellWidth = 100;
static const int cellHeight = 33;
static const int cellGap = 1;

@implementation LedgerContentViewController

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
    ledgerDB = [[LedgerDB alloc] initDB];
    [self setUpSubViews];
    [self.view addSubview:self.transactionView];
    [self.view addSubview:self.dateView];
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.summaryTitleView];
    [self.view addSubview:self.summaryContentView];
    self.transactionView.delegate = self;
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
                   screenHeight - (cellHeight + cellGap) * 3 - 21,
                   cellWidth + cellGap * 2,
                   (cellHeight + cellGap) * 3 + cellGap)];
   
    //set the dateRow pos
    [self buildDateView:
        CGRectMake(self.summaryTitleView.frame.origin.x + cellWidth + cellGap * 4,
                   0,
                   screenWidth - cellWidth - cellGap * 2,
                   cellHeight * 2 + cellGap * 2)];
    
    //set the summary content pos
    [self buildSummaryContentView:
        CGRectMake(self.summaryTitleView.frame.origin.x + cellWidth + cellGap * 4,
                   self.summaryTitleView.frame.origin.y,
                   screenWidth - cellWidth - cellGap * 2,
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
}

- (void) buildDateView:(CGRect) aFrame
{
    [self.dateView setFrame: aFrame];
    [self.dateView setBackgroundColor: [UIColor brownColor]];
    CGPoint pos = CGPointMake(1, 1);
    for (int i = 0; i < 7; i++) {
        [self.dateView addSubview:
            [self createCell: [NSString stringWithFormat:@"2012100%d", i + 1]
                      andPos: CGPointMake(pos.x, pos.y)
                     andSize: CGSizeMake(cellWidth, cellHeight * 2)
                andAlignment: NSTextAlignmentCenter]];
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
            [self createCell: [titleArray objectAtIndex:i]
                      andPos: CGPointMake(pos.x, pos.y)
                     andSize: CGSizeMake(cellWidth, cellHeight)
                andAlignment: NSTextAlignmentLeft]];
        pos.y += cellHeight + cellGap;
    }
}

- (void) buildSummaryContentView:(CGRect) aFrame
{
    [self.summaryContentView setFrame: aFrame];
    [self.summaryContentView setBackgroundColor: [UIColor brownColor]];
    
    NSArray *dateViewArray = self.dateView.subviews;
    NSArray *sumTitleViewArray = self.summaryTitleView.subviews;
    NSNumber *budget = [NSNumber alloc];
    NSNumber *total = [NSNumber alloc];
    
    for (int i = 0; i < [dateViewArray count]; i++) {
        CGRect dateLabel = [[dateViewArray objectAtIndex:i] frame];
        
        // 0 = total; 1 = budget; 2 = available
        total = [ledgerDB getTotal:[[dateViewArray objectAtIndex:i] text]];
        CGRect summaryTotalLabel = [[sumTitleViewArray objectAtIndex:0] frame];
        [self.summaryContentView addSubview:
            [self createCell: [NSString stringWithFormat:@"%.2f", [total doubleValue]]
                      andPos: CGPointMake(dateLabel.origin.x, summaryTotalLabel.origin.y)
                     andSize: CGSizeMake(cellWidth, cellHeight)
                andAlignment: NSTextAlignmentRight]];
        
        // budget
        budget = [ledgerDB getBudget:[[dateViewArray objectAtIndex:i] text]];
        CGRect summaryTitleLabel = [[sumTitleViewArray objectAtIndex:1] frame];
        [self.summaryContentView addSubview:
            [self createCell: [NSString stringWithFormat:@"%.2f", [budget doubleValue]]
                      andPos: CGPointMake(dateLabel.origin.x, summaryTitleLabel.origin.y)
                     andSize: CGSizeMake(cellWidth, cellHeight)
                andAlignment: NSTextAlignmentRight]];
       
        // available
        CGRect summaryAvaiLabel = [[sumTitleViewArray objectAtIndex:2] frame];
        [self.summaryContentView addSubview:
            [self createCell: [NSString stringWithFormat:@"%.2f", [budget doubleValue] - [total doubleValue]]
                      andPos: CGPointMake(dateLabel.origin.x, summaryAvaiLabel.origin.y)
                     andSize: CGSizeMake(cellWidth, cellHeight)
                andAlignment: NSTextAlignmentRight]];
    }
    
    /*
    CGPoint pos = CGPointMake(1, 1);
    for (int i = 0; i < [self.dateView.subviews count]; i++) {
        for (int j = 0; j < [self.summaryTitleView.subviews count]; j++) {
            [self.summaryContentView addSubview:
                [self createCell: [NSString stringWithFormat:@"%d", (j + 1) * 10 + i + 1]
                          andPos: CGPointMake(pos.x, pos.y)
                         andSize: CGSizeMake(cellWidth, cellHeight)]];
            pos.y += cellHeight + cellGap;
        }
        pos.x += cellWidth + cellGap;
        pos.y = 1;
    }
     */
}

- (void) buildCategoryView:(CGRect) aFrame
{
    [self.categoryView setFrame: aFrame];
    [self.categoryView setBackgroundColor: [UIColor brownColor]];
    NSMutableArray *categories = [ledgerDB getCategories];
    CGPoint pos = CGPointMake(1, 1);
    for (int i = 0; i < [categories count]; i++) {
        [self.categoryView addSubview:
            [self createCell: [categories objectAtIndex:i]
                      andPos: CGPointMake(pos.x, pos.y)
                     andSize: CGSizeMake(cellWidth, cellHeight)
                andAlignment: NSTextAlignmentRight]];
        pos.y += cellHeight + cellGap;
    }
    //UIButton *addCategory = [[UIButton alloc] initWithFrame:CGRectMake(pos.x, pos.y, cellWidth, cellHeight)];
    LedgerCell *addCategory = [[LedgerCell alloc]initWithFrame:CGRectMake(pos.x, pos.y, cellWidth, cellHeight) andText:@"+"];
    //UIButton *addCategory = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //[addCategory setFrame:CGRectMake(pos.x, pos.y, cellWidth, cellHeight)];
    [addCategory setBackgroundColor: [UIColor grayColor]];
    [self.categoryView addSubview:addCategory];
}

- (void) buildTransactionsView:(CGRect) aFrame
{
    [self.transactionView setFrame: aFrame];
    [self.transactionView setBackgroundColor: [UIColor brownColor]];
    [self.transactionView setContentSize:
        CGSizeMake([self.dateView.subviews count] * (cellWidth + cellGap) + 1,
                   ([self.categoryView.subviews count] - 1)* (cellHeight + cellGap) + 1)];
    
    NSArray *dateArray = [[NSArray alloc]initWithObjects:@"20121001", @"20121002", @"20121003", nil];
    NSMutableArray *cNameList = [ledgerDB getCategories];
    NSArray *dateViewArray = self.dateView.subviews;
    NSMutableArray *cateViewArray = [[NSMutableArray alloc] initWithArray:self.categoryView.subviews];
    [cateViewArray removeObjectAtIndex: [cateViewArray count] - 1];
    
    NSNumber *amount = [NSNumber alloc];
    
    for (int i = 0; i <[dateArray count]; i++ ){
        for (int j = 0; j < [cateViewArray count]; j++) {
            amount = [ledgerDB getAmount:dateArray[i] andCategoryName:cNameList[j]];
            if (amount != nil) {
                CGRect dateLabel = [[dateViewArray objectAtIndex:i] frame];
                CGRect categoryLabel = [[cateViewArray objectAtIndex:j] frame];
                [self.transactionView addSubview:
                    [self createCell: [NSString stringWithFormat:@"%.2f", [amount doubleValue]]
                            andPos: CGPointMake(dateLabel.origin.x, categoryLabel.origin.y)
                             andSize: CGSizeMake(cellWidth, cellHeight)
                        andAlignment: NSTextAlignmentRight]];
            }
        }
    }
    
    //NSString * cName = [[[self.categoryView.subviews objectAtIndex:0] textFieldAtIndex:0] text];
    //NSLog(@"%@", cName);
    
    /*
    int xPos = 1;
    int yPos = 1;
    for (int i = 0; i < [self.dateView.subviews count]; i++) {
        for(int i = 0; i < [self.categoryView.subviews count]; i++) {
            [self.transactionView addSubview: [self createCell: [NSString stringWithFormat:@""] andPos:CGPointMake(xPos, yPos) andSize:CGSizeMake(cellWidth, cellHeight)]];
            yPos += cellHeight + cellGap;
        }
        xPos += cellWidth + cellGap;
        yPos = 1;
    }
     */
}

- (UILabel *) createCell: (NSString *) value andPos: (CGPoint) position andSize: (CGSize) size andAlignment: (NSTextAlignment) alignment
{
    UILabel *cell = [[UILabel alloc] initWithFrame:CGRectMake(position.x, position.y, size.width, size.height)];
    [cell setText:value];
    [cell setTextColor:[UIColor darkGrayColor]];
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    [cell setTextAlignment:alignment];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = [self.transactionView contentOffset];
    [self.dateView setContentOffset:CGPointMake(offset.x, 0) animated:NO];
    [self.summaryContentView setContentOffset:CGPointMake(offset.x, 0) animated:NO];
    [self.categoryView setContentOffset:CGPointMake(0, offset.y) animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
