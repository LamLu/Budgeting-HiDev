//
//  PieViewViewController.h
//  Pie
//
//  Created by test on 11/19/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LedgerDB.h"
#import "PieView.h"
#import "TransactionTextView.h"
@interface PieViewViewController : UIViewController {
    LedgerDB *ledgerDB;
    //PieView *pieChartView;
    //TransactionTextView *transactionTextView;
}
@property (nonatomic) NSArray *transaction;
@property (nonatomic) NSArray *amountOfTransaction;
@property (nonatomic) NSNumber *totalAmount;
//@property (weak, nonatomic) TransactionTextView *transactionTextView;
//@property (weak, nonatomic) PieView *pieChartView;
@property (nonatomic) NSMutableArray *colorArray;
@end
