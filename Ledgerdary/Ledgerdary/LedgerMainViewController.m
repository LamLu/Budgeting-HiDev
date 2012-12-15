//
//  LedgerMainViewController.m
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/27/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerMainViewController.h"

@interface LedgerMainViewController ()

@end

@implementation LedgerMainViewController
@synthesize menuDisplayed;

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
    self.ledgerPageViewController = [[LedgerPageViewController alloc] initWithLedgerDB:ledgerDB];
    [self.ledgerPageViewController.view setFrame: self.view.bounds];
    
    self.ledgerGraphViewController = [[LedgerGraphViewController alloc] init];
    [self.ledgerGraphViewController.view setFrame: self.view.bounds];

    self.ledgerAboutViewController = [[LedgerAboutViewController alloc] init];
    [self.ledgerAboutViewController.view setFrame: self.view.bounds];
    
    self.ledgerOptionView = [[LedgerOptionView alloc] initWithFrame:CGRectMake(0, 0, 50, self.view.frame.size.height) andLedgerDB:ledgerDB];
    
    [self addChildViewController:self.ledgerPageViewController];
    [self.ledgerPageViewController didMoveToParentViewController:self];
    [self addChildViewController:self.ledgerGraphViewController];
    [self.ledgerGraphViewController didMoveToParentViewController:self];
    [self addChildViewController:self.ledgerAboutViewController];
    [self.ledgerAboutViewController didMoveToParentViewController:self];
    [self setup];
    // Do any additional setup after loading the view.
}
- (void) setup {
    self.currentViewController = self.ledgerPageViewController;
    [self.view addSubview: self.ledgerOptionView];
    [self.view addSubview: self.currentViewController.view];
    [self.view sendSubviewToBack:self.ledgerOptionView];
    
    UIColor *c = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:.25];
    [self.view setBackgroundColor:c];
    [self addButton: @"Menu" andPos: CGPointMake(0, 0)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addButton: (NSString *) text andPos: (CGPoint) pos{
    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(pos.x, pos.y, cellWidth / 3, cellHeight * 2)];
    
    UIColor *c = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:.25];
    [[self.menuButton layer] setBorderWidth:1];
    [[self.menuButton layer] setBorderColor:c.CGColor];
    
    [self.menuButton setBackgroundColor: c];
    [self.menuButton setTitle:@"M" forState: UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.menuButton];
}

-(void) showMenu {
    if (![self menuDisplayed]) {
        
        [self setMenuDisplayed: true];
        [UIView animateWithDuration:0.5 animations:^
         {
             self.currentViewController.view.frame = CGRectOffset(self.currentViewController.view.frame, 50, 0);
             self.menuButton.frame = CGRectOffset(self.menuButton.frame, 50, 0);
         }completion: ^(BOOL finished)
         {
             
         }];
        [UIView commitAnimations];
    }
    else {
        [self closeMenu];
    }
}

-(void) closeMenu{
<<<<<<< HEAD
    
    if ([self menuDisplayed])
    {
        [self setMenuDisplayed: false];
        [UIView animateWithDuration:.5 animations:^
        {
            self.currentViewController.view.frame = CGRectOffset(self.currentViewController.view.frame, -50, 0);
            self.menuButton.frame = CGRectOffset(self.menuButton.frame, -50, 0);
        }completion: ^(BOOL finished)
        {
        }];
=======
    if ([self menuDisplayed]) {
        [self setMenuDisplayed: false];
        [UIView animateWithDuration:.5 animations:^
         {
             self.currentViewController.view.frame = CGRectOffset(self.currentViewController.view.frame, -50, 0);
             self.menuButton.frame = CGRectOffset(self.menuButton.frame, -50, 0);
         }completion: ^(BOOL finished)
         {
         }];
>>>>>>> Delete unuse functions and classes
        [UIView commitAnimations];
    }
}

-(void) changeViewController: (NSString *) viewControllerName {
    if ([viewControllerName isEqual:@"LedgerPage"]){
        if (![self.currentViewController isEqual:self.ledgerPageViewController]) {
            [self transitionFromViewController:self.currentViewController toViewController:self.ledgerPageViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                self.ledgerPageViewController.view.frame = CGRectOffset(self.currentViewController.view.frame, 0, 0);
            }completion:^(BOOL finished){}];
            self.currentViewController = self.ledgerPageViewController;
            [self.view bringSubviewToFront:self.menuButton];
        }
    }
    else if ([viewControllerName isEqual:@"PieChart"]) {
        [self.ledgerGraphViewController.view setBackgroundColor:[UIColor redColor]];
        if (![self.currentViewController isEqual:self.ledgerGraphViewController]) {
            [self transitionFromViewController:self.currentViewController toViewController:self.ledgerGraphViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                self.ledgerGraphViewController.view.frame = CGRectOffset(self.currentViewController.view.frame, 0, 0);
            }  completion:^(BOOL finished){}];
            self.currentViewController = self.ledgerGraphViewController;
            [self.view bringSubviewToFront:self.menuButton];
        }
    }
    else if ([viewControllerName isEqual:@"BarGraph"]) {
        [self.ledgerGraphViewController.view setBackgroundColor:[UIColor orangeColor]];
        if (![self.currentViewController isEqual:self.ledgerGraphViewController]) {
            [self transitionFromViewController:self.currentViewController toViewController:self.ledgerGraphViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                self.ledgerGraphViewController.view.frame = CGRectOffset(self.currentViewController.view.frame, 0, 0);
            }  completion:^(BOOL finished){}];
            self.currentViewController = self.ledgerGraphViewController;
            [self.view bringSubviewToFront:self.menuButton];
        }
    }
    else if ([viewControllerName isEqual:@"Setting"]) {
        
    }
    else if ([viewControllerName isEqual:@"About"]) {
        if (![self.currentViewController isEqual:self.ledgerAboutViewController]) {
            [self transitionFromViewController:self.currentViewController toViewController:self.ledgerAboutViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                self.ledgerAboutViewController.view.frame = CGRectOffset(self.currentViewController.view.frame, 0, 0);
            } completion:^(BOOL finished){}];
            self.currentViewController = self.ledgerAboutViewController;
            [self.view bringSubviewToFront:self.menuButton];
        }
    }
    else {
        
    }
    
    [self closeMenu];
}

@end
