//
//  UPTableViewCell.h
//  UrbanPiper
//
//  Created by Biks on 3/11/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum  {
    UPTableViewCellStyleLogin = 0,
    UPTableViewCellStyleFeedback
} UPTableViewCellStyle;

@interface UPTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL hasSeparator;
@property (nonatomic, assign) BOOL hasPlaceHolder;
@property (nonatomic, assign) BOOL isEntryCell;
@property (nonatomic, assign) BOOL isSecure;
@property (nonatomic, assign) UPTableViewCellStyle cellStyle;
@property (nonatomic, strong) NSString *cellTitle;
@property (nonatomic, strong) NSString *cellSubTitle;
@property (nonatomic, strong) NSString *cellKey;
@property (nonatomic, assign) id<UITextFieldDelegate> delegate;

@end
