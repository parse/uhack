//
//  ViewController.m
//  uhack
//
//  Created by Anders Hassis on 2013-09-21.
//  Copyright (c) 2013 Anders. All rights reserved.
//

#import "ViewController.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import "AppDelegate.h"
#import "UIColor+FlatUI.h"
#import "FUIButton.h"
#import "UIFont+FlatUI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initSubmitButton];
}

- (void)initSubmitButton
{
    self.submitButton.buttonColor = [UIColor turquoiseColor];
    self.submitButton.shadowColor = [UIColor greenSeaColor];
    self.submitButton.shadowHeight = 3.0f;
    self.submitButton.cornerRadius = 0.0f;
    [self.submitButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

/*

- (void)loadResults
{
    NSDictionary *params = @{@"version" : @API_VERSION,
                             @"action" : @"getcategory",
                             @"id": [NSNumber numberWithInteger:_query]};
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:@"/api/locations"
                         parameters:params
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
 
                                NSArray* questions = [mappingResult array];
                                _tableData = questions;
                                
                                [indicator stopAnimating];
                                
                                if(self.isViewLoaded) {
                                    [_tableView reloadData];
                                }
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"Hit error: %@", error);
                            }];
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
