//
//  UPMenuButton.m
//  UrbanPiper
//
//  Created by Biks on 3/26/13.
//
//

#import "UPMenuButton.h"
#import "UPGradient.h"

static UPGradient *globalIconButtonGradient = nil;
static NSUInteger const kIconWidth = 35.0;

@interface UPMenuButton ()

@property (nonatomic, assign) BOOL hasShadow;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation UPMenuButton
@synthesize icon, hasShadow, isIconTapped, width;

- (id)initWithIcon:(UIImage *)iIcon shadowed:(BOOL)iHasShadow {
	if ((self = [super initWithFrame:CGRectMake(0.0, 0.0, iIcon.size.width + 4.0, iIcon.size.height + 4.0)])) {
		self.icon = iIcon;
		self.opaque = NO;
		self.hasShadow = iHasShadow;
		self.isAccessibilityElement = YES;
        self.backgroundColor = [UIColor clearColor];
		self.accessibilityTraits = UIAccessibilityTraitButton;
        CGRect aTitleFrame = CGRectMake(0.0, kIconWidth + 2.0, 0.0, 0.0);
        self.titleLabel = [[UILabel alloc] initWithFrame:aTitleFrame];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor colorWithRed:(29.0/255.0) green:(129.0/255) blue:(163.0/255.0) alpha:1.0];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        self.titleLabel.shadowColor = [UIColor colorWithRed:(29.0/255.0) green:(129.0/255) blue:(163.0/255.0) alpha:1.0];
        self.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        [self addSubview:self.titleLabel];
        
	}
	return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.title) {
        self.titleLabel.text = self.title;
        CGSize aTextSize = [self.title sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        CGRect aTitleFrame = self.titleLabel.frame;
        aTitleFrame.size.height = aTextSize.height + 4.0;
        aTitleFrame.size.width = aTextSize.width + 4.0;
        self.titleLabel.frame = aTitleFrame;
    }
}


- (void)drawRect:(CGRect)iRect {
	if (self.icon) {
		if (!globalIconButtonGradient) {
			globalIconButtonGradient = [[UPGradient alloc] initWithStartColor:[UIColor colorWithRed:(29.0/255.0) green:(129.0/255) blue:(163.0/255.0) alpha:1.0] endColor:[UIColor colorWithRed:(29.0/255.0) green:(129.0/255) blue:(163.0/255.0) alpha:1.0]];
		}
		
		CGContextRef aContext = UIGraphicsGetCurrentContext();
		
		if (self.hasShadow) {
			CGContextSetShadowWithColor(aContext, CGSizeMake(0.0, 1.0), 2.0, [UIColor colorWithRed:(29.0/255.0) green:(129.0/255) blue:(163.0/255.0) alpha:1.0].CGColor);
		}
        
		CGContextBeginTransparencyLayer(aContext, NULL);
		CGContextTranslateCTM(aContext, 0.0, self.bounds.size.height);
		CGContextScaleCTM(aContext, 1.0, -1.0);
        CGFloat aStartXClipPoint = (self.bounds.size.width - self.icon.size.width) / 2.0 + 5.0;
		CGContextClipToMask(aContext, CGRectMake(aStartXClipPoint, 2.0, self.bounds.size.width - 8.0, self.bounds.size.height - 2.0), self.icon.CGImage);
        if (!self.isHidden) {
            if (!self.isIconTapped) {
                self.titleLabel.textColor = [UIColor colorWithRed:(29.0/255.0) green:(129.0/255) blue:(163.0/255.0) alpha:1.0];
                [globalIconButtonGradient drawLinearGradientFlippedVerticallyInRect:self.bounds];
            } else {
                self.titleLabel.textColor = [UIColor whiteColor];
                CGContextSetFillColorWithColor(aContext, [UIColor whiteColor].CGColor);
                CGContextFillRect(aContext, self.bounds);
            }
        } else {
            self.enabled = NO;
            [globalIconButtonGradient drawLinearGradientFlippedVerticallyInRect:self.bounds];
            self.alpha = 0.5;
        }

		CGContextEndTransparencyLayer(aContext);
	}
}


- (CGFloat)width {
    return self.bounds.size.width;
}

@end