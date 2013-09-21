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

@implementation ViewController {
    NSMutableArray *autocomplete_array;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self initSubmitButton];
    
    autocomplete_array = [[NSMutableArray alloc] init];
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
    NSArray *dataSource = [NSArray arrayWithObjects:@"anders", @"uppsal", @"hackathon", @"daniel", @"sandra",nil];
    
    // Empty result data view
    [autocomplete_array removeAllObjects];
    
    for(int i = 0; i < [dataSource count]; i++) {
        NSString *curString = [dataSource objectAtIndex:i];
        
        curString = [curString lowercaseString];
        substring = [substring lowercaseString];
        
        if ([curString rangeOfString:substring].location != NSNotFound) {
            [autocomplete_array addObject:curString];
        }
    }
    
    NSLog(@"Autocomplete: %@", autocomplete_array);
    
    // Reload result data view
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    
    return YES;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Hej hej");
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.fromTextView isFirstResponder] && [touch view] != self.fromTextView) {
        [self.fromTextView resignFirstResponder];
    } else if ([self.toTextView isFirstResponder] && [touch view] != self.toTextView) {
        [self.toTextView resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
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
