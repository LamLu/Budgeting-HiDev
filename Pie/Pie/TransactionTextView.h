//
//  TransactionTextView.h
//  Pie
//
//  Created by test on 11/29/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TransactionTextView;
@protocol TransactionTextView
-(NSArray*)transactionNameForTransactionTextView:(TransactionTextView *)sender;
-(NSArray*)amountOfTransactionForTransactionTextView:(TransactionTextView*)sender;
-(NSArray*)colorForTransactionTextView:(TransactionTextView*)sender;


@end
@interface TransactionTextView : UIView
@property (nonatomic,weak) IBOutlet id <TransactionTextView>dataSource;
@end
