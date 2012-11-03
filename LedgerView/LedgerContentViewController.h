//
//  LedgerContentViewController.h
//  LedgerView
//
//  Created by YenHsiang Wang on 10/27/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LedgerCell.h"
#import "LedgerDB.h"


@interface LedgerContentViewController : UIViewController <UIScrollViewDelegate> {
    LedgerDB *ledgerDB;

}

@property (weak, nonatomic) IBOutlet UIScrollView *transactionView;
@property (weak, nonatomic) IBOutlet UIScrollView *dateView;
@property (weak, nonatomic) IBOutlet UIScrollView *categoryView;
@property (weak, nonatomic) IBOutlet UIScrollView *summaryTitleView;
@property (weak, nonatomic) IBOutlet UIScrollView *summaryContentView;




@end
