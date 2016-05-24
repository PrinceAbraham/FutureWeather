//
//  FirstViewController.m
//  FutureWeather
//
//  Created by Prince on 5/20/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

@end

@implementation FirstViewController

@synthesize firstSearchBar, highLabel, lowLabel, temperatureLabel, weatherImage;

NSMutableString *firstSearchText;

NSMutableArray *dailyObjects;

DailyObject *currentDailyObject;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    firstSearchText = [[NSMutableString alloc] init];
    dailyObjects = [[NSMutableArray alloc] init];
    currentDailyObject = [[DailyObject alloc] init];
    
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
    NSMutableCharacterSet *numSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    NSMutableString *zipOrCity = [[NSMutableString alloc]init];
    BOOL zip = [[firstSearchText stringByTrimmingCharactersInSet:numSet] isEqualToString:@""];
    
    if(zip){
        zipOrCity = @"zip=";
    }else{
        zipOrCity =@"q=";
    }
    
    //if(firstSearchText)
    NSMutableString *urlForThisCall = [[URL stringByAppendingString:DAILY]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:zipOrCity]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:firstSearchText]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:APIURLWITHKEY]mutableCopy];
    NSURL *url = [NSURL URLWithString:urlForThisCall];
    //NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    //create a session
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //handle response
        
        NSDictionary *stuff = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dailyObjects = [stuff objectForKey:@"list"];
        NSLog(@"PRINT %lu",[dailyObjects count]);
        
        for(int i=0; i<3; i++){
            [currentDailyObject setWeatherDescription:[[[[ dailyObjects objectAtIndex:i] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"]];
            [currentDailyObject setCurrentTime:[[dailyObjects objectAtIndex:i] objectForKey:@"dt"]];
            [currentDailyObject setTemperature:[[[dailyObjects objectAtIndex:i] objectForKey:@"main"] objectForKey:@"temp"]];
            [currentDailyObject setCloudiness:[[[dailyObjects objectAtIndex:i] objectForKey:@"clouds"] objectForKey:@"all"]];
            [currentDailyObject setWindSpeed:[[[dailyObjects objectAtIndex:i] objectForKey:@"wind"] objectForKey:@"speed"]];
            [currentDailyObject setBackgroundImage:[UIImage imageNamed:@""]];
            [currentDailyObject setHigh:[[[dailyObjects objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp_max"]];
            [currentDailyObject setLow:[[[dailyObjects objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp_min"]];
            [dailyObjects addObject:currentDailyObject];
        }
        
        highLabel.text = [[[dailyObjects objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp_max"];
        lowLabel.text = [[[dailyObjects objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp_min"];
        temperatureLabel.text = [[[dailyObjects objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp"];
        
    }] resume];
    
    return nil;
}

@end
