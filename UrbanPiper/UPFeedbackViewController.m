//
//  UPFeedbackViewController.m
//  UrbanPiper
//
//  Created by Biks on 3/28/13.
//
//

#import "UPFeedbackViewController.h"
#import "UPTextField.h"
#import "UPCustomer.h"
#import "UPTableViewCell.h"
#import "UPRequestManager.h"

static NSString *kToggleKey = @"Would you visit again?";

@interface UPFeedbackViewController ()

@property (nonatomic, strong) NSMutableDictionary *capturedFeedback;
@property (nonatomic, strong) NSString *selectedKey;
@property (nonatomic, strong) NSString *feedbackURL;
@property (nonatomic, strong) NSURL *requestURL;
@property (nonatomic, strong) NSArray *cellTitles;
@property (nonatomic, strong) NSArray *expOptions;
@property (nonatomic, strong) UPTableViewCell *selectedCell;
@property (nonatomic, strong) UPTextField *activeField;
@property (nonatomic, strong) UPRequestManager *requestManager;

- (void)enableFeedbackSubmission;

@end

@implementation UPFeedbackViewController

- (id)initWithStyle:(UITableViewStyle)iStyle {
    self = [super initWithStyle:iStyle];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.capturedFeedback = [NSMutableDictionary dictionary];
    self.requestManager = [[UPRequestManager alloc] init];
    
    self.cellTitles = [NSArray arrayWithObjects:@"Today's Experience", @"Food", @"Service", @"Cleanliness", @"Value for Money", @"Would you visit again?", @"Phone/Email", /*@"Feedback",*/ nil];
    self.expOptions = [NSArray arrayWithObjects:@"Very Poor", @"Needs Improvement", @"Satisfactory", @"Better than Average", @"Excellent",nil];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.tableView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRed:(15.0/255.0) green:(37.0/255.0) blue:(56.0/255.0) alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:(15.0/255.0) green:(37.0/255.0) blue:(56.0/255.0) alpha:1.0];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *aCancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelFeedback)];
    UIBarButtonItem *aSaveButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitFeedback)];
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.title = @"Feedback";
    self.navigationItem.leftBarButtonItem = aCancelButton;
    self.navigationItem.rightBarButtonItem = aSaveButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


- (void)enableFeedbackSubmission {
    if ([self.capturedFeedback.allKeys count] == self.cellTitles.count - 1) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}


