//
//  UPCustomer.m
//  UrbanPiper
//
//  Created by Biks on 3/24/13.
//
//

#import "UPCustomer.h"

@implementation UPCustomer

- (id)initWithDictionary:(NSDictionary *)iDictionary {
    
    if (self = [super init]) {
        if (iDictionary && [iDictionary count] > 0) {
            
            if ([iDictionary valueForKey:@"backgroundImgURL"]) {
                self.bizImageURL = [iDictionary valueForKey:@"backgroundImgURL"];
            }
            
            if ([iDictionary valueForKey:@"biz_id"]) {
                self.bizID = [iDictionary valueForKey:@"biz_id"];
            }
            
            if ([iDictionary valueForKey:@"biz_name"]) {
                self.bizName = [iDictionary valueForKey:@"biz_name"];
            }
            
            if ([iDictionary valueForKey:@"logoImgURL"]) {
                self.bizLogoURL = [iDictionary valueForKey:@"logoImgURL"];
            }
        }
    }
    return self;
}

@end
