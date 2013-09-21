//
//  AppDelegate.m
//  uhack
//
//  Created by Anders Hassis on 2013-09-21.
//  Copyright (c) 2013 Anders. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "AFNetworking.h"
#import "Travel.h"
#import "Location.h"
#import "GAI.h"

static NSString *const BaseURLString = @"http://valtechuh.apphb.com";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 0;

    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-44229115-1"];

    // Override point for customization after application launch.
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Travel
    RKObjectMapping *travelMapping = [RKObjectMapping mappingForClass:[Travel class]];
    [travelMapping addAttributeMappingsFromDictionary:@{
                                                          @"zones" : @"zones",
                                                          @"price" : @"price"
                                                          }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:travelMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:@"items"
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    // Locations
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping addAttributeMappingsFromDictionary:@{
                                                        @"id" : @"id",
                                                        @"name" : @"name"
                                                        }];
    responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:locationMapping
                                                                                       pathPattern:nil
                                                                                           keyPath:@"results"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
