//
//  UPMenuButton.h
//  UrbanPiper
//
//  Created by Biks on 3/26/13.
//
//

#import <UIKit/UIKit.h>

@interface UPMenuButton : UIControl

- (id)initWithIcon:(UIImage *)iIcon shadowed:(BOOL)iHasShadow;

@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign) BOOL isIconTapped;
@property (nonatomic, assign) CGFloat width;

@end
