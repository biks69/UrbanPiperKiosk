//
//  UPTableViewCell.m
//  UrbanPiper
//
//  Created by Biks on 3/11/13.
//
//

#import "UPTableViewCell.h"
#import "UPTextField.h"

static NSInteger kCellTitleTag = 420;
static NSInteger kSubTitleTag = 421;
static NSInteger kCellEntryFieldTag = 421;

@implementation UPTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)iStyle reuseIdentifier:(NSString *)iReuseIdentifier {
    self = [super initWithStyle:iStyle reuseIdentifier:iReuseIdentifier];
    if (self) {
        // Initialization code
        self.hasSeparator = NO;
        self.isSecure = NO;
        self.isEntryCell = NO;
        self.hasPlaceHolder = NO;
    }
    return self;
}


- (void)setSelected:(BOOL)iSelected animated:(BOOL)iAnimated {
    [super setSelected:iSelected animated:iAnimated];

    // Configure the view for the selected state
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.hasSeparator) {
        CGFloat aStartPoint = self.frame.size.width / 4.5;
        
        if (self.cellStyle == UPTableViewCellStyleFeedback) {
            aStartPoint = self.frame.size.width / 3.5;
        }         
        
        CGRect aSeparatorFrame = CGRectMake(aStartPoint, 0.0, 1.0, (self.contentView.bounds.size.height));
        UIView *aSeparator = [[UIView alloc] initWithFrame:aSeparatorFrame];
        [self.contentView addSubview:aSeparator];
        
        if (self.cellStyle == UPTableViewCellStyleLogin) {
            aSeparator.backgroundColor = [UIColor colorWithRed:(126.0/255.0) green:(189.0/255.0) blue:(17.0/255.0) alpha:1.0];
        } else if (self.cellStyle == UPTableViewCellStyleFeedback) {
            aSeparator.backgroundColor = [UIColor colorWithRed:(15.0/255.0) green:(37.0/255.0) blue:(56.0/255.0) alpha:1.0];
        }
        
    }
    
    if (self.cellTitle) {
        CGFloat aFrameWidth = self.frame.size.width / 4.5 - 20.0;
        CGFloat aTitleLabelWidth = self.frame.size.width / 3.5;
        CGRect aTitleFrame = CGRectIntegral(CGRectMake(8.0f, 2.0, aTitleLabelWidth, (self.contentView.bounds.size.height - 4.0)));

        // Add title
        UILabel *aTitle = (UILabel *)[self.contentView viewWithTag:kCellTitleTag];
        
        if (aTitle) {
            [aTitle removeFromSuperview];
            aTitle = nil;
        }
        
        aTitle = [[UILabel alloc] initWithFrame:aTitleFrame];
        [aTitle setTag:kCellTitleTag];
        [aTitle setBackgroundColor:[UIColor clearColor]];
        [aTitle setTextColor:[UIColor darkGrayColor]];
            
        if (self.cellStyle == UPTableViewCellStyleLogin) {
            [aTitle setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
        } else if (self.cellStyle == UPTableViewCellStyleFeedback) {
             [aTitle setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
        }
        [aTitle setText:self.cellTitle];
        [self.contentView addSubview:aTitle];
        
        if (self.cellSubTitle && self.hasPlaceHolder) {
            CGRect aSubTitleFrame = CGRectMake(aTitleLabelWidth + 5.0, 0.0, self.contentView.bounds.size.width - aTitleFrame.size.width - 60.0, (self.contentView.bounds.size.height - 4.0));
            UILabel *aSubTitle = (UILabel *)[self.contentView viewWithTag:kSubTitleTag];
            
            if (!aSubTitle) {
                aSubTitle = [[UILabel alloc] initWithFrame:aSubTitleFrame];
                [aSubTitle setBackgroundColor:[UIColor clearColor]];
                [aSubTitle setTextAlignment:NSTextAlignmentRight];
                [aSubTitle setTag:kSubTitleTag];
                [aSubTitle setTextColor:[UIColor lightGrayColor]];
                [self.contentView addSubview:aSubTitle];
            }
            [aSubTitle setText:self.cellSubTitle];
        }
        
        if (self.isEntryCell) {
            // Add text field
            UPTextField *anEntryField = (UPTextField *)[self.contentView viewWithTag:kCellEntryFieldTag];
            CGFloat aPointY = 12.0;
            CGFloat aPadding = 25.0;
            CGRect aEntryFrame = CGRectIntegral(CGRectMake((aFrameWidth + aPadding), aPointY, (self.contentView.bounds.size.width - aFrameWidth - (aPadding * 3.0)), (self.contentView.bounds.size.height - 14.0)));
            
            if (self.cellStyle == UPTableViewCellStyleFeedback) {
                aPadding = 65.0;
                aEntryFrame = CGRectIntegral(CGRectMake((aFrameWidth + aPadding), aPointY, (self.contentView.bounds.size.width - aFrameWidth - (aPadding * 2.0) + 8.0), (self.contentView.bounds.size.height - 14.0)));

                
            }
            
            if (!anEntryField) {
                anEntryField = [[UPTextField alloc] initWithFrame:aEntryFrame];
                [anEntryField setTag:kCellEntryFieldTag];
                [anEntryField setDelegate:self.delegate];
                [anEntryField setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
                [anEntryField setBackgroundColor:[UIColor clearColor]];
                [anEntryField setTextColor:[UIColor darkGrayColor]];

                if (self.cellStyle == UPTableViewCellStyleFeedback) {
                    anEntryField.placeholder = @"Enter Here";
                    anEntryField.textAlignment = NSTextAlignmentRight;
                    anEntryField.elementKey = self.cellKey;
                } else {
                    anEntryField.elementKey = @"username";
                }

                if (self.isSecure) {
                    [anEntryField setSecureTextEntry:YES];
                    anEntryField.elementKey = @"password";
                }
                [self.contentView addSubview:anEntryField];
            }
        }
    }
}

@end