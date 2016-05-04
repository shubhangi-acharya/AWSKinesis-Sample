/*
 * Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */


#import "DeveloperAuthenticatedIdentityProvider.h"
#import "AppDelegate.h"
#import "AWSCore/AWSCore.h"


@interface DeveloperAuthenticatedIdentityProvider()

@property (strong, atomic) NSString *providerName;
@property (strong, atomic) NSString *token;
@property (strong, atomic) AppDelegate *appDelegate;
@end

@implementation DeveloperAuthenticatedIdentityProvider
static  NSString* developerProvider = @"com.test.sample";

@synthesize providerName=_providerName;
@synthesize token=_token;

//- (instancetype)initWithRegionType:(AWSRegionType)regionType
//                        identityId:(NSString *)identityId
//                    identityPoolId:(NSString *)identityPoolId
//                            logins:(NSDictionary *)logins
//                      providerName:(NSString *)providerName {
//    if (self = [super initWithRegionType:regionType identityId:identityId accountId:nil identityPoolId:identityPoolId logins:logins]) {
//
//        self.providerName = providerName;
//        //        self.token = [logins valueForKey:@"cognitoToken"];
//    }
//    return self;
//}

- (instancetype)initWithRegionType:(AWSRegionType)regionType
                        identityId:(NSString *)identityId
                    identityPoolId:(NSString *)identityPoolId
                            logins:(NSDictionary *)logins
                      providerName:(NSString *)providerName
{
    if (self = [super initWithRegionType:regionType identityId:identityId accountId:nil identityPoolId:identityPoolId logins:logins]) {
        self.providerName = providerName;
        // Initialize any other objects needed here
    }
    return self;
}



- (AWSTask *)refresh {
    
    // Set the identity id and token
    self.identityId = @"your_cognito_id";
    self.token = @"your_token";
    return [AWSTask taskWithResult:self.identityId];
}

- (AWSTask *)getIdentityId {
    if (self.identityId) {
        return [AWSTask taskWithResult:self.identityId];
    }
    self.identityId = @"your_cognito_id";
    self.token = @"your_token";
    return [AWSTask taskWithResult:self.identityId];
}
@end
