//
//  LedgerDateRowView.h
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/22/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerScrollView.h"

@interface LedgerDateRowView : LedgerScrollView <UIActionSheetDelegate>{
    NSArray *dateRange;
    CGPoint todayPos;
}
@property (nonatomic) NSArray *dateRange;
@property (nonatomic) NSArray *dateLabelArray;
@property (nonatomic) CGPoint todayPos;

- (id) initWithFrame:(CGRect)frame andDatabase: (LedgerDB *) aLedgerDB andArray:(NSMutableArray *) aDateRange;
- (void) reloadView;
@end
