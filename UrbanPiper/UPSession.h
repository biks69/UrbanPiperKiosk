//
//  UPSession.h
//  UrbanPiper
//
//  Created by Biks on 3/24/13.
//
//

#import <Foundation/Foundation.h>
#import "UPCustomer.h"

@interface UPSession : NSObject

@property (nonatomic,strong) NSString *sharedAuthKey;
@property (nonatomic,strong) NSString *loggedInUserName;
@property (nonatomic,strong) UPCustomer *customer;

+ (UPSession *)sharedUPSession;
- (void)clearSession;

@end
