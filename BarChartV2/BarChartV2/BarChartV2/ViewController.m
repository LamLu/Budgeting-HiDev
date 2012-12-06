//
//  ViewController.m
//  BarChartV2
//
//  Created by test on 11/13/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import "ViewController.h"
#import "BarChart.h"
#import "TransactionTextView.h"

@interface ViewController () <BarChartDataSource,TransactionTextView>
@property (nonatomic, weak) IBOutlet BarChart * barChart;
@property (nonatomic, weak) IBOutlet TransactionTextView * transactionTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController
@synthesize transaction = _transaction;
@synthesize amountOfTransaction = _amountOfTransaction;
@synthesize barChart = _barChart;
@synthesize colorArray = _colorArray;
/*
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
*/
-(NSMutableArray*)colorOfBarChart:(BarChart *)sender
{
    return self.colorArray;
}

-(NSMutableArray*)colorForTransactionTextView:(TransactionTextView *)sender
{
    return self.colorArray;
}
-(NSArray*)transactionNameForTransactionTextView:(TransactionTextView *)sender
{
    return self.transaction;
}
-(NSArray*)dataForBarChart:(BarChart *)sender
{
    return self.transaction;
}
-(NSArray*)amountOfTransactionForTransactionTextView:(TransactionTextView *)sender
{
    return self.amountOfTransaction;
}
-(NSArray*)amountOfTransactionForBarChar:(BarChart *)sender
{
    return self.amountOfTransaction;
}
- (void)setBarChart:(BarChart *)barChart
{
    _barChart = barChart;
    self.barChart.dataSource = self;
}
-(void) setTransactionTextView:(TransactionTextView *)transactionTextView
{
    _transactionTextView = transactionTextView;
    self.transactionTextView.dataSource =self;
}
- (void)setTransactions:(NSArray *)transaction {
    
    _transaction = [NSArray arrayWithArray:transaction];
    
    [self.barChart setNeedsDisplay];
    [self.transactionTextView setNeedsDisplay];
}
- (void)setAmountOfTransaction:(NSArray *)amountOfTransaction{
    _amountOfTransaction = [NSArray arrayWithArray:amountOfTransaction];
    [self.barChart setNeedsDisplay];
    [self.transactionTextView setNeedsDisplay];
}
- (UIColor*) GetRandomColor
{
	CGFloat red   = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat blue  = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
	return [UIColor colorWithRed: red green: green blue: blue alpha: 1.0];
}
- (void)viewDidLoad
{
    NSLog(@"height of text = %f and width of text = %f",self.transactionTextView.frame.size.height,self.transactionTextView.frame.size.height);
    //NSLog(@"height bound of text = %f and width bound of text = %f",self.transactionTextView.bounds.size.height,self.transactionTextView.bounds.size.height);
    CGRect rect = CGRectMake(320, 0, self.transactionTextView.frame.size.width + 50, self.transactionTextView.frame.size.height + 50);
    //self.barChart.bounds = self.barChart.frame;
    self.scrollView.contentSize = rect.size;
    //self.scrollView.frame = self.transactionTextView.frame;
    self.barChart.frame = CGRectMake(0, 0, 416, 300);
    ledgerDB = [[LedgerDB alloc]initDB];
    self.transaction = [ledgerDB getCategories];
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
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
