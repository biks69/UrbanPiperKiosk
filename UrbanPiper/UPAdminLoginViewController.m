//
//  UPAdminLoginViewController.m
//  UrbanPiper
//
//  Created by Biks on 3/9/13.
//
//

#import "/usr/include/objc/objc-runtime.h"
#import "UPAdminLoginViewController.h"
#import "UPAppDelegate.h"
#import "UPMenuViewController.h"
#import "UPRequestManager.h"
#import "UPTableViewCell.h"
#import "UPCustomer.h"
#import "UPTextField.h"
#import "UPButton.h"

static CGFloat kPadding = 20.0;
static CGFloat kCellWidth = 500.0;
static CGFloat kButtonWidth = 440.0;
static NSUInteger kNumberOfFormElements = 2;

@interface UPAdminLoginViewController ()

@property (nonatomic, strong) UIImageView *upLogo;
@property (nonatomic, strong) UITableView *adminLoginView;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UPButton *signUpButton;
@property (nonatomic, strong) UIScrollView *viewContainer;
@property (nonatomic, assign) UPTextField *activeTextField;
@property (nonatomic, strong) NSMutableDictionary *formValues;
@property (nonatomic, strong) UPRequestManager *requestManager;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIAlertView *errorAlert;

- (BOOL)isFormValid;

@end

@implementation UPAdminLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formValues = [NSMutableDictionary dictionary];
    self.requestManager = [[UPRequestManager alloc] init];
    
    // Add keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGround.png"]];
    
    self.viewContainer = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.viewContainer setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.viewContainer];
    [self setUpSubViews];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setUpSubViews {
    
    // Add the company Logo
    UIImage *aLogo = [UIImage imageNamed:@"urbanpiper-logo"];
    CGFloat aViewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat aViewHeight = CGRectGetHeight(self.view.bounds);
    CGFloat aLogoX = floorf(aViewWidth / 2.0) - (aLogo.size.width / 2.0);
    CGRect aLogoFrame = CGRectIntegral(CGRectMake(aLogoX , (4 * kPadding), aLogo.size.width, aLogo.size.height));
    // NSLog(@"aLogoFrame : %f : %f: %f: %f",aLogoFrame.origin.x, aLogoFrame.origin.y, aLogoFrame.size.width, aLogoFrame.size.height);
    CGRect aLogoAnimationFrame = CGRectIntegral(CGRectMake((aViewWidth / 2.0), (aViewHeight / 2.0), aLogo.size.width, aLogo.size.height));
    self.upLogo = [[UIImageView alloc] initWithFrame:aLogoAnimationFrame];
    self.upLogo.layer.shadowColor = [UIColor blackColor].CGColor;
    self.upLogo.layer.shadowRadius = 3.0;
    self.upLogo.layer.shadowOffset = CGSizeMake(-3.0, -3.0);
    self.upLogo.backgroundColor = [UIColor clearColor];
    self.upLogo.image = aLogo;
    self.upLogo.center = self.view.center;
    [self.viewContainer addSubview:self.upLogo];

    // Add the company name
    NSString *aParentCompany = @"UrbanPiper";
    CGSize aSize = [aParentCompany sizeWithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:34.0]];
    CGFloat aHeadingX = floorf(aViewWidth / 2.0) - (aSize.width / 2.0) + 10.0;
    CGRect aHeadingFrame = CGRectIntegral(CGRectMake(aHeadingX, aLogoFrame.origin.y + aLogoFrame.size.height, aSize.width, aSize.height));
    self.companyName = [[UILabel alloc] initWithFrame:aHeadingFrame];
    [self.companyName setBackgroundColor:[UIColor clearColor]];
    [self.companyName setTextColor:[UIColor whiteColor]];
    [self.companyName setText:aParentCompany];
    [self.companyName setFont:[UIFont fontWithName:@"Helvetica" size:32.0]];
    
    // Add the Login Table
    CGRect aTableFrame = CGRectIntegral(CGRectMake((aViewWidth - kCellWidth) / 2.0, aLogoFrame.origin.y + aLogoFrame.size.height + aHeadingFrame.size.height - (kPadding / 2.0), kCellWidth, 120.0));
    self.adminLoginView = [[UITableView alloc] initWithFrame:aTableFrame style:UITableViewStyleGrouped];
    self.adminLoginView.delegate = self;
    self.adminLoginView.dataSource = self;
    self.adminLoginView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.adminLoginView.separatorColor = [UIColor colorWithRed:(126.0/255.0) green:(189.0/255.0) blue:(17.0/255.0) alpha:1.0];
    self.adminLoginView.scrollEnabled = NO;
    self.adminLoginView.backgroundColor = [UIColor clearColor];
    self.adminLoginView.backgroundView = nil;
    self.adminLoginView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.adminLoginView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^ {
        self.upLogo.frame = aLogoFrame;
    } completion:^(BOOL iStop) {
        if (iStop) {
            [self performSelector:@selector(addElements) withObject:nil afterDelay:0.2];
        }
    }];
    
    // Add the Sign-Up Button
    CGRect aButtonFrame = CGRectIntegral(CGRectMake((aViewWidth - kButtonWidth) / 2.0, aLogoFrame.origin.y + aLogoFrame.size.height + aHeadingFrame.size.height + kPadding + aTableFrame.size.height, kButtonWidth, 40.0));
    self.signUpButton = [[UPButton alloc] initWithFrame:aButtonFrame];
    [self.signUpButton addTarget:self action:@selector(authenticate:) forControlEvents:UIControlEventTouchUpInside];
    self.signUpButton.enabled = NO;
    self.signUpButton.displayTitle = @"Sign In";
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect aSpinnerFrame = self.spinner.frame;
    aSpinnerFrame.origin.x += aButtonFrame.size.width - 40.0;
    aSpinnerFrame.origin.y += 10.0;
    self.spinner.frame = aSpinnerFrame;
}



