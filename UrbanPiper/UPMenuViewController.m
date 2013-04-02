//
//  UPMenuViewController.m
//  UrbanPiper
//
//  Created by Biks on 3/24/13.
//
//

#import "UPMenuViewController.h"
#import "UPFeedbackViewController.h"
#import "UPCustomer.h"

@interface UPMenuViewController ()

@property (nonatomic, strong) UPMenuSelectionView *selectionView;
@property (nonatomic, strong) UISwipeGestureRecognizer *logoutDownSwipe;
@property (nonatomic, strong) UIAlertView *logoutUser;
@property (nonatomic, strong) UPFeedbackViewController *feedBackController;

- (void)logoutGestureAction;

@end

@implementation UPMenuViewController

- (id)initWithNibName:(NSString *)iNibNameOrNil bundle:(NSBundle *)iNibBundleOrNil {
    self = [super initWithNibName:iNibNameOrNil bundle:iNibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGround.png"]];
    
    // Draw the customer name in the center as an Emboss
    UPCustomer *aCustomer = [[UPSession sharedUPSession] customer];
    self.bizName = aCustomer.bizName;
    
    NSString *aTitle = [NSString stringWithFormat:@"Welcome to %@",self.bizName];
    CGSize aFontSize = [aTitle sizeWithFont:[UIFont fontWithName:@"Helvetica" size:44.0]];
    CGFloat aViewWidth = self.view.bounds.size.width;
    CGFloat aViewHeight = self.view.bounds.size.height;
    
    UILabel *aMessageLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(((aViewHeight / 2.0) - (aFontSize.width / 2.0)), ((aViewWidth / 2) - (aFontSize.height / 2.0)), aFontSize.width, aFontSize.height))];
	aMessageLabel.text = aTitle;
	aMessageLabel.backgroundColor = [UIColor clearColor];
	aMessageLabel.font = [UIFont fontWithName:@"Helvetica" size:44.0];
	aMessageLabel.textColor = [UIColor colorWithRed:(32.0/255.0) green:(61.0/255) blue:(105.0/255.0) alpha:1.0];
	aMessageLabel.textAlignment = NSTextAlignmentCenter;
	aMessageLabel.shadowColor = [UIColor colorWithRed:(29.0/255.0) green:(129.0/255) blue:(163.0/255.0) alpha:1.0];
	aMessageLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    [self.view addSubview:aMessageLabel];
    
    // Add the Top Menu View
    CGFloat aStartX = 150.0;
    CGFloat aHeight = 80.0;
    CGRect aMenuFrame = CGRectIntegral(CGRectMake(aStartX, 0.0, aViewHeight - aStartX, aHeight));
    self.selectionView = [[UPMenuSelectionView alloc] initWithFrame:aMenuFrame];
    self.selectionView.delegate = self;
    [self.view addSubview:self.selectionView];
    
    self.logoutDownSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(logoutGestureAction)];
    self.logoutDownSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    self.logoutDownSwipe.numberOfTouchesRequired = 2;
    self.logoutDownSwipe.delegate = self;
    [self.view addGestureRecognizer:self.logoutDownSwipe];
}


//- (void)viewDidAppear:(BOOL)iAnimated {
//    [self logoutGestureAction];
//    
//}


- (void)logoutGestureAction {
    NSLog(@"Logout User");
    self.logoutUser = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to Logout ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    self.logoutUser.tag = 777;
    [self.logoutUser show];
}


- (void)didSelectionMenuOptionWithTag:(NSInteger)iTag {
    
    if (iTag == 10) {
        // Launch FeedBack Form Here
        NSLog(@"Launch FeedBack Form Here");
        self.feedBackController = [[UPFeedbackViewController alloc] initWithStyle:UITableViewStyleGrouped];
        self.feedBackController.modalPresentationStyle = UIModalPresentationFormSheet;
        UINavigationController *aPresentingContoller = [[UINavigationController alloc] initWithRootViewController:self.feedBackController];
        aPresentingContoller.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:aPresentingContoller animated:YES completion:nil];
    }
}


- (void)alertView:(UIAlertView *)iAlertView clickedButtonAtIndex:(NSInteger)iButtonIndex {
    switch (iButtonIndex) {
        case 0:
            [[UPSession sharedUPSession] clearSession];
            break;
            
        default:
            break;
    }
}


- (BOOL)shouldAutorotate {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end