//
//  UPGradient.m
//  UrbanPiper
//
//  Created by Biks on 3/26/13.
//
//

#import "UPGradient.h"

@interface UPGradient ()

@property (nonatomic, assign) CGGradientRef gradient;

@end

@implementation UPGradient

@synthesize gradient, options;

- (id)initWithStartColor:(UIColor *)iStartColor endColor:(UIColor *)iEndColor {
	return [self initWithColors:[NSArray arrayWithObjects:iStartColor, iEndColor, nil]];
}


- (id)initWithColors:(NSArray *)iColorsArray {
	return [self initWithColors:iColorsArray andLocations:nil];
}


- (id)initWithColors:(NSArray *)iColorsArray andLocations:(NSArray *)iLocations {
	if ((self = [super init])) {
		// we need to do a few things here
		// 1) we need to end up with an array of CGColorRefs instead of UIColors
		// 2) while doing that, we want to make sure all colors have the same colorspace and convert where neccessary
		
		NSMutableArray *aCGColors = [NSMutableArray array];
		CGColorSpaceRef aColorSpace = NULL;
		
		for (UIColor *aUIColor in iColorsArray) {
			[aCGColors addObject:(id)aUIColor.CGColor];
		}
		
		CGFloat *theLocations = NULL;
		if ([iLocations count] > 0 && [iLocations count] == [iColorsArray count]) {
			CGFloat *aLocationsArray = (CGFloat *)calloc([iColorsArray count], sizeof(CGFloat));
			NSUInteger anIndex = 0;
			for (NSNumber *aLocation in iLocations) {
				aLocationsArray[anIndex++] = (CGFloat)[aLocation doubleValue];
			}
			theLocations = aLocationsArray;
		}
		
		self.gradient = CGGradientCreateWithColors(aColorSpace, (__bridge CFArrayRef)aCGColors, (const CGFloat *)theLocations);
		self.options = kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation;
		
		if (theLocations != NULL) {
			free(theLocations);
		}
	}
	return self;
}


- (void)dealloc {
	CGGradientRelease(self.gradient);
}


- (void)drawLinearGradientAtStartPoint:(CGPoint)iStartPoint endPoint:(CGPoint)iEndPoint {
	CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), self.gradient, iStartPoint, iEndPoint, self.options);
}


- (void)drawLinearGradientVerticallyInRect:(CGRect)iRect {
	CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), self.gradient, CGPointMake(iRect.origin.x, iRect.origin.y), CGPointMake(iRect.origin.x, iRect.size.height), self.options);
}


- (void)drawLinearGradientFlippedVerticallyInRect:(CGRect)iRect {
	CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), self.gradient, CGPointMake(iRect.origin.x, iRect.size.height), CGPointMake(iRect.origin.x, iRect.origin.y), self.options);
}


- (void)drawLinearGradientHorizontallyInRect:(CGRect)iRect {
	CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), self.gradient, CGPointMake(iRect.origin.x, iRect.origin.y), CGPointMake(iRect.size.width, iRect.origin.y), self.options);
}


- (void)drawLinearGradientFlippedHorizontallyInRect:(CGRect)iRect {
	CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), self.gradient, CGPointMake(iRect.size.width, iRect.origin.y), CGPointMake(iRect.origin.x, iRect.origin.y), self.options);
}

@end
