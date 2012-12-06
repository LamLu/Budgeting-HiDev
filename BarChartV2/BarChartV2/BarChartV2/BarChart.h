//
//  BarChart.h
//  BarChart
//
//  Created by test on 10/30/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BarChart;
@protocol BarChartDataSource 
-(NSArray*)dataForBarChart:(BarChart *)sender;
-(NSArray*)amountOfTransactionForBarChar:(BarChart *)sender;
-(NSMutableArray*)colorOfBarChart:(BarChart *)sender;
@end
@interface BarChart : UIView
@property (nonatomic,weak) IBOutlet id <BarChartDataSource> dataSource;
@end
