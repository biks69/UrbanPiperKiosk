//
//  UPSession.h
//  UrbanPiper
//
//  Created by Biks on 3/24/13.
//
//

#import <Foundation/Foundation.h>

@interface UPSession : NSObject

@property (nonatomic,strong) NSString *sharedAuthKey;
@property (nonatomic,strong) NSString *loggedInUserName;

+ (UPSession *)sharedUPSession;

@end
