//
//  LedgerPageViewController.m
//  LedgerView
//
//  Created by YenHsiang Wang on 10/27/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerPageViewController.h"

@implementation LedgerPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(id) initWithLedgerDB: (LedgerDB *) aLedgerDB {
    self = [self init];
    if (self) {
        ledgerDB = aLedgerDB;
        [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"LedgerPageBackground.jpg"]]];
        [self goToDate:[NSDate date]];
        /*
        NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
        [self.pageViewController setDataSource:self];
        
        LedgerContentViewController *initialLedgerSheet = [self viewControllerAtDate:[NSDate date]];
        NSArray *viewControllers = [NSArray arrayWithObject:initialLedgerSheet];
        
        [[self pageViewController] setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [self.pageViewController.view setFrame: self.view.bounds];
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
         */
    }
    return self;    
}

- (void) goToDate:(NSDate *) date {
    [self.pageViewController removeFromParentViewController];
    [self.pageViewController.view removeFromSuperview];
    
    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
    [self.pageViewController setDataSource:self];
    
    LedgerContentViewController *initialLedgerSheet = [self viewControllerAtDate:date];
    [initialLedgerSheet setOffsetAtDate:date];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialLedgerSheet];
    [[self pageViewController] setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self.pageViewController.view setFrame: self.view.bounds];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSMutableArray *) getMonthArray: (NSDate *) aDay{
    NSMutableArray *monthArray = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:aDay];
    [comp setDay:1];
    
    [dateFormat setDateFormat:@"MM"];
    while ([[dateFormat stringFromDate: aDay] isEqual: [dateFormat stringFromDate:[gregorian dateFromComponents:comp]]]) {
        [monthArray addObject: [gregorian dateFromComponents:comp]];
        [comp setDay:comp.day+1];
    }
    
    return monthArray;
}

- (LedgerContentViewController *)viewControllerAtDate: (NSDate *) aDay{
    LedgerContentViewController *ledgerSheet;// = [[LedgerContentViewController alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:aDay];
    [comp setDay:1];
    ledgerSheet = [[LedgerContentViewController alloc] initWithDB:ledgerDB
                                                     andDateArray:[self getMonthArray: [gregorian dateFromComponents:comp]]];

    return ledgerSheet;
}

- (NSDate *) dateOfViewController: (LedgerContentViewController *) ledgerSheet {
    return [ledgerSheet.dateArray objectAtIndex:0];
}

// flip the page to the previous page
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSDate *currentDate = [self dateOfViewController:(LedgerContentViewController *)viewController];
    LedgerContentViewController *prevLedgerContentViewController =
    [self viewControllerAtDate: [self getPageAtMonth:currentDate andMonthInterval:-1]];
    [[prevLedgerContentViewController categoryView] setContentOffset: [[(LedgerContentViewController *)viewController categoryView] contentOffset]];
    [[prevLedgerContentViewController transactionView] setContentOffset: CGPointMake([[prevLedgerContentViewController transactionView] contentSize].width - [[prevLedgerContentViewController transactionView] frame].size.width , [[(LedgerContentViewController *)viewController categoryView] contentOffset].y)];
    
    return prevLedgerContentViewController;
}

// flip the page to the next page
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSDate *currentDate = [self dateOfViewController:(LedgerContentViewController *)viewController];
    LedgerContentViewController *nextLedgerContentViewController =
        [self viewControllerAtDate: [self getPageAtMonth:currentDate andMonthInterval:1]];
    [[nextLedgerContentViewController categoryView] setContentOffset: [[(LedgerContentViewController *)viewController categoryView] contentOffset]];
    [[nextLedgerContentViewController transactionView] setContentOffset: CGPointMake([[nextLedgerContentViewController transactionView] contentOffset].x, [[(LedgerContentViewController *)viewController categoryView] contentOffset].y)];
    
    return nextLedgerContentViewController;
}

- (NSDate *) getPageAtMonth: (NSDate *) currentDate andMonthInterval: (int) interval{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currentDate];
    [comp setDay:1];
    [comp setMonth:comp.month + interval];
    return [gregorian dateFromComponents:comp];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) test {
    NSLog(@"Called from subview");
}
@end
