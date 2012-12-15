//
//  LedgerOptionView.m
//  Ledgerdary
//
//  Created by YenHsiang Wang on 11/27/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerOptionView.h"
#import "LedgerMainViewController.h"

@implementation LedgerOptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame andLedgerDB: (LedgerDB *) aLedgerDB {
    
    self = [super initWithFrame:frame];
    if (self) {
        ledgerDB = aLedgerDB;
        [self setBackgroundColor: [UIColor whiteColor]];
        CGPoint pos = CGPointMake((self.frame.size.width - ButtonWith)  / 2,
                                  InitialGap + (self.frame.size.width - ButtonWith) / 2);
        [self addSubview:[self addButton:LedgerPageButton andPos:pos]];
        pos = CGPointMake(pos.x, pos.y + ButtonHeight + ButtonGap);
        [self addSubview:[self addButton:PieChartButton andPos:pos]];
        pos = CGPointMake(pos.x, pos.y + ButtonHeight + ButtonGap);
        [self addSubview:[self addButton:BarGraphButton andPos:pos]];
        pos = CGPointMake(pos.x, pos.y + ButtonHeight + ButtonGap);
        
        //[self addSubview:[self addButton:SettingButton andPos:pos]];
        //pos = CGPointMake(pos.x, pos.y + ButtonHeight + ButtonGap);
        [self addSubview:[self addButton:AboutButton andPos:pos]];
    }
    return self;
}

-(UIButton *) addButton: (int) option andPos: (CGPoint) pos
{
    UIButton *aButton = [[UIButton alloc] initWithFrame:CGRectMake(pos.x, pos.y, 30, 30)];
    UIColor *c = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:.25];

    [aButton setBackgroundColor: c];
    ///[aButton setTitle:[NSString stringWithFormat:@"%c", [option characterAtIndex:0]] forState: UIControlStateNormal];
    
    switch (option) {
        case LedgerPageButton:
            [aButton addTarget:self action:@selector(showLedgerPage) forControlEvents:UIControlEventTouchUpInside];
            break;
        case PieChartButton:
            [aButton addTarget:self action:@selector(showPieChart) forControlEvents:UIControlEventTouchUpInside];
            break;
        case BarGraphButton:
            [aButton addTarget:self action:@selector(showBarGraph) forControlEvents:UIControlEventTouchUpInside];
            break;
        case SettingButton:
            [aButton addTarget:self action:@selector(showSetting) forControlEvents:UIControlEventTouchUpInside];
            break;
        case AboutButton:
            [aButton addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];
            break;
        default :
            break;
    }
    return aButton;
}

-(void) showLedgerPage {
    LedgerMainViewController *ledgerMainView = (LedgerMainViewController *)[[self superview] nextResponder];
    [ledgerMainView changeViewController: @"LedgerPage"];
}

-(void) showPieChart {
    LedgerMainViewController *ledgerMainView = (LedgerMainViewController *)[[self superview] nextResponder];
    [ledgerMainView changeViewController: @"PieChart"];
}
-(void) showBarGraph {
    LedgerMainViewController *ledgerMainView = (LedgerMainViewController *)[[self superview] nextResponder];
    [ledgerMainView changeViewController: @"BarGraph"];
}
-(void) showSetting {
    LedgerMainViewController *ledgerMainView = (LedgerMainViewController *)[[self superview] nextResponder];
    [ledgerMainView changeViewController: @"Setting"];
}
-(void) showAbout {
    LedgerMainViewController *ledgerMainView = (LedgerMainViewController *)[[self superview] nextResponder];
    [ledgerMainView changeViewController: @"About"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
