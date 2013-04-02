//
//  UPSession.m
//  UrbanPiper
//
//  Created by Biks on 3/24/13.
//
//

#import "UPSession.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

@implementation UPSession

+ (UPSession *)sharedUPSession {
	DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
		return [[self alloc] init];
	});
}


- (void)clearSession {
    self.loggedInUserName = nil;
    self.customer = nil;
    self.sharedAuthKey = nil;
}

@end
