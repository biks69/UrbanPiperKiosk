//
//  UPButton.m
//  UrbanPiper
//
//  Created by Biks on 3/12/13.
//
//

#import "UPButton.h"

@interface UPButton ()

@property (nonatomic, strong) CAShapeLayer *mask;
@property (nonatomic, assign) BOOL isTapped;

@end

@implementation UPButton

- (id)initWithFrame:(CGRect)iFrame {
    self = [super initWithFrame:iFrame];
    if (self) {
        // Initialization code
        UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0, 0.0, self.bounds.size.width - 1.0, self.bounds.size.height - 1.0)
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(8.0f, 8.0f)];
        self.mask = [CAShapeLayer layer];
        self.mask.frame = self.bounds;
        self.mask.path = aPath.CGPath;
        self.layer.mask = self.mask;
        self.isTapped = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)iRect {
    // Drawing code
    [super drawRect:iRect];
    
    CGColorRef aFirstColor = [[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(231.0/255.0) alpha:1.0] CGColor];
    CGColorRef aSecondColor = [[UIColor colorWithRed:(168.0/255.0) green:(175.0/255.0) blue:(187.0/255.0) alpha:1.0] CGColor];
    NSArray *aColorSet = [NSArray arrayWithObjects:(__bridge id)aFirstColor, (__bridge id)aSecondColor, nil];
    CGFloat locations[] = {0, 1};
    
    CGGradientRef aGradient =
    CGGradientCreateWithColors(CGColorGetColorSpace(aFirstColor),
                               (__bridge CFArrayRef)aColorSet, locations);
    
    // the start/end points
    CGPoint aTop = CGPointMake(CGRectGetMidX(self.bounds), self.bounds.origin.y);
    CGPoint aBottom = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    
    // draw
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(context, aGradient, aTop, aBottom, 0);
    CGGradientRelease(aGradient);
    
    CGRect aFrame = iRect;
    aFrame.origin.y += 8.0;
    
    if (self.displayTitle) {
        [[UIColor lightGrayColor] set];
        
        if (self.enabled) {
            [[UIColor grayColor] set];
        }
        
        if (self.isTapped) {
            [[UIColor whiteColor] set];
        }
        
        [self.displayTitle drawInRect:aFrame withFont:[UIFont fontWithName:@"Helvetica" size:18.0] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    }
}


- (void)touchesBegan:(NSSet *)iTouches withEvent:(UIEvent *)iEvent {
    self.isTapped = YES;
    [self setNeedsDisplay];
    [super touchesBegan:iTouches withEvent:iEvent];
}


- (void)touchesEnded:(NSSet *)iTouches withEvent:(UIEvent *)iEvent{
    [super touchesEnded:iTouches withEvent:iEvent];
    self.isTapped = NO;
    [self setNeedsDisplay];
}


- (void)isTappable:(BOOL)iTappable {
    self.enabled = iTappable;
    [self setNeedsDisplay];
}

@end
