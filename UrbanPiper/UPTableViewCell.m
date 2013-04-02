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
static NSInteger kCellEntryFieldTag = 421;

@implementation UPTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)iStyle reuseIdentifier:(NSString *)iReuseIdentifier {
    self = [super initWithStyle:iStyle reuseIdentifier:iReuseIdentifier];
    if (self) {
        // Initialization code
        self.hasSeparator = NO;
        self.isSecure = NO;
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
        const CGFloat aStartPoint = self.frame.size.width / 4.5;
        UIView *aSeparator = [[UIView alloc] initWithFrame:CGRectMake(aStartPoint, 0.0, 1.0, (self.contentView.bounds.size.height))];
        aSeparator.backgroundColor = [UIColor colorWithRed:(126.0/255.0) green:(189.0/255.0) blue:(17.0/255.0) alpha:1.0];
        [self.contentView addSubview:aSeparator];
    }
    
    if (self.cellTitle) {
        const CGFloat aWidth = self.frame.size.width / 4.5 - 20.0;
        CGRect aTitleFrame = CGRectIntegral(CGRectMake(8.0f, 2.0, aWidth, (self.contentView.bounds.size.height - 4.0)));

        // Add title
        UILabel *aTitle = (UILabel *)[self.contentView viewWithTag:kCellTitleTag];

        if (!aTitle) {
            aTitle = [[UILabel alloc] initWithFrame:aTitleFrame];
            [aTitle setTag:kCellTitleTag];
            [aTitle setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
            [aTitle setBackgroundColor:[UIColor clearColor]];
            [aTitle setTextColor:[UIColor lightGrayColor]];
            [aTitle setText:self.cellTitle];
            [self.contentView addSubview:aTitle];
        }
        
        // Add text field
        UPTextField *anEntryField = (UPTextField *)[self.contentView viewWithTag:kCellEntryFieldTag];
        CGFloat aPointY = 3.0;
        const CGFloat aPadding = 25.0;
        CGRect aEntryFrame = CGRectIntegral(CGRectMake((aTitleFrame.size.width + aPadding), aPointY, (self.contentView.bounds.size.width - aWidth - (aPadding * 3.0)), (self.contentView.bounds.size.height - 7.0)));

        if (!anEntryField) {
            anEntryField = [[UPTextField alloc] initWithFrame:aEntryFrame];
            [anEntryField setTag:kCellEntryFieldTag];
            [anEntryField setDelegate:self.delegate];
            [anEntryField setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
            [anEntryField setBackgroundColor:[UIColor clearColor]];
            anEntryField.elementKey = @"username";
            
            if (self.isSecure) {
                [anEntryField setSecureTextEntry:YES];
                anEntryField.elementKey = @"password";
            }
            [self.contentView addSubview:anEntryField];
        }
    }
    
    
}

@end