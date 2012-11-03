//
//  MainViewController.m
//  LedgerView
//
//  Created by Lam Lu on 11/2/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize menuViewController;
@synthesize navViewController;
@synthesize ledgerContentViewController;
@synthesize menuButton;
@synthesize mainView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        menuViewController = [[MenuViewController alloc] initWithNibName:nil bundle: nil];
        navViewController = [[NavigationViewController alloc] initWithNibName:nil bundle:nil];
        ledgerContentViewController = [[LedgerContentViewController alloc] initWithNibName:nil bundle:nil];
        
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;
        
        mainView = [[UIView alloc] initWithFrame:screenBound];
        menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        menuButton.frame = CGRectMake(screenWidth - 36, screenHeight/300, 35,25);
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Do any additional setup after loading the view from its nib.

    
    [self.view addSubview:menuViewController.view];
    
    [self.mainView addSubview:ledgerContentViewController.view];
    [self.mainView addSubview:navViewController.view];
    
    [menuButton setTitle:@"m" forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    [self.mainView addSubview:menuButton];
    [self.view addSubview:mainView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) menuButtonPressed
{
    if(!menuViewController.isMenuViewPresent)
    {
        [UIView animateWithDuration:0.5 animations:^
         {
             NSLog(@"BUTTON PRESSED");
             mainView.frame = CGRectOffset(mainView.frame, 0, 0);
             mainView.frame = CGRectOffset(mainView.frame, -50, 0);
             
             menuViewController.isMenuViewPresent = YES;
         }completion: ^(BOOL finished)
        {
        }];
        
        [UIView commitAnimations];
    }
    
    else
    {
        [UIView animateWithDuration:0.5 animations:^
         {
             mainView.frame = CGRectOffset(mainView.frame, 0, 0);
             mainView.frame = CGRectOffset(mainView.frame, 50, 0);
             
             menuViewController.isMenuViewPresent = NO;
         }completion: ^(BOOL finished)
         {
         }];
        
        [UIView commitAnimations];
        
    }
}

@end
