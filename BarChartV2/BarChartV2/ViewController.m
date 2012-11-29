//
//  ViewController.m
//  BarChartV2
//
//  Created by test on 11/13/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import "ViewController.h"
#import "BarChart.h"

@interface ViewController () <BarChartDataSource>
@property (nonatomic, weak) IBOutlet BarChart * barChart;
@end

@implementation ViewController
@synthesize transaction = _transaction;
@synthesize amountOfTransaction = _amountOfTransaction;
@synthesize barChart = _barChart;
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(NSArray*)dataForBarChart:(BarChart *)sender
{
    return self.transaction;
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
- (void)setTransactions:(NSArray *)transaction {
    
    _transaction = [NSArray arrayWithArray:transaction];
    
    [self.barChart setNeedsDisplay];
}
- (void)setAmountOfTransaction:(NSArray *)amountOfTransaction{
    _amountOfTransaction = [NSArray arrayWithArray:amountOfTransaction];
    [self.barChart setNeedsDisplay];
}

- (void)viewDidLoad
{
    ledgerDB = [[LedgerDB alloc]initDB];
    self.transaction = [ledgerDB getCategories];
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:[self.transaction count]];
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
