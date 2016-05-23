//
//  FirstViewController.m
//  FutureWeather
//
//  Created by Prince on 5/20/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize firstSearchBar;

NSMutableString *firstSearchText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    firstSearchText = [[NSMutableString alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //if search field is not empty
    if(![firstSearchBar.text isEqualToString:@""]){
    firstSearchText = [[firstSearchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]mutableCopy];
    }
    [self getDailyWeather];
}

-(NSString *)getDailyWeather{
    NSMutableString *urlForThisCall = [[APIURLWITHKEY stringByAppendingString:@"hourly/q/"]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:firstSearchText]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:@".json"]mutableCopy];
    NSURL *url = [NSURL URLWithString:urlForThisCall];
    //NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    //create a session
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //handle response
        
        NSLog(@"PRINT %@",response);
        
    }] resume];
    return nil;
}

@end