- (void)keyboardWillShow:(NSNotification *)iNotification {
    CGSize aKeyboardSize = [[[iNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets aContentInsets = UIEdgeInsetsMake(0.0, 0.0, aKeyboardSize.width, 0.0);
    self.viewContainer.contentInset = aContentInsets;
    self.viewContainer.scrollIndicatorInsets = aContentInsets;
    CGRect aRect = self.view.bounds;
    aRect.size.height -= aKeyboardSize.width;
    
    CGPoint aScrollPoint = CGPointMake(0.0, self.activeTextField.frame.size.height + self.signUpButton.frame.size.height - 20.0);
    [self.viewContainer setContentOffset:aScrollPoint animated:YES];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    [self.viewContainer setContentOffset:CGPointZero animated:YES];
}


- (IBAction)dismissKeyboard:(id)iSender {
    [self.activeTextField resignFirstResponder];
}


- (void)addElements {
    
    [UIView animateWithDuration:2.0 delay:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^ {
        [self.viewContainer addSubview:self.companyName];
        [self.viewContainer addSubview:self.adminLoginView];
        [self.viewContainer addSubview:self.signUpButton];
    } completion:^(BOOL iStop) {
        if (iStop) {
            // NSLog(@"Animation Complete :)");
        }
    }];
}


#pragma mark -
#pragma mark TableView Delegates/DataSources

- (NSInteger)tableView:(UITableView *)iTableView numberOfRowsInSection:(NSInteger)iSection {
    return 2;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)iTableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)iTableView cellForRowAtIndexPath:(NSIndexPath *)iIndexPath {
    static NSString *aCellIdentifier = @"kAdminLoginCell";
    UPTableViewCell *aCell = (UPTableViewCell *)[iTableView dequeueReusableCellWithIdentifier:aCellIdentifier];
    
    if (aCell == nil) {
        aCell = [[UPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aCellIdentifier];
        aCell.hasSeparator = YES;
        aCell.cellStyle = UPTableViewCellStyleLogin;
        aCell.delegate = self;
        aCell.isEntryCell = YES;
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    aCell.cellTitle = @"Organization";
    
    if (iIndexPath.row == 1) {
        aCell.cellTitle = @"Password";
        aCell.isSecure = YES;
    }
    
    aCell.textLabel.text = nil;
    return aCell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Orientation Methods

- (BOOL)shouldAutorotate {
    return YES;
}


#pragma mark -
#pragma mark Orientation Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)iTextField {
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)iTextField {
    self.activeTextField = (UPTextField *)iTextField;
    [self.activeTextField becomeFirstResponder];
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)iTextField {
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)iTextField {

    if ([self isFormValid]) {
        [self.signUpButton isTappable:YES];
    } else {
        [self.signUpButton isTappable:NO];
    }
    
    self.activeTextField = nil;
}


- (BOOL)textField:(UITextField *)iTextField shouldChangeCharactersInRange:(NSRange)iRange replacementString:(NSString *)iString {
    
    NSString *aNewValue = [iTextField.text stringByReplacingCharactersInRange:iRange withString:iString];
    
    [self.formValues setObject:aNewValue forKey:self.activeTextField.elementKey];
    
    if ([self isFormValid]) {
        [self.signUpButton isTappable:YES];
    } else {
        [self.signUpButton isTappable:NO];
    }
    
    return YES;
}


- (void)selectTextInTextField:(UITextField *)iTextField range:(NSRange)range {
    UITextPosition *from = [iTextField positionFromPosition:[iTextField beginningOfDocument] offset:range.location];
    UITextPosition *to = [iTextField positionFromPosition:from offset:range.length];
    [iTextField setSelectedTextRange:[iTextField textRangeFromPosition:from toPosition:to]];
}


- (BOOL)textFieldShouldClear:(UITextField *)iTextField {
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)iTextField {
    return YES;
}


- (BOOL)isFormValid {
    BOOL isValid = NO;
    
    if ([[self.formValues allKeys] count] == kNumberOfFormElements) {
        for (NSString *aKey in [self.formValues allKeys]) {
            NSString *aValue = [self.formValues valueForKey:aKey];
            
            if (aValue && [aValue length] > 0) {
                isValid = YES;
            } else {
                isValid = NO;
                break;
            }
        }
    }
    
    return isValid;
}


- (IBAction)authenticate:(id)iSender {
    [self.activeTextField resignFirstResponder];
    [self.signUpButton addSubview:self.spinner];
    [self.spinner startAnimating];
    
    NSString *aURLString = @"https://api.urbanpiper.com/api/v1/auth/me/?format=json";
    
    [self.requestManager sendRequestForURL:[NSURL URLWithString:aURLString] authType:UPAuthenticationTypeBASIC requestType:@"GET" body:self.formValues completionBlock:^(NSDictionary *iResponse, NSError *iError) {
        NSLog(@"iResponse : %@",iResponse);
        NSLog(@"iError : %@",iError);
        
        if (iResponse && [iResponse count] > 0) {
            
            if ([iResponse valueForKey:@"authKey"]) {
                [[UPSession sharedUPSession] setSharedAuthKey:[iResponse valueForKey:@"authKey"]];
            }
            
            if ([iResponse valueForKey:@"username"]) {
                [[UPSession sharedUPSession] setLoggedInUserName:[iResponse valueForKey:@"username"]];
            }
            
            [self fetchBusinessInformation];
            
        } else {
            self.errorAlert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:[iError domain] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [self.errorAlert show];
        }
    }];
}


- (void)fetchBusinessInformation {
    NSString *aFetchURL = @"https://api.urbanpiper.com/api/v1/biz/?format=json";
    NSString *aParamString = [NSString stringWithFormat:@"&username=%@&api_key=%@",[[UPSession sharedUPSession] loggedInUserName],[[UPSession sharedUPSession]sharedAuthKey]];
    NSString *aFetchURLString = [NSString stringWithFormat:@"%@%@",aFetchURL,aParamString];
    
    [self.requestManager sendRequestForURL:[NSURL URLWithString:aFetchURLString] authType:UPAuthenticationTypeGET requestType:@"GET" body:nil completionBlock:^(NSDictionary *iResponse, NSError *iError) {
        
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];

        if (iResponse && [iResponse count] > 0) {
            NSDictionary *aUserInfo = [[iResponse valueForKey:@"objects"] objectAtIndex:0];
            UPCustomer *aCustomer = [[UPCustomer alloc] initWithDictionary:aUserInfo];
            [[UPSession sharedUPSession] setCustomer:aCustomer];
            
            CATransition *aTransition = [CATransition animation];
            aTransition.delegate = self;
            aTransition.duration = 1.0;
            aTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [aTransition setType:kCATransitionFade];
            [[self.viewContainer layer] addAnimation:aTransition forKey:@"layerAnimation"];
            self.viewContainer.alpha = 0.0;
        }
        
        NSLog(@"iResponse : %@",iResponse);
        NSLog(@"iError : %@",iError);
    }];
}


- (void)animationDidStop:(CAAnimation *)iAnimation finished:(BOOL)iFlag {
    [self.viewContainer removeFromSuperview];
    UPMenuViewController *aMenuController = [[UPMenuViewController alloc] initWithNibName:nil bundle:nil];
    CATransition *aTransition = [CATransition animation];
    aTransition.duration = 1.0;
    [aTransition setType:kCATransitionReveal];
    [[aMenuController.view layer] addAnimation:aTransition forKey:@"layerAnimation"];
    [self.view addSubview:[aMenuController view]];
}



@end