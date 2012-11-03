//
//  NavigationViewController.m
//  LedgerView
//
//  Created by Lam Lu on 11/2/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;
        [self.view setFrame: CGRectMake (0,0, screenWidth /3.15, screenHeight /7.05 )];
        /*
        NSLog (@"%f", screenBound.origin.x);
         NSLog (@"%f", screenBound.origin.y);
         NSLog (@"%f", screenWidth);
       NSLog (@"%f", screenHeight);
         */
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     NSLog(@"NAVIGATION");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
