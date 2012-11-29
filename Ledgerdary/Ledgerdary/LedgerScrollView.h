//
//  LedgerScrollView.h
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/21/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LedgerDB.h"
#import "LedgerCell.h"

@interface LedgerScrollView : UIScrollView {
    LedgerDB *ledgerDB;
}
- (id) initWithFrame:(CGRect)frame andDatabase: (LedgerDB *) aLedgerDB;

@end
