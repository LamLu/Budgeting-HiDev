//
//  LedgerPageViewController.h
//  LedgerView
//
//  Created by YenHsiang Wang on 10/27/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LedgerContentViewController.h"
#import "LedgerDB.h"

@interface LedgerPageViewController : UIViewController <UIPageViewControllerDataSource> {
    LedgerDB *ledgerDB;
}

@property (nonatomic, strong) UIPageViewController *pageViewController;


@end
