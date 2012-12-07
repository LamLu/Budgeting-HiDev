//
//  PieView.h
//  Pie
//
//  Created by test on 11/19/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class PieView;
@protocol PieViewDataSource
-(NSArray*)transactionForPieView:(PieView *)sender;
-(NSArray*)amountOfTransactionForPieView:(PieView*)sender;
-(NSMutableArray*)colorOfPieForPieView:(PieView*)sender;
-(NSNumber*)totalAmount:(PieView*)sender;



@end
@interface PieView : UIView
@property (nonatomic,weak) IBOutlet id <PieViewDataSource>dataSource;
@end
