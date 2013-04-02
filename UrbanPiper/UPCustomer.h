//
//  UPCustomer.h
//  UrbanPiper
//
//  Created by Biks on 3/24/13.
//
//

#import <Foundation/Foundation.h>

@interface UPCustomer : NSObject

@property (nonatomic, strong) NSString *bizName;
@property (nonatomic, strong) NSString *bizID;
@property (nonatomic, strong) NSString *bizImageURL;
@property (nonatomic, strong) NSString *bizLogoURL;

- (id)initWithDictionary:(NSDictionary *)iDictionary;

@end
