//
//  UPGradient.h
//  UrbanPiper
//
//  Created by Biks on 3/26/13.
//
//

#import <Foundation/Foundation.h>

@interface UPGradient : NSObject

@property (nonatomic, assign) CGGradientDrawingOptions options;

- (id)initWithStartColor:(UIColor *)iStartColor endColor:(UIColor *)iEndColor;
- (id)initWithColors:(NSArray *)iColorsArray;
- (id)initWithColors:(NSArray *)iColorsArray andLocations:(NSArray *)iLocations;

- (void)drawLinearGradientAtStartPoint:(CGPoint)iStartPoint endPoint:(CGPoint)iEndPoint;
- (void)drawLinearGradientVerticallyInRect:(CGRect)iRect;
- (void)drawLinearGradientFlippedVerticallyInRect:(CGRect)iRect;
- (void)drawLinearGradientHorizontallyInRect:(CGRect)iRect;
- (void)drawLinearGradientFlippedHorizontallyInRect:(CGRect)iRect;

@end
