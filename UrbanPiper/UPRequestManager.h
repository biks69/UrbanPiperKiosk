//
//  UPRequestManager.h
//  UrbanPiper
//
//  Created by Biks on 3/24/13.
//
//

#import <Foundation/Foundation.h>

typedef enum  {
    UPAuthenticationTypeBASIC = 0,
    UPAuthenticationTypeGET,
    UPAuthenticationTypePOST
} UPAuthenticationType;

typedef enum  {
    UPResponseStatusCodeInvaidCredentials = 401,
    UPResponseStatusCodeOK = 200,
    UPResponseStatusCodeFeedbackSuccess = 201
} UPResponseStatusCode;

typedef void (^UPRequestCompletionBlock)(NSDictionary *iResponse, NSError *iError);

@interface UPRequestManager : NSObject

- (void)sendRequestForURL:(NSURL *)iURL requestType:(NSString *)iType body:(NSDictionary *)iBody completionBlock:(UPRequestCompletionBlock)iBlock;
- (void)sendRequestForURL:(NSURL *)iURL authType:(UPAuthenticationType)iAuthType requestType:(NSString *)iType body:(NSDictionary *)iBody completionBlock:(UPRequestCompletionBlock)iBlock;

@end
