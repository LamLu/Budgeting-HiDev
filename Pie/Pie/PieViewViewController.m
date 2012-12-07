//
//  PieViewViewController.m
//  Pie
//
//  Created by test on 11/19/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import "PieViewViewController.h"

@interface PieViewViewController () <PieViewDataSource,TransactionTextView>

@property (weak, nonatomic) IBOutlet TransactionTextView *transactionTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet PieView *pieView;

@end

@implementation PieViewViewController
@synthesize transaction = _transaction;
@synthesize amountOfTransaction = _amountOfTransaction;
@synthesize colorArray = _colorArray;
@synthesize pieView = _pieView;
@synthesize totalAmount = _totalAmount;
@synthesize transactionTextView = _transactionTextView;
//@synthesize pieChartView = _pieChartView;
/*
- (void) setUpSubViews
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    [self buildPieView:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, screenWidth, screenHeight/2)];
    [self buildTransactionTextView:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + screenHeight/2, screenWidth, screenHeight/2)];
    
    [self.view addSubview:self.pieChartView];
    [self.view addSubview:self.transactionTextView];
    
}
- (void) buildPieView:(CGRect) aFrame
{
    [self.pieChartView setFrame:aFrame];
    [self.pieChartView setBackgroundColor:[UIColor brownColor]];
    
}
- (void) buildTransactionTextView:(CGRect) aFrame
{
    [self.transactionTextView setFrame:aFrame];
    [self.transactionTextView setBackgroundColor:[UIColor redColor]];
}
 */
-(NSMutableArray*)colorForTransactionTextView:(TransactionTextView *)sender
{
    return self.colorArray;
}
-(NSMutableArray*)colorOfPieForPieView:(PieView *)sender
{
    return self.colorArray;
}
-(NSArray*)transactionNameForTransactionTextView:(TransactionTextView*)sender
{
    return self.transaction;
}
-(NSArray*)transactionForPieView:(PieView *) sender
{
    return self.transaction;
}
-(NSArray*)amountOfTransactionForTransactionTextView:(TransactionTextView *)sender
{
    return self.amountOfTransaction;
}
-(NSArray*)amountOfTransactionForPieView:(PieView *)sender
{
    return self.amountOfTransaction;
}
-(NSNumber*)totalAmount:(PieView *)sender
{
    return self.totalAmount;
}
-(void) setPieView:(PieView *)pieView
{
    _pieView = pieView;
    self.pieView.dataSource = self;
}
-(void) setTransactionTextView:(TransactionTextView *)transactionTextView
{
    _transactionTextView = transactionTextView;
    self.transactionTextView.dataSource =self;
}

- (void)viewDidLoad

{
    self.scrollView.contentSize = self.transactionTextView.frame.size;
    self.pieView.frame = CGRectMake(0, 0, 320, 276);
    //NSLog(@"Height of main view = %f", self.view.frame.size.height);
    //[self setUpSubViews];
    ledgerDB = [[LedgerDB alloc]initDB];
    
    self.transaction = [ledgerDB getCategories];
    //NSLog(@"%@",self.transaction);
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:[self.transaction count]];
    
    self.colorArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [self.transaction count]; i++)
    {
        UIColor *color = [self GetRandomColor];
        [self.colorArray addObject:color];
    }
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: today];
    // this will set the date to 2012 - 11 - 10
    /*
    NSInteger day = [comp day];
    NSInteger month = [comp month];
    NSInteger year = [comp year];
    NSLog(@"%d",day);
    NSLog(@"%d",month);
    NSLog(@"%d",year);
     */
    
    [comp setDay:10];
    [comp setMonth:11];
    [comp setYear:2012];
    
    //use this line to retrieve the date
    [gregorian dateFromComponents:comp];
    //NSLog(@"%@",[gregorian dateFromComponents:comp] );
    for (int i = 0; i < [self.transaction count]; i++) {
        NSNumber *amount = [ledgerDB getAmount:[gregorian dateFromComponents:comp] andCategoryName:[self.transaction objectAtIndex:i]];
        if (amount != nil)
        {
            //NSLog(@"amount : %@",amount);
            [tempArray addObject:amount];
        }
        else
        {
            amount = [NSNumber numberWithDouble:0.00];
            [tempArray addObject:amount];
        }
        
    }
    
    self.amountOfTransaction = [NSArray arrayWithArray:tempArray];
    self.totalAmount = [ledgerDB getTotal:[gregorian dateFromComponents:comp]];
    //NSLog(@"%@",self.totalAmount);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (UIColor*) GetRandomColor
{
	CGFloat red   = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat blue  = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
	return [UIColor colorWithRed: red green: green blue: blue alpha: 1.0];
}
- (void)setTransaction:(NSArray *)transaction {
    _transaction = [NSArray arrayWithArray:transaction];
    [self.pieView setNeedsDisplay];
}
- (void)setAmountOfTransaction:(NSArray *)amountOfTransaction
{
    _amountOfTransaction = [NSArray arrayWithArray:amountOfTransaction];
    [self.pieView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
