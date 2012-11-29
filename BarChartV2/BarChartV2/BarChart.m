//
//  BarChart.m
//  BarChart
//
//  Created by test on 10/30/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import "BarChart.h"

@implementation BarChart
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


- (void)drawyYAxis:(CGPoint)yAxis withOrigin:(CGPoint)pOrigin withXAxis:(CGPoint)xAxis inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGPoint point[4] = {yAxis,pOrigin,pOrigin,xAxis};
    CGContextStrokeLineSegments(context, point, 4);
    UIGraphicsPopContext();
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSArray *transactions = [self.dataSource dataForBarChart:self]; //delegate from view controller
    //NSArray *transactions = [NSArray arrayWithObjects:@"Breakfast",@"Lunch",@"Dinner",@"Transporation", nil];
    NSArray *amountOfTransaction = [self.dataSource amountOfTransactionForBarChar:self];
    NSLog(@"%@",amountOfTransaction);
    /*
    NSArray *amountOfTransaction = [[NSArray alloc] initWithObjects:
                                  [NSNumber numberWithFloat: 30],
                                  [NSNumber numberWithFloat: 20],
                                  [NSNumber numberWithFloat: 40],
                                  [NSNumber numberWithFloat: 10.23],
                                  nil];
     
    */
    int offset = 44;
    //CGFloat minFont = 5.0;
    CGFloat maxFont = 9.0;
    CGFloat distanceFromY = 20.0;
    int offsetFromLine = 4;
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //CGContextClearRect(ctx, rect);
    //CGContextSetRGBFillColor(ctx, 255, 0, 0, 1);
    //CGContextFillRect(ctx, CGRectMake(0, 0,320, 460));
    //CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
    UIFont *myFont = [UIFont fontWithName:@"Helvetica" size:maxFont];
    CGPoint yAxis = CGPointMake(self.bounds.origin.x + offset, self.bounds.origin.y + offset);
    CGPoint pOrigin = CGPointMake(self.bounds.origin.x + offset, self.bounds.size.height - offset);
    CGPoint xAxis = CGPointMake(self.bounds.size.width - offset, self.bounds.size.height - offset);
    CGFloat widthOfXAxis = xAxis.x - pOrigin.x;
    //NSLog(@"%f",widthOfXAxis);
    CGFloat heighOfYAxis = pOrigin.y - yAxis.y - distanceFromY;
    
    
    
    [self drawyYAxis:yAxis withOrigin:pOrigin withXAxis:xAxis inContext:ctx ];
    //CGPoint point[4] = {CGPointMake(44, 44),CGPointMake(44, 416),CGPointMake(44, 416), CGPointMake(276, 416)};
    int count = [transactions count];
    
    float newpoint = (widthOfXAxis/ (count + 1));
    float startpoint = pOrigin.x + newpoint;
    float widthOfBar = newpoint / 2;
    NSArray *sortedArray = [amountOfTransaction sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 floatValue] > [obj2 floatValue])
            return NSOrderedAscending;
        else if ([obj1 floatValue] < [obj2 floatValue])
            return NSOrderedDescending;
        return NSOrderedSame;
    }];
    
    
    //NSLog(@"%@",sortedArray);
    float largestNumberInArray = [sortedArray[0] floatValue];
    //float percent = heighOfYAxis / largestNumberInArray;
    
    for (int i = 0; count > i; i++)
    {
        float heightOfBar = -[amountOfTransaction[i] floatValue] * heighOfYAxis / largestNumberInArray;
                CGRect bar = CGRectMake(startpoint - (widthOfBar/2), self.bounds.size.height - offset, widthOfBar, heightOfBar);
        CGContextFillRect(ctx, bar);
        //NSString *text = transactions[i];
        CGPoint transactionPointInBar = CGPointMake(startpoint - (widthOfBar/2), self.bounds.size.height - (offset) + offsetFromLine);
        //[text drawAtPoint:test forWidth:widthOfBar * 2 withFont:myFont minFontSize:minFont actualFontSize:&maxFont lineBreakMode:NSLineBreakByClipping baselineAdjustment:UIBaselineAdjustmentAlignCenters];
        if ([amountOfTransaction[i] floatValue]  != 0)
        {
        CGPoint amountOfTransactionPointInBar = CGPointMake(startpoint - (widthOfBar/2),self.bounds.size.height - offset + heightOfBar - 24);
        NSString *amountOfTransactionString = [NSString stringWithFormat:@"%@", amountOfTransaction[i]];
        [amountOfTransactionString drawInRect:CGRectMake(amountOfTransactionPointInBar.x, amountOfTransactionPointInBar.y, widthOfBar, 20) withFont:myFont lineBreakMode:NSLineBreakByTruncatingMiddle alignment:NSTextAlignmentCenter];
        
        }
        
        
        const char* texts = [transactions[i] UTF8String];
        CGContextSelectFont(ctx, "Helvetica", maxFont, kCGEncodingMacRoman);
        //CGContextSetTextDrawingMode(ctx, kCGTextStroke);
        //CGContextSetRGBFillColor(ctx, 0, 255, 255, 1);
        //CGContextRotateCTM(ctx, 45)
        CGAffineTransform xform = CGAffineTransformMake(
                                                        1.0,  0.25,
                                                        0.25,  -1.0,
                                                        0.0,  0.0);
        
        CGContextSetTextMatrix(ctx, xform);
        CGContextShowTextAtPoint(ctx, transactionPointInBar.x, transactionPointInBar.y + 15, texts, strlen(texts));
        
        //CGContextShowTextAtPoint(ctx, 10, 300, texts, strlen(texts));
        //[amountValue drawAtPoint:value forWidth:widthOfBar withFont:myFont minFontSize:minFont actualFontSize:&maxFont lineBreakMode:NSLineBreakByClipping baselineAdjustment:UIBaselineAdjustmentAlignCenters];

        
        /*
        if (i % 2 == 0)
        {
            CGPoint test = CGPointMake(startpoint - (widthOfBar/2), self.bounds.size.height - (offset) + 4);
            [text drawAtPoint:test forWidth:widthOfBar * 2 withFont:myFont minFontSize:minFont actualFontSize:&maxFont lineBreakMode:NSLineBreakByTruncatingHead baselineAdjustment:UIBaselineAdjustmentAlignCenters];
            NSLog(@"even");
        }
        else
        {
            CGPoint test = CGPointMake(startpoint - (widthOfBar/2), self.bounds.size.height - (offset) + 4 + 20);
            [text drawAtPoint:test forWidth:widthOfBar * 2 withFont:myFont minFontSize:minFont actualFontSize:&maxFont lineBreakMode:NSLineBreakByWordWrapping baselineAdjustment:UIBaselineAdjustmentAlignCenters];
            NSLog(@"odd");
        }
        */
        startpoint = startpoint + newpoint;
        
        
    }
    
    
    //CGContextStrokeLineSegments(ctx, point, 4);
    
    
}


@end
