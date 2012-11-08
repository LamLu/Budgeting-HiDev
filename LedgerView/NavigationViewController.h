//
//  NavigationViewController.h
//  LedgerView
//
//  Created by Lam Lu on 11/2/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationViewController : UIViewController
{
    UIButton * datepicker;
}

@property (nonatomic, retain) IBOutlet UIButton * datepicker;

- (IBAction)datePickerPressed;


@end
