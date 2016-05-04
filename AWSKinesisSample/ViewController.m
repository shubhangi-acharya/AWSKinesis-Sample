//
//  ViewController.m
//  AWSKinesisSample
//
//  Created by Shubhangi Pandya on 04/05/16.
//  Copyright © 2016 Shubhangi Pandya. All rights reserved.
//

#import "ViewController.h"
#import <AWSCore/AWSCore.h>
#import <AWSKinesis/AWSKinesis.h>
#import "DeveloperAuthenticatedIdentityProvider.h"


@interface ViewController ()

@property (strong, nonatomic) NSString *cognitoId;
@property (strong, nonatomic) NSString *cognitoIdentityPoolId;
@property (nonatomic, strong) AWSServiceConfiguration *configObject;
@property (nonatomic, strong) AWSCognitoCredentialsProvider *credentialsProvider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cognitoIdentityPoolId = @"your_cognito_pool_id";
    self.cognitoId = @"your_cognito_id";
    [self developerAuthentication];
    
}

- (void)developerAuthentication {
    id<AWSCognitoIdentityProvider> identityProvider =
    [[DeveloperAuthenticatedIdentityProvider alloc]initWithRegionType:AWSRegionUSEast1 identityId:self.cognitoId accountId:@"your_account" identityPoolId:self.cognitoIdentityPoolId logins:nil];

    self.credentialsProvider =
    [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1 identityProvider:identityProvider unauthRoleArn:nil authRoleArn:nil];

    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:self.credentialsProvider];
    self.configObject = configuration;
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
}



- (IBAction)buttonTapped:(UIButton *)sender {

    NSString *dataValue = [self getdata];
    
    AWSKinesisRecorder *kinesisRecorder = [AWSKinesisRecorder defaultKinesisRecorder];
    [AWSKinesisRecorder registerKinesisRecorderWithConfiguration:self.configObject forKey:@"configuration"];
    NSData *data = [dataValue dataUsingEncoding:NSUTF8StringEncoding];
    [AWSKinesisRecorder registerKinesisRecorderWithConfiguration:self.configObject forKey:@"KinesisConfiguration"];
    kinesisRecorder.diskAgeLimit = 30 * 24 * 60 * 60; // 30 days
    kinesisRecorder.diskByteLimit = 10 * 1024 * 1024; // 10MB
    kinesisRecorder.notificationByteThreshold = 5 * 1024 * 1024; // 5MB
    [[[kinesisRecorder saveRecord:data
                       streamName:@"your_stream_name"] continueWithSuccessBlock:^id(AWSTask *task) {
        return [kinesisRecorder submitAllRecords];
    }] continueWithBlock:^id(AWSTask *task) {
        if (task.result) {
            NSLog(@"%@", task.result);
        }
        
        if (task.completed) {
            NSLog(@"Completed");
        }
        return nil;
    }];
    
}

- (NSString *) getdata {
    
    NSString* str = @"{\"timestamp\" : \"2014-02-14 12:00:00.000Z\",\"testId\" : \"78hiyihkj98yeiwh98\",\"accessToken\" : \"0f234690-7f36-4314-ae44-20e1110bbba5\",\"userId\" : \"test\",\"schemaUri\" : \"test.json\"}";
    return str;
}

- (NSString *) getCurrentTimeStamp {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z"];
    return [dateFormatter stringFromDate:[NSDate date]];
    
}

@end

