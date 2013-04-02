//
//  UPRatingControl.h
//  UrbanPiper
//
//  Created by Biks on 3/28/13.
//
//

#import <UIKit/UIKit.h>

@protocol UPRatingControlDelegate <NSObject>

- (void)didSelectStartRating:(NSInteger)iRating elementKey:(NSString *)iKey;

@end

@interface UPRatingControl : UIControl

@property (nonatomic, assign) NSInteger rating;
@property (nonatomic, assign) NSInteger buttonCount;
@property (nonatomic, strong) id <UPRatingControlDelegate> delegate;
@property (nonatomic, strong) NSString *selectedKey;

@end
