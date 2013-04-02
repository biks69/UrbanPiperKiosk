//
//  UPViewUtilities.h
//  UrbanPiper
//
//  Created by Biks on 3/26/13.
//
//

#import <Foundation/Foundation.h>

CGRect CGRectMakeIntegral(CGFloat iX, CGFloat iY, CGFloat iWidth, CGFloat iHeight);
CGRect CGRectMakeWithPointAndSize(CGPoint iOrigin, CGSize iSize);

CGMutablePathRef CGPathCreateRoundedRect(CGRect iRect, CGFloat iCornerRadius);
CGMutablePathRef CGPathCreateRoundedRectWithCorners(CGRect iRect, CGFloat iCornerRadius, BOOL iTopLeft, BOOL iTopRight, BOOL iBottomRight, BOOL iBottomLeft);
void CGContextAddRoundRect(CGContextRef iContext, CGRect iRect, CGFloat iCornerRadius);
void CGContextAddRoundRectWithCorners(CGContextRef iContext, CGRect iRect, CGFloat iCornerRadius, BOOL iTopLeft, BOOL iTopRight, BOOL iBottomRight, BOOL iBottomLeft);

void CGContextAddDetailDisclosurePath(CGContextRef iContext, CGPoint iPoint);

@interface UPViewUtilities : NSObject

@end