- (void)submitFeedback {
    [self.activeField resignFirstResponder];
    
    __block UIView *aloadingOverlay = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2.0 - 50.0), (self.view.frame.size.height / 2.0 - 50.0), 100.0, 100.0)];
    aloadingOverlay.alpha = 0.8;
    aloadingOverlay.layer.cornerRadius = 10.0;
    aloadingOverlay.backgroundColor = [UIColor blackColor];
    UIActivityIndicatorView *aActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aActivityIndicatorView.frame = CGRectMake((aloadingOverlay.frame.size.width / 2.0 - 10.0), (aloadingOverlay.frame.size.height / 2.0 - 10.0), 20.0, 20.0);
    [aloadingOverlay addSubview:aActivityIndicatorView];
    [aActivityIndicatorView startAnimating];
    [self.view addSubview:aloadingOverlay];
    
    NSString *aURLString = @"https://api.urbanpiper.com/api/v1/feedback/?format=json&";
    UPCustomer *aCustomer = [[UPSession sharedUPSession] customer];
    NSString *aUsername = [[UPSession sharedUPSession] loggedInUserName];
    NSString *aSecureKey = [[UPSession sharedUPSession] sharedAuthKey];
    
    self.feedbackURL = [[NSString stringWithFormat:@"%@username=%@&api_key=%@",aURLString, aUsername, aSecureKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.requestURL = [[NSURL alloc] initWithString:self.feedbackURL];
    
    NSMutableDictionary *aBody = [NSMutableDictionary dictionary];
    [aBody setValue:self.capturedFeedback forKey:@"feedback_attributes"];
    [aBody setValue:aCustomer.bizID forKey:@"biz_id"];
    
    [self.requestManager sendRequestForURL:self.requestURL authType:UPAuthenticationTypePOST requestType:@"POST" body:aBody completionBlock:^(NSDictionary *iResponse, NSError *iError) {
        
        [aloadingOverlay removeFromSuperview];
        aloadingOverlay = nil;
        
        NSLog(@"iResponse : %@",iResponse);
        NSLog(@"iError : %@",iError);
        
        if (iResponse && [iResponse count] > 0) {
            
            UIAlertView *anErrorAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Feedback Submitted Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [anErrorAlert show];
            
        } else {
            UIAlertView *anErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not submit successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [anErrorAlert show];
        }
    }];
}


- (void)alertView:(UIAlertView *)iAlertView clickedButtonAtIndex:(NSInteger)iButtonIndex {
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.capturedFeedback = nil;
    self.activeField.text = nil;
}


- (void)cancelFeedback {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.cellTitles.count;
}


- (void)didSelectStartRating:(NSInteger)iRating elementKey:(NSString *)iKey {
    
    if (iKey) {
        [self.capturedFeedback setObject:[NSString stringWithFormat:@"%@ Star",[NSNumber numberWithInt:iRating]] forKey:iKey];
    }
    NSLog(@"self.capturedFeedback : %@",self.capturedFeedback);
    [self enableFeedbackSubmission];
}

- (UITableViewCell *)tableView:(UITableView *)iTableView cellForRowAtIndexPath:(NSIndexPath *)iIndexPath {
    static NSString *aCellIdentifier = @"Cell";
    UPTableViewCell *aCell = (UPTableViewCell *)[iTableView dequeueReusableCellWithIdentifier:aCellIdentifier];
    
    if (aCell == nil) {
        aCell = [[UPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aCellIdentifier];
        aCell.hasSeparator = YES;
        aCell.cellStyle = UPTableViewCellStyleFeedback;
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
        aCell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
        aCell.isEntryCell = NO;
    }
    
    if (iIndexPath.row == 0) {
        aCell.hasPlaceHolder = YES;
        aCell.cellSubTitle = @"Select Here";
    } else if (iIndexPath.row >= 1 && iIndexPath.row < 5) {
        UPRatingControl *aRating = (UPRatingControl *)[aCell.contentView viewWithTag:007];
        
        if (!aRating) {
            aRating = [[UPRatingControl alloc] initWithFrame:CGRectMake(280.0, 0.0, 200.0, aCell.frame.size.height)];
            aRating.delegate = self;
            [aRating setBackgroundColor:[UIColor clearColor]];
            [aRating setTag:007];
            [aCell.contentView addSubview:aRating];
        }
        aRating.rating = 0;
        aRating.selectedKey = [self.cellTitles objectAtIndex:iIndexPath.row];
    } else if (iIndexPath.row == 6) {
        aCell.isEntryCell = YES;
        aCell.delegate = self;
    } else if (iIndexPath.row == 5) {
        CGRect aSwitchFrame = CGRectMake(420.0, 8.0, 20.0, 20.0);
        UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:aSwitchFrame];
        [aSwitch setBackgroundColor:[UIColor clearColor]];
        [aSwitch setTag:420];
        [aSwitch addTarget:self action:@selector(toggleChoice:) forControlEvents:UIControlEventValueChanged];
        [aSwitch setOn:NO animated:YES];
        [aCell addSubview:aSwitch];
    }
    
    // Configure the cell...
    aCell.cellKey = [self.cellTitles objectAtIndex:iIndexPath.row];
    aCell.cellTitle = [self.cellTitles objectAtIndex:iIndexPath.row];
    NSLog(@"Cell Title : %@",aCell.cellTitle);
    
    return aCell;
}


- (void)toggleChoice:(id)iSender {
    UISwitch *aToggle = (UISwitch *)iSender;
    BOOL aValue = [aToggle isOn];
    [self.capturedFeedback setObject:[NSNumber numberWithBool:aValue] forKey:kToggleKey];
    [self enableFeedbackSubmission];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)iTableView didSelectRowAtIndexPath:(NSIndexPath *)iIndexPath {
    [iTableView deselectRowAtIndexPath:iIndexPath animated:YES];
    self.selectedCell = (UPTableViewCell *)[iTableView cellForRowAtIndexPath:iIndexPath];
    self.selectedKey = self.selectedCell.cellKey;
    
    if (iIndexPath.row == 0) {
        UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 180.0, self.view.frame.size.width, 200)];
        myPickerView.delegate = self;
        myPickerView.showsSelectionIndicator = YES;
        
        if (self.activeField) {
            [self.activeField resignFirstResponder];
        }
        
        [self.view addSubview:myPickerView];
    } else if (iIndexPath.row >= 1 && iIndexPath.row < 5) {
        UPRatingControl *aControl = (UPRatingControl *)[self.selectedCell.contentView viewWithTag:007];
        [self.capturedFeedback setObject:[NSNumber numberWithInt:aControl.rating] forKey:self.selectedKey];
        [self enableFeedbackSubmission];
    }
    
    NSLog(@"self.capturedFeedback : %@",self.capturedFeedback);
}


- (BOOL)textField:(UITextField *)iTextField shouldChangeCharactersInRange:(NSRange)iRange replacementString:(NSString *)iString {
    UPTextField *aField = (UPTextField *)iTextField;
    self.activeField = aField;
    NSString *aNewValue = [iTextField.text stringByReplacingCharactersInRange:iRange withString:iString];
    [self.capturedFeedback setObject:aNewValue forKey:aField.elementKey];
    [self enableFeedbackSubmission];
    NSLog(@"self.capturedFeedback : %@",self.capturedFeedback);

    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)iTextField {
    return YES;
}


- (void)pickerView:(UIPickerView *)iPickerView didSelectRow: (NSInteger)iRow inComponent:(NSInteger)iComponent {
    NSString *aSelectedValue = [self.expOptions objectAtIndex:iRow];
    [self.capturedFeedback setObject:aSelectedValue forKey:self.selectedKey];
    [self enableFeedbackSubmission];
    NSLog(@"self.capturedFeedback : %@",self.capturedFeedback);
    self.selectedCell.cellSubTitle = aSelectedValue;
    [self.selectedCell setNeedsLayout];
    // Handle the selection
    [iPickerView removeFromSuperview];
}


// Tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)iPickerView numberOfRowsInComponent:(NSInteger)iComponent {
    return self.expOptions.count;
}


// Tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)iPickerView {
    return 1;
}


// Tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)iPickerView titleForRow:(NSInteger)iRow forComponent:(NSInteger)iComponent {
    return [self.expOptions objectAtIndex:iRow];
}


// Tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)iPickerView widthForComponent:(NSInteger)iComponent {
    return self.view.frame.size.width;
}

@end
