//
//  LedgerCell.m
//  LedgerView
//
//  Created by YenHsiang Wang on 10/28/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerCell.h"

@implementation LedgerCell
@synthesize longPressRecog;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)aFrame andText:(NSString *)aText
{
    self = [super init];
    [self setFrame:aFrame];
    [self setText:aText];
    [self setTextAlignment:NSTextAlignmentCenter];
    
    longPressRecog = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(display)];
    [self addGestureRecognizer:longPressRecog];
    return self;
}

- (IBAction)editing:(id)sender {
    NSLog(@"\nYOYOYOYOYO\n");
}

- (void) display
{
    NSLog(@"\nYOYOYOYOYO\n");
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
