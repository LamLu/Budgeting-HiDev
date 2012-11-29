//
//  NavigationViewController.m
//  LedgerView
//
//  Created by Lam Lu on 11/2/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "NavigationViewController.h"
#import "DatePickerViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController
@synthesize datepicker;

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


- (IBAction)datePickerPressed
{
    NSLog(@"Date Picker Pressed");
    DatePickerViewController * datePickerVC = [[DatePickerViewController alloc] init];
    float width = datePickerVC.view.frame.size.width;
    float height = datePickerVC.view.frame.size.height;
    [self.view.superview addSubview: datePickerVC.view];
    [UIView animateWithDuration:0.6 animations:^
     {
         datePickerVC.view.frame = CGRectMake(0, 0 - height, width, height);
         datePickerVC.view.frame = CGRectMake(0, 0, width, height);
     }completion: ^(BOOL finished)
     {
       
     }];
    
    [UIView commitAnimations];
}
@end
