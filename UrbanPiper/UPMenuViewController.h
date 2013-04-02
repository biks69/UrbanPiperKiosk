//
//  UPMenuViewController.h
//  UrbanPiper
//
//  Created by Biks on 3/24/13.
//
//

#import <UIKit/UIKit.h>
#import "UPMenuSelectionView.h"

@interface UPMenuViewController : UIViewController <UIGestureRecognizerDelegate, UIAlertViewDelegate, UPMenuSelectionViewDelegate>

// Properties
@property (nonatomic, strong) NSString *bizName;

@end