//
//  UPAppDelegate.m
//  UrbanPiper
//
//  Created by Biks on 3/9/13.
//
//

#import "UPAppDelegate.h"

#import "UPAdminLoginViewController.h"

@implementation UPAppDelegate

- (BOOL)application:(UIApplication *)iApplication didFinishLaunchingWithOptions:(NSDictionary *)iLaunchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[UPAdminLoginViewController alloc] initWithNibName:@"UPAdminLoginViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)iApplication {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)iApplication {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)iApplication {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)iApplication {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)iApplication {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)iInterfaceOrientation {
    return iInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end