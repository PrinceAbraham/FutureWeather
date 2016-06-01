//
//  FirstViewController.m
//  FutureWeather
//
//  Created by Prince on 5/20/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import "FirstViewController.h"
#import "todayCollectionViewCell.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UICollectionView *dailyCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation FirstViewController

@synthesize firstSearchBar, highLabel, lowLabel, temperatureLabel, weatherImage, locationLabel, descriptionLabel, todayObjects, tabletodayObjects, mainBackgroundImage, dateLabel;

NSMutableString *firstSearchText;

NSArray *weatherDescriptions;

WeatherObject *currentTodayObjects;

NSDateFormatter *df;

NSMutableDictionary *stuffForDay;

AppDelegate *forDaily;

-(void)viewWillAppear:(BOOL)animated{
    forDaily = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(forDaily.isSearched){
        stuffForDay = forDaily.dailyCallback;
        todayObjects = [forDaily.dailyCallback objectForKey:@"list"];
        [self arrangeTableObjects];
        [self arrangeViewWithInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    firstSearchText = [[NSMutableString alloc] init];
    todayObjects = [[NSMutableArray alloc] init];
    tabletodayObjects = [[NSMutableArray alloc]init];
    currentTodayObjects = [[WeatherObject alloc] init];
    stuffForDay = [[NSMutableDictionary alloc]init];
    weatherDescriptions = @[@"Clear",@"Clouds",@"Rain",@"Snow"];
    df = [[NSDateFormatter alloc]init];
    [df setTimeStyle:NSDateFormatterShortStyle];
    //[df setTimeZone:[NSTimeZone ]];
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
    firstSearchBar.text = @"";
    [self.view endEditing:YES];
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
    
    forDaily.isSearched = YES;
    
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
         stuffForDay = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        forDaily.dailyCallback = stuffForDay;
        if(![[stuffForDay objectForKey:@"cod"]isEqualToString: @"404"]){
        todayObjects = [stuffForDay objectForKey:@"list"];
        NSLog(@"PRINT %lu",[todayObjects count]);
        
        [self arrangeTableObjects];
        
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^(void){
            [self arrangeViewWithInfo];
        });
        }else{
            //Show error Alert
        }
    }] resume];
    
    urlForThisCall = [[URL stringByAppendingString:WEEKLY]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:zipOrCity]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:firstSearchText]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:@"&mode=json"]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:APIURLWITHKEY]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:@"&cnt=10"]mutableCopy];
    url = [NSURL URLWithString:urlForThisCall];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //handle response
        if(![[stuffForDay objectForKey:@"cod"]isEqualToString: @"404"]){
            stuffForDay = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            forDaily.weeklyCallback = stuffForDay;
            forDaily.tenDayCallback = stuffForDay;
        }else{
            //Show error Alert
        }
    }] resume];
    
    return nil;
}

#pragma marks - Collection View Delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    todayCollectionViewCell *cell = (todayCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if([todayObjects count]>0){
        double d = [[[todayObjects objectAtIndex:indexPath.row] objectForKey:@"dt"] doubleValue];
        NSTimeInterval tInterval= (NSTimeInterval)d;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:tInterval];
        cell.timeLabel.text = [df stringFromDate:date];
        cell.cellImage.image = [UIImage imageNamed:[ NSString stringWithFormat:@"%@",[[[[todayObjects objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"]]];
        cell.temperatureLabel.text = [NSString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[todayObjects objectAtIndex:indexPath.row]
                                                                                                           objectForKey:@"main"] objectForKey:@"temp"] floatValue]], @"\u00B0"];
        //dateLabel.text = [df stringFromDate:date];
       
        
    }
    return cell;
}

#pragma marks - Custom Functions
-(float) convertToFahranheit:(float)kelvin{
    float k= (round(kelvin * 9.0/5) - 459.67)-10;
    int f = (int)k;
    return f;
}
-(void)arrangeTableObjects{
    for(int i=0; i<5; i++){
        float temp=0,high=0,low=0;
        temp = [[[[todayObjects objectAtIndex:i] objectForKey:@"main"] objectForKey:@"temp"] floatValue];
        high= [[[[todayObjects objectAtIndex:i] objectForKey:@"main"] objectForKey:@"temp_max"] floatValue];
        low = [[[[todayObjects objectAtIndex:i] objectForKey:@"main"] objectForKey:@"temp_low"] floatValue];
        [currentTodayObjects setWeatherDescription:(NSMutableString *)[[[[ todayObjects objectAtIndex:i] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"]];
        [currentTodayObjects setCurrentTime:(NSDate *)[[todayObjects objectAtIndex:i] objectForKey:@"dt"]];
        [currentTodayObjects setTemperature: [NSMutableString stringWithFormat:@"%d",(int)[self convertToFahranheit:temp]]];
        [currentTodayObjects setWindSpeed:(NSMutableString *)[[[todayObjects objectAtIndex:i] objectForKey:@"wind"] objectForKey:@"speed"]];
        [currentTodayObjects setBackgroundImage:[UIImage imageNamed:currentTodayObjects.description]];
        [currentTodayObjects setHigh:[NSMutableString stringWithFormat:@"%d",(int)[self convertToFahranheit:high]]];
        [currentTodayObjects setLow:[NSMutableString stringWithFormat:@"%d",(int)[self convertToFahranheit:low]]];
        [tabletodayObjects addObject:currentTodayObjects];
        
        //empty currentTodayObjects
        
    }
}
-(void)arrangeViewWithInfo{
    highLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[todayObjects objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp_max"] floatValue]], @"\u00B0"];
    lowLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[todayObjects objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp_min"] floatValue]], @"\u00B0"];
    temperatureLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[todayObjects objectAtIndex:0] objectForKey:@"main"] objectForKey:@"temp"] floatValue]], @"\u00B0"];
    weatherImage.image = [UIImage imageNamed:(NSMutableString *)[[[[ todayObjects objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"]];
    locationLabel.text = [NSMutableString stringWithFormat:@"%@",[[stuffForDay objectForKey:@"city"] objectForKey:@"name"]];
    descriptionLabel.text = (NSMutableString *)[[[[ todayObjects objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"];
    double d = [[[todayObjects objectAtIndex:0] objectForKey:@"dt"] doubleValue];
    NSTimeInterval tInterval= (NSTimeInterval)d;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tInterval];
    dateLabel.text = [df stringFromDate:date];
    if([(NSMutableString *)[[[[ todayObjects objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Rain"]){
        mainBackgroundImage.image = [UIImage imageNamed:@"RainBackground"];
    }else if([(NSMutableString *)[[[[ todayObjects objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Clouds"]){
        mainBackgroundImage.image = [UIImage imageNamed:@"CloudBackground"];
    }else if([(NSMutableString *)[[[[ todayObjects objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Snow"]){
        // self.view.backgroundColor = snow;
    }else{
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
        NSMutableString *dayOrNightString = [timeFormatter stringFromDate:date];
        if([dayOrNightString floatValue] >= 18.00 || [dayOrNightString floatValue] <=6.00){
            mainBackgroundImage.image = [UIImage imageNamed:@"NightBackground"];
        }else{
            mainBackgroundImage.image = [UIImage imageNamed:@"SunBackground"];
        }
    }
    [self.dailyCollectionView reloadData];
}
@end
