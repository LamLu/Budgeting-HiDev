//
//  LedgerInputSheet.h
//  LedgerView
//
//  Created by YenHsiang Wang on 11/13/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LedgerInputSheet : UIActionSheet <UIActionSheetDelegate>{
    int action;
}


typedef enum {
    PICKING_DATE,
    UPDATING_CATEGORY,
    UPDATING_BUDGET,
    UPDATING_TRANSACTION,
    ADDING_CATEGORY,
    ADDING_TRANSACTION
} LedgerAction;

- (id)initWithFrame:(CGRect)aFrame andAction: (int) anAction;
@end
