//
//  MainViewController.h
//  LedgerView
//
//  Created by Lam Lu on 11/2/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "NavigationViewController.h"
#import "LedgerContentViewController.h"
#import "ViewController.h"

@interface MainViewController : UIViewController
{
    MenuViewController * menuViewController;
    NavigationViewController * navViewController;
    LedgerContentViewController * ledgerContentViewController;
    BOOL isShowingLandscapeView;
    UIButton * menuButton;
    UIView *mainView;
}

@property (nonatomic, retain) MenuViewController* menuViewController;
@property (nonatomic, retain) NavigationViewController* navViewController;
@property (nonatomic, retain) LedgerContentViewController* ledgerContentViewController;
@property (nonatomic, retain) ViewController* barViewControler;
@property (nonatomic, retain) UIButton* menuButton;
@property (nonatomic, retain) UIView * mainView;

- (void) menuButtonPressed;

@end

