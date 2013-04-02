//
//  UPButton.h
//  UrbanPiper
//
//  Created by Biks on 3/12/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UPButton : UIButton

@property (nonatomic, strong) NSString *displayTitle;

- (void)isTappable:(BOOL)iTappable;

@end
