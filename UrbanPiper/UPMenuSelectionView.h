//
//  UPMenuSelectionView.h
//  UrbanPiper
//
//  Created by Biks on 3/26/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol UPMenuSelectionViewDelegate <NSObject>

- (void)didSelectionMenuOptionWithTag:(NSInteger)iTag;

@end

@interface UPMenuSelectionView : UIView

@property (nonatomic, strong) id <UPMenuSelectionViewDelegate> delegate;        // This should not be set as strong, will look into it later

@end
