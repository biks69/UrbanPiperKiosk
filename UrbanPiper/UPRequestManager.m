//
//  UPRequestManager.m
//  UrbanPiper
//
//  Created by Biks on 3/24/13.
//
//

#import "UPRequestManager.h"
#import "NSData+Additions.h"

@interface UPRequestManager ()

@property (nonatomic, strong) NSURL *requestURL;
@property (nonatomic, strong) NSString *requestType;
@property (nonatomic, strong) NSDictionary *body;
@property (nonatomic, copy)   UPRequestCompletionBlock completionBlock;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSMutableURLRequest *URLRequest;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, assign) UPAuthenticationType authType;
@property (nonatomic, assign) NSUInteger statusCode;

- (void)setRequestParametersForAuthType:(UPAuthenticationType)iType;

@end

@implementation UPRequestManager

- (void)sendRequestForURL:(NSURL *)iURL authType:(UPAuthenticationType)iAuthType requestType:(NSString *)iType body:(NSDictionary *)iBody completionBlock:(UPRequestCompletionBlock)iBlock {
    self.authType = iAuthType;
    self.requestURL = iURL;
    [self sendRequestForURL:self.requestURL requestType:iType body:iBody completionBlock:iBlock];
}


- (void)sendRequestForURL:(NSURL *)iURL requestType:(NSString *)iType body:(NSDictionary *)iBody completionBlock:(UPRequestCompletionBlock)iBlock {
    if (iURL) {
        self.mutableData = [NSMutableData data];
        self.requestURL = iURL;
        self.requestType = iType;
        self.completionBlock = iBlock;
        self.body = iBody;
        
        // Create connection
        self.URLRequest = [NSMutableURLRequest requestWithURL:self.requestURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:999];
		[self.URLRequest setHTTPMethod:self.requestType];
        
        [self setRequestParametersForAuthType:self.authType];

        self.connection = [NSURLConnection connectionWithRequest:self.URLRequest delegate:self];
    }
}


- (void)setRequestParametersForAuthType:(UPAuthenticationType)iType {
    if (iType == UPAuthenticationTypePOST) {
        
        NSError *error;
        NSString *jsonString = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.body
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        
        if (!jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
//        NSData *aBody = [NSKeyedArchiver archivedDataWithRootObject:jsonString];
        NSData *aBody = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        if ([aBody bytes]) {
            [self.URLRequest setHTTPBody:aBody];
        }
        
        
        // (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
        [self.URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    } else if (iType == UPAuthenticationTypeBASIC) {        // TODO: Not a generic way, will be changed later
        NSString *aUsername = [self.body valueForKey:@"username"];
        NSString *aPwd = [self.body valueForKey:@"password"];
        NSString *anAuthString = [NSString stringWithFormat:@"%@:%@",aUsername,aPwd];
        NSData *anAuthData = [anAuthString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *anEncodedAuthValue = [NSString stringWithFormat:@"Basic %@",[anAuthData base64Encoding]];
        
        if (anEncodedAuthValue && [anEncodedAuthValue length] > 0) {
            [self.URLRequest setValue:anEncodedAuthValue forHTTPHeaderField:@"Authorization"];
        }
    } else if (iType == UPAuthenticationTypeGET) {
        
    }
}

#pragma mark -
#pragma mark Connection Delegates 

- (void)connection:(NSURLConnection *)iConnection didFailWithError:(NSError *)iError {
    
}


- (void)connection:(NSURLConnection *)iConnection didReceiveResponse:(NSURLResponse *)iResponse {
    self.statusCode = [(NSHTTPURLResponse*)iResponse statusCode];
    
    if (self.statusCode == UPResponseStatusCodeInvaidCredentials) {
        NSError *anAuthError = [NSError errorWithDomain:@"Invalid User Credentials" code:self.statusCode userInfo:nil];
        self.completionBlock(nil, anAuthError);
    } else if (self.statusCode == UPResponseStatusCodeFeedbackSuccess) {
        NSDictionary *aResponse = [NSDictionary dictionaryWithObjectsAndKeys:@"Feedback submitted successfully",@"response", nil];
        self.completionBlock(aResponse,nil);
    }
}


- (void)connection:(NSURLConnection *)iConnection didReceiveData:(NSData *)iData {
    [self.mutableData appendData:iData];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)iConnection {
    NSError *anError = nil;
    NSDictionary *aResponse = [NSJSONSerialization JSONObjectWithData:self.mutableData options:NSJSONReadingMutableLeaves error:&anError];

    if (self.statusCode == UPResponseStatusCodeOK) {
        if (aResponse && self.completionBlock) {
            self.completionBlock(aResponse,nil);
        }
    }
}



@end
