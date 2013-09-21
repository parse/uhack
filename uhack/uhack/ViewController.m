//
//  ViewController.m
//  uhack
//
//  Created by Anders Hassis on 2013-09-21.
//  Copyright (c) 2013 Anders. All rights reserved.
//

#import "ViewController.h"

static NSString *const BaseURLString = @"http://valtechuh.apphb.com";


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) lol
{
    NSString *weatherUrl = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    NSURL *url = [NSURL URLWithString:weatherUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                        self.weather  = (NSDictionary *)JSON;
                                                        self.title = @"JSON Retrieved";
                                                        [self.tableView reloadData];
                                                    }
     // 4
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                                                                     message:[NSString stringWithFormat:@"%@",error]
                                                                                                    delegate:nil
                                                                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                        [av show];
                                                    }];
    
    // 5
    [operation start];
}
@end
