//
//  LedgerMainViewController.h
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/27/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LedgerPageViewController.h"
#import "LedgerGraphViewController.h"
#import "LedgerAboutViewController.h"
#import "LedgerOptionView.h"

@interface LedgerMainViewController : UIViewController {
    LedgerDB *ledgerDB;
    BOOL menuDisplayed;
}

@property (nonatomic) UIButton *menuButton;
@property (nonatomic) BOOL menuDisplayed;
@property (nonatomic, strong, retain) UIViewController *currentViewController;
@property (nonatomic, strong, retain) LedgerAboutViewController *ledgerAboutViewController;
@property (nonatomic, strong, retain) LedgerPageViewController *ledgerPageViewController;
@property (nonatomic, strong, retain) LedgerGraphViewController *ledgerGraphViewController;
@property (nonatomic, strong, retain) LedgerOptionView *ledgerOptionView;

-(void) changeViewController: (NSString *) viewControllerName;
@end
