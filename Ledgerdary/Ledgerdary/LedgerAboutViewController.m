//
//  LedgerAboutViewController.m
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/27/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerAboutViewController.h"

@interface LedgerAboutViewController ()

@end

@implementation LedgerAboutViewController
@synthesize hiDevWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor grayColor]];
    self.hiDevWebView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.hiDevWebView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:@"http://www.hidevmobile.com"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.hiDevWebView.delegate = self;
    [self.hiDevWebView loadRequest:requestObj];
    [self.hiDevWebView sizeToFit];
    [self.view addSubview:self.hiDevWebView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
