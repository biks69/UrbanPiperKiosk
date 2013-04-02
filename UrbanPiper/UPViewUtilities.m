//
//  UPViewUtilities.m
//  UrbanPiper
//
//  Created by Biks on 3/26/13.
//
//

#import "UPViewUtilities.h"

CGRect CGRectMakeIntegral(CGFloat iX, CGFloat iY, CGFloat iWidth, CGFloat iHeight) {
	return CGRectIntegral(CGRectMake(iX, iY, iWidth, iHeight));
}


CGRect CGRectMakeWithPointAndSize(CGPoint iOrigin, CGSize iSize) {
	return CGRectMake(iOrigin.x, iOrigin.y, iSize.width, iSize.height);
}


CGMutablePathRef CGPathCreateRoundedRect(CGRect iRect, CGFloat iCornerRadius) {
	return CGPathCreateRoundedRectWithCorners(iRect, iCornerRadius, YES, YES, YES, YES);
}


CGMutablePathRef CGPathCreateRoundedRectWithCorners(CGRect iRect, CGFloat iCornerRadius, BOOL iTopLeft, BOOL iTopRight, BOOL iBottomRight, BOOL iBottomLeft) {
	CGMutablePathRef aPath = CGPathCreateMutable();
	
	if (iCornerRadius > 0.0) {
		CGPathMoveToPoint(aPath, NULL, iRect.origin.x, iCornerRadius + iRect.origin.y);
		
		if (iTopLeft) {
			CGPathAddArcToPoint(aPath, NULL, iRect.origin.x, iRect.origin.y, iRect.origin.x + iCornerRadius, iRect.origin.y, iCornerRadius); // top left
		} else {
			CGPathAddLineToPoint(aPath, NULL, iRect.origin.x, iRect.origin.y);
		}
		
		if (iTopRight) {
			CGPathAddArcToPoint(aPath, NULL, iRect.origin.x + iRect.size.width, iRect.origin.y, iRect.origin.x + iRect.size.width, iRect.origin.y + iCornerRadius, iCornerRadius); // top right
		} else {
			CGPathAddLineToPoint(aPath, NULL, iRect.origin.x + iRect.size.width, iRect.origin.y);
		}
		
		if (iBottomRight) {
			CGPathAddArcToPoint(aPath, NULL, iRect.origin.x + iRect.size.width, iRect.origin.y + iRect.size.height, iRect.origin.x + iRect.size.width - iCornerRadius, iRect.origin.y + iRect.size.height, iCornerRadius); // bottom right
		} else {
			CGPathAddLineToPoint(aPath, NULL, iRect.origin.x + iRect.size.width, iRect.origin.y + iRect.size.height);
		}
		
		if (iBottomLeft) {
			CGPathAddArcToPoint(aPath, NULL, iRect.origin.x, iRect.origin.y + iRect.size.height, iRect.origin.x, iRect.origin.y, iCornerRadius); // bottom left
		} else {
			CGPathAddLineToPoint(aPath, NULL, iRect.origin.x, iRect.origin.y + iRect.size.height);
		}
	} else {
		CGPathAddRect(aPath, NULL, iRect);
	}
	
	CGPathCloseSubpath(aPath);
	
	return aPath;
}


void CGContextAddRoundRect(CGContextRef iContext, CGRect iRect, CGFloat iCornerRadius) {
	CGContextAddRoundRectWithCorners(iContext, iRect, iCornerRadius, YES, YES, YES, YES);
}


void CGContextAddRoundRectWithCorners(CGContextRef iContext, CGRect iRect, CGFloat iCornerRadius, BOOL iTopLeft, BOOL iTopRight, BOOL iBottomRight, BOOL iBottomLeft) {
	CGMutablePathRef aPath = CGPathCreateRoundedRectWithCorners(iRect, iCornerRadius, iTopLeft, iTopRight, iBottomRight, iBottomLeft);
	CGContextAddPath(iContext, aPath);
	CGPathRelease(aPath);
}


void CGContextAddDetailDisclosurePath(CGContextRef iContext, CGPoint iPoint) {
	const CGFloat aLineLength = 5.0;
	CGFloat anArrowX = iPoint.x;
	CGFloat anArrowY = iPoint.y;
	CGContextMoveToPoint(iContext, anArrowX - aLineLength, anArrowY - aLineLength);
	CGContextAddLineToPoint(iContext, anArrowX, anArrowY);
	CGContextAddLineToPoint(iContext, anArrowX - aLineLength, anArrowY + aLineLength);
	CGContextSetLineCap(iContext, kCGLineCapSquare);
	CGContextSetLineJoin(iContext, kCGLineJoinMiter);
	CGContextSetLineWidth(iContext, 3);
}

@implementation UPViewUtilities

@end
