//
//  UPMenuSelectionView.m
//  UrbanPiper
//
//  Created by Biks on 3/26/13.
//
//

#import "UPMenuSelectionView.h"
#import "UPMenuButton.h"

@interface UPMenuSelectionView ()

@property (nonatomic, strong) CAShapeLayer *mask;
@property (nonatomic, strong) NSDictionary *menuSettings;
@property (nonatomic, weak) UPMenuButton *icon;

@end

@implementation UPMenuSelectionView

- (id)initWithFrame:(CGRect)iFrame {
    self = [super initWithFrame:iFrame];
    if (self) {
        // Initialization code
        
        self.menuSettings = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"configuration" ofType:@"plist"]];
        
        /*
        CGFloat aShadowSize = 50.0;
		UIGraphicsBeginImageContextWithOptions(iFrame.size, NO, [UIScreen mainScreen].scale);
		CGContextRef aContext = UIGraphicsGetCurrentContext();
		
		CGContextSaveGState(aContext);
		CGContextSetShadowWithColor(aContext, CGSizeZero, 5.0, [UIColor blackColor].CGColor);
		CGContextBeginTransparencyLayer(aContext, NULL);
		CGContextAddRoundRectWithCorners(aContext, CGRectInset(self.bounds, aShadowSize, aShadowSize), aShadowSize, aShadowSize, aShadowSize, aShadowSize, aShadowSize);
		CGContextClip(aContext);
		
		CGContextSetFillColorWithColor(aContext, [UIColor colorWithRed:(32.0/255.0) green:(61.0/255) blue:(105.0/255.0) alpha:1.0].CGColor);
		CGContextFillRect(aContext, self.bounds);
		
		// gloss!

		CGContextEndTransparencyLayer(aContext);
		CGContextRestoreGState(aContext);*/
        
        
        
        
        
        
        /*self.selectiveBorderFlag = AUISelectiveBordersFlagLeft | AUISelectiveBordersFlagBottom;
        self.selectiveBordersColor = [UIColor colorWithRed:(29.0/255.0) green:(129.0/255) blue:(163.0/255.0) alpha:1.0];
        self.selectiveBordersWidth = 3.0;*/
        
        UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0, 0.0, self.bounds.size.width - 1.0, self.bounds.size.height - 1.0)
                                                    byRoundingCorners:UIRectCornerBottomLeft
                                                          cornerRadii:CGSizeMake(50.0f, 50.0f)];
        self.mask = [CAShapeLayer layer];
        self.mask.frame = self.bounds;
        self.mask.path = aPath.CGPath;
        self.layer.mask = self.mask;
        self.layer.masksToBounds = NO;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat anIconOffset = 0.0;
    CGFloat aFirstStartX = 50.0;
    
    NSArray *anIconInfo = [[self.menuSettings objectForKey:@"menu"] objectForKey:@"icons"];
    
    if (anIconInfo && [anIconInfo count] > 0) {
        for (NSDictionary *anIconDict in anIconInfo) {
            UIImage *anIcon = [UIImage imageNamed:[anIconDict objectForKey:@"icon"]];
            UPMenuButton *anIconButton = [[UPMenuButton alloc] initWithIcon:anIcon shadowed:YES];
            [anIconButton setBackgroundColor:[UIColor clearColor]];
            anIconButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
            anIconButton.tag = [[anIconDict objectForKey:@"tag"] integerValue];
            anIconButton.title = [anIconDict objectForKey:@"title"];
            anIconButton.isHidden = [[anIconDict objectForKey:@"hidden"] boolValue];
            anIconButton.alpha = 1.0;
            
            NSInteger anIndex = [anIconInfo indexOfObject:anIconDict];
            
            if (anIndex == 0) {
                anIconOffset = aFirstStartX;
            } else {
                anIconOffset += anIconButton.width + 140.0;
            }
            
            CGRect aRect = anIconButton.frame;
            aRect.origin.x += anIconOffset;
            aRect.origin.y = (self.frame.size.height / 2.0) - (anIcon.size.height / 2.0) - 10.0;
            anIconButton.frame = aRect;
            [anIconButton addTarget:self action:@selector(handleIconTap:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:anIconButton];
        }
    }
    
}


- (void)drawRect:(CGRect)iRect {
    [super drawRect:iRect];
    CGContextRef aContextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(aContextRef);
    CGContextSetShadowWithColor(aContextRef, CGSizeMake(0.0, -5.0), 4.0, [UIColor blackColor].CGColor);
    UIColor *aFillColor = [UIColor colorWithRed:(32.0/255.0) green:(61.0/255) blue:(105.0/255.0) alpha:0.8];
    CGContextSetFillColorWithColor(aContextRef, aFillColor.CGColor);
    CGRect aFillRect = iRect;
    aFillRect.size.height -= 3.0;
    CGContextFillRect(aContextRef, iRect);
    CGContextRestoreGState(aContextRef);
}



- (void)handleIconTap:(id)iSender {
    NSInteger aTag = [iSender tag];
	self.icon = (UPMenuButton *)[self viewWithTag:aTag];
	
	if (self.icon) {
		[self.icon setIsIconTapped:YES];
		[self.icon setNeedsDisplay];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectionMenuOptionWithTag:)]) {
            [self.delegate didSelectionMenuOptionWithTag:aTag];
        }
        
        __weak UPMenuSelectionView *aBlockSelf = self;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[aBlockSelf unhighlightSelectedIcon];
		});
	}
}


- (void)unhighlightSelectedIcon {
    [self.icon setIsIconTapped:NO];
    [self.icon setNeedsDisplay];
}

@end