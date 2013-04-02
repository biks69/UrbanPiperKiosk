//
//  UPTableViewCell.h
//  UrbanPiper
//
//  Created by Biks on 3/11/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UPTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL hasSeparator;
@property (nonatomic, assign) BOOL isSecure;
@property (nonatomic, strong) NSString *cellTitle;
@property (nonatomic, assign) id<UITextFieldDelegate> delegate;

@end
