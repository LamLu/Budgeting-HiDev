//
//  DatePickerViewController.h
//  LedgerView
//
//  Created by Lam Lu on 11/6/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController
{
    UIBarButtonItem * doneButton;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem * doneButton;

- (IBAction) doneButtonPressed;

@end
