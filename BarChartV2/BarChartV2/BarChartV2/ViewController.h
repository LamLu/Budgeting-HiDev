//
//  ViewController.h
//  BarChartV2
//
//  Created by test on 11/13/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LedgerDB.h"

@interface ViewController : UIViewController {
    LedgerDB *ledgerDB;
}
@property (nonatomic) NSArray *transaction;
@property (nonatomic) NSArray *amountOfTransaction;
@property (nonatomic) NSMutableArray *colorArray;
@end
