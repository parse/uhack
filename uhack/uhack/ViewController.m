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
#import  "QuartzCore/QuartzCore.h"
#import <RestKit/RestKit.h>

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableArray *autocomplete_array;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self initTapRecognizers];
    [self initSubmitButton];
    [self initTextFields];
    [self initTableView];
    
    //[self loadResults];

    autocomplete_array = [[NSMutableArray alloc] init];
}

- (void)initTableView
{
    self.searchResults.layer.borderWidth = 1.0;
    self.searchResults.layer.borderColor = [[UIColor colorWithWhite:.5 alpha:.5] CGColor];
}

- (void)initTextFields
{
    self.fromTextView.layer.borderWidth = 1.0;
    self.fromTextView.layer.borderColor = [[UIColor turquoiseColor] CGColor];
    self.toTextView.layer.borderWidth = 1.0;
    self.toTextView.layer.borderColor = [[UIColor turquoiseColor] CGColor];
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
    [self.searchResults reloadData];
}

- (void) initTapRecognizers
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.fromTextView) {
        [self.toTextView becomeFirstResponder];
    }
    else if (textField == self.toTextView)
    {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{  // animate the following:
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
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


- (void)loadResults
{
    NSString *url = @"/api/station";
    NSString *query = [[NSString alloc] initWithFormat:@"järla?%@", @"format=json"];
    url = [url stringByAppendingString:query];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:url
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                
                                NSArray* questions = [mappingResult array];
                               // _tableData = questions;
                                
                                //[indicator stopAnimating];
                                
                                //if(self.isViewLoaded) {
                                 //   [_tableView reloadData];
                                //}
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return autocomplete_array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultsIdentifier"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchResultsIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [autocomplete_array objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"Något annat";
    
    return cell;
}

@end
