//
//  PieView.m
//  Pie
//
//  Created by test on 11/19/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import "PieView.h"
static inline double radians(double degrees) {return degrees * M_PI / 180;}
@implementation PieView
@synthesize dataSource = _dataSource;

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
}
- (void)awakeFromNib
{
    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    NSLog(@"x = %f, y= %f", self.frame.size.width, self.frame.size.height);
    //NSLog(@"%f",rect.size.height);
    NSArray *transactions = [self.dataSource transactionForPieView:self];
    NSArray *amountOfTransactions = [self.dataSource amountOfTransactionForPieView:self];
    NSMutableArray *colorArray = [self.dataSource colorOfPieForPieView:self];
    NSNumber *total = [self.dataSource totalAmount:self];
    //NSArray *transactions = [NSArray arrayWithObjects:@"Breakfast",@"Lunch",@"Dinner",@"Transporation",@"Coffee", nil];
    //NSArray *rawDataArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithFloat:90.0],[NSNumber numberWithFloat:80.0],[NSNumber numberWithFloat:100.0],[NSNumber numberWithFloat:60.0],[NSNumber numberWithFloat:30.0], nil];
    //NSNumber *total = [NSNumber numberWithFloat:360];
    NSMutableArray *pieArray = [[NSMutableArray alloc]initWithCapacity:[amountOfTransactions count]];
    for (int i =0;  i < [amountOfTransactions count]; i++) {
        [pieArray addObject:[self findPercentWithAmount:[amountOfTransactions objectAtIndex:i] withTotalAmount:total]];
    }
    //NSLog(@"%@",amountOfTransactions);
    // Drawing code
    //CGRect parentViewBounds = self.bounds;
    CGRect parentViewBounds = self.bounds;
    //self.frame = CGRectMake(0, 0, 320, 188 + 88);
    //NSLog(@"x = %f, y= %f", parentViewBounds.size.width, parentViewBounds.size.height);
    CGFloat x = CGRectGetWidth(parentViewBounds)/2;
    CGFloat y = CGRectGetHeight(parentViewBounds)/2;
    
    //Get the graphic contect and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    //Define stroke color
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
    CGContextSetLineWidth(ctx, 10.0);
    
    //Create a array of color
    /*
    NSMutableArray *colorArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [transactions count]; i++)
    {
        UIColor *color = [self GetRandomColor];
        [colorArray addObject:color];
    }
    //need some values to draw pie charts
    */
    
    CGFloat radius = 100;
    //CGFloat rectOffset = 10;
    CGFloat StartRad = 0;
    CGFloat EndRad = 0;
    //CGFloat maxFont = 9.0;
    //CGFloat sizeOfRect = 9.0;
    //UIFont *myFont = [UIFont fontWithName:@"Helvetica" size:maxFont];
    
    
    for (int i = 0; i < transactions.count; i++)
    {

        const CGFloat* RGBComponets = CGColorGetComponents([[colorArray objectAtIndex:i] CGColor]);
        CGContextSetRGBFillColor(ctx, RGBComponets[0], RGBComponets[1], RGBComponets[2], 1.0);
        float percent = [[pieArray objectAtIndex:i]floatValue];
        EndRad = StartRad + percent;
        CGContextMoveToPoint(ctx, x, y);
        //CGContextAddArc(ctx, x, y, 120, radians(StartRad), radians(EndRad), 0);
        CGContextAddArc(ctx, x, y, radius, radians(StartRad), radians(EndRad), 0);
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
        StartRad = EndRad;
        
    }
    /*
    for (int i = 0; i < transactions.count; i++)
    {
        CGRect rect = CGRectMake(44, y + radius + rectOffset, sizeOfRect, sizeOfRect);
        CGPoint transactionPointInPie = CGPointMake(92, y + radius + rectOffset);
        NSString *transactionString = [NSString stringWithFormat:@"%@",transactions[i]];
        [transactionString drawAtPoint:transactionPointInPie forWidth:100 withFont:myFont fontSize:maxFont lineBreakMode:NSLineBreakByTruncatingMiddle baselineAdjustment:NSTextAlignmentLeft];
        rectOffset =rectOffset + sizeOfRect;
        const CGFloat* RGBComponets = CGColorGetComponents([[colorArray objectAtIndex:i] CGColor]);
        CGContextSetRGBFillColor(ctx, RGBComponets[0], RGBComponets[1], RGBComponets[2], 1.0);
        CGContextFillRect(ctx, rect);
        
    }
     */

}
- (UIColor*) GetRandomColor
{
	CGFloat red   = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat blue  = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
	return [UIColor colorWithRed: red green: green blue: blue alpha: 1.0];
}
- (NSNumber*) findPercentWithAmount:(NSNumber*) amount withTotalAmount:(NSNumber*)totalAmount
{
    NSNumber *percent =[NSNumber numberWithFloat: [amount floatValue] / [totalAmount floatValue] * 360];
    return percent;
}


@end
