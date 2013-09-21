//
//  AppDelegate.h
//  uhack
//
//  Created by Anders Hassis on 2013-09-21.
//  Copyright (c) 2013 Anders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#define myAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define API_VERSION "1.0"

@end
