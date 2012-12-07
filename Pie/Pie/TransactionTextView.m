//
//  TransactionTextView.m
//  Pie
//
//  Created by test on 11/29/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import "TransactionTextView.h"

@implementation TransactionTextView
@synthesize dataSource = _dataSource;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIColor*) GetRandomColor
{
	CGFloat red   = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat blue  = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
	return [UIColor colorWithRed: red green: green blue: blue alpha: 1.0];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"height = %f, width = %f", rect.size.height,rect.size.width);
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    //Define stroke color
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
    CGContextSetLineWidth(ctx, 10.0);
    
    //NSString *test = @"breakfast";
    float rectOffset = 5;
    float sizeOfRect = 20;
    float maxFont = 20;
     UIFont *myFont = [UIFont fontWithName:@"Helvetica" size:maxFont];
    
    float position = self.bounds.origin.y + sizeOfRect;
    
    NSArray *transactions = [self.dataSource transactionNameForTransactionTextView:self];
    NSArray *colorArray = [self.dataSource colorForTransactionTextView:self];
    //NSLog(@"Array of transaction = %@",transactions);
    //NSArray *transactions = [NSArray arrayWithObjects:@"Breakfast",@"Lunch",@"Dinner",@"Transporation",@"Coffee",@"Candy",@"Manga",@"Tea",@"Movie",@"Juice", nil];
    /*
    NSMutableArray *colorArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [transactions count]; i++)
    {
        UIColor *color = [self GetRandomColor];
        [colorArray addObject:color];
    }
    */
    for (int i = 0; i < transactions.count; i++)
    {
        CGRect rect = CGRectMake(44, position, sizeOfRect, sizeOfRect);
        //CGPoint transactionPointInPie = CGPointMake(44 + sizeOfRect + 5, self.frame.origin.y + rectOffset);
        
        NSString *transactionString = [NSString stringWithFormat:@"%@",transactions[i]];
                
        //[transactionString drawAtPoint:transactionPointInPie forWidth:100 withFont:myFont fontSize:maxFont lineBreakMode:NSLineBreakByTruncatingMiddle baselineAdjustment:NSTextAlignmentLeft];
        rectOffset =rectOffset + sizeOfRect;
        const CGFloat* RGBComponets = CGColorGetComponents([[colorArray objectAtIndex:i] CGColor]);
        CGContextSetRGBFillColor(ctx, RGBComponets[0], RGBComponets[1], RGBComponets[2], 1.0);
        CGContextFillRect(ctx, rect);
        CGRect rects = CGRectMake(self.bounds.origin.x + 44 + sizeOfRect + 5, position , 100, sizeOfRect);
        position = position + sizeOfRect;
        
                [transactionString drawInRect:rects withFont:myFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
        //NSLog(@"%@",transactionString);

        
    }
    //CGContextSetRGBFillColor(ctx, 5, 5, 5, 1.0);
    //CGContextFillRect(ctx, rect);
}


@end
