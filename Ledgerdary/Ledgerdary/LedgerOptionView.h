//
//  LedgerOptionView.h
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/27/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LedgerDB.h"

@interface LedgerOptionView : UIView {
    LedgerDB *ledgerDB;
}
@property (nonatomic, strong) UIButton *homeViewButton;
@property (nonatomic, strong) UIButton *pieCharViewButton;
@property (nonatomic, strong) UIButton *barGraphViewButton;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIButton *aboutButton;

-(id) initWithFrame:(CGRect)frame andLedgerDB: (LedgerDB *) aLedgerDB;

typedef enum {
    InitialGap = 5,
    ButtonGap = 15,
    ButtonWith = 30,
    ButtonHeight = 30
} ButtonSize;

typedef enum {
    Cover,
    LedgerPageButton,
    BarGraphButton,
    PieChartButton,
    SettingButton,
    AboutButton
} Options;

@end
