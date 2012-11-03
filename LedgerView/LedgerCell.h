//
//  LedgerCell.h
//  LedgerView
//
//  Created by YenHsiang Wang on 10/28/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LedgerCell : UILabel {
    bool editable;
    NSString *text;
    UILongPressGestureRecognizer *longPressRecog;
}

@property (nonatomic, retain) IBOutlet UILongPressGestureRecognizer *longPressRecog;

- (id) initWithFrame:(CGRect)aFrame andText:(NSString *)aText;
- (IBAction) editing:(id)sender;

@end
