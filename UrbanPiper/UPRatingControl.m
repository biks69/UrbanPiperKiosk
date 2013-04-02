//
//  UPRatingControl.m
//  UrbanPiper
//
//  Created by Biks on 3/28/13.
//
//

#import "UPRatingControl.h"

#define BUTTON_TAG_BASE	100
#define BUTTON_WIDTH	21.0f
#define BUTTON_HEIGHT	21.0f
#define BUTTON_PADDING	10.0f

@interface UPRatingControl ()

@property (nonatomic, strong) UIImage *ratingEmptyImage;
@property (nonatomic, strong) UIImage *ratingFullImage;

- (void)touchAtPoint:(CGPoint)iPoint;
- (UITouch *)primaryTouchForSet:(NSSet *)iTouches;
- (void) initialize;

@end


@implementation UPRatingControl
@synthesize rating;


- (id)init {
	return [self initWithFrame:CGRectZero];
}


- (id)initWithFrame:(CGRect)iFrame {
    if ((self = [super initWithFrame:iFrame])) {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)iDecoder {
	if ((self = [super initWithCoder:iDecoder])) {
        [self initialize];
	}
	return self;
}


- (void) initialize {
    _buttonCount = 5;
    self.exclusiveTouch = YES;
}



- (void)drawRect:(CGRect)iRect {
	if (!self.ratingEmptyImage)
		self.ratingEmptyImage = [UIImage imageNamed:@"star_empty.png"];
    
	if (!self.ratingFullImage)
		self.ratingFullImage = [UIImage imageNamed:@"star_full.png"];
    
	CGContextRef aContext = UIGraphicsGetCurrentContext();
    CGRect aContentRect = self.bounds;
	// Decide on button padding
	CGFloat aPadding = (aContentRect.size.width - (_buttonCount * BUTTON_WIDTH)) / (_buttonCount * 2);
	if (aPadding < 0)
		aPadding = 0;
	else if (aPadding > BUTTON_PADDING)
		aPadding = BUTTON_PADDING;
	CGFloat initY = (aContentRect.size.height - BUTTON_HEIGHT) / 2.0f;
	CGFloat aButtonWidth = (_buttonCount * BUTTON_WIDTH) + (_buttonCount * 2 * aPadding);
	CGFloat initX = (aContentRect.size.width - aButtonWidth) / 2.0f;
	
	CGContextSetFillColorWithColor(aContext, self.backgroundColor.CGColor);
	CGContextFillRect(aContext, aContentRect);
	
	CGRect aFrame;
	for (NSUInteger i = 0; i < _buttonCount; i++) {
		aFrame.origin.x = initX + aPadding + (i * BUTTON_WIDTH) + (i * 2 * aPadding);
		aFrame.origin.y = initY;
		aFrame.size.width = BUTTON_WIDTH;
		aFrame.size.height = BUTTON_HEIGHT;
		
		if (i < self.rating)
			[self.ratingFullImage drawInRect:aFrame];
		else
			[self.ratingEmptyImage drawInRect:aFrame];
	}
}


- (void)setRating:(NSInteger)iRating {
	if (rating != iRating) {
		rating = iRating;
		[self setNeedsDisplay];
	}
}


- (void)touchAtPoint:(CGPoint)iPoint {
	CGRect aContentRect = self.bounds;
	// Decide on button padding
	CGFloat aPadding = (aContentRect.size.width - (_buttonCount * BUTTON_WIDTH)) / _buttonCount;
	if (aPadding < 0)
		aPadding = 0;
	else if (aPadding > BUTTON_PADDING)
		aPadding = BUTTON_PADDING;
	CGFloat aButtonWidth = (_buttonCount * BUTTON_WIDTH) + (_buttonCount * 2.0f * aPadding);
	CGFloat initX = (aContentRect.size.width - aButtonWidth) / 2.0f;
	
	// Figure out new rating
	NSInteger aRating;
	if (iPoint.x < initX) {
		aRating = 0;
	} else if (iPoint.x > (initX + aButtonWidth)) {
		aRating = _buttonCount;
	} else {
		// In range
		float temp = ((iPoint.x - initX) / (BUTTON_WIDTH + (2.0f * aPadding)));
		aRating = ceil(temp);
	}
	
	// Update drawing
	if (self.rating != aRating) {
		self.rating = aRating;
		[self setNeedsDisplay];
		
		// Fire a value changed event
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}


- (UITouch *)primaryTouchForSet:(NSSet *)iTouches {
	return [iTouches anyObject];
}


- (void)touchesBegan:(NSSet *)iTouches withEvent:(UIEvent *)iEvent {
	[self touchAtPoint:[[self primaryTouchForSet:iTouches] locationInView:self]];
}


- (void)touchesMoved:(NSSet *)iTouches withEvent:(UIEvent *)iEvent {
	[self touchAtPoint:[[self primaryTouchForSet:iTouches] locationInView:self]];
}


- (void)touchesCancelled:(NSSet *)iTouches withEvent:(UIEvent *)iEvent {
}


- (void)touchesEnded:(NSSet *)iTouches withEvent:(UIEvent *)iEvent {
	[self touchAtPoint:[[self primaryTouchForSet:iTouches] locationInView:self]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectStartRating: elementKey:)]) {
        [self.delegate didSelectStartRating:rating elementKey:self.selectedKey];
    }
}


- (void)layoutSubviews {
	[self setNeedsDisplay];
}

@end
