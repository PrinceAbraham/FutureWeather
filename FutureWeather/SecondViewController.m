//
//  SecondViewController.m
//  FutureWeather
//
//  Created by Prince on 5/20/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import "SecondViewController.h"
#import "ConstantsClass.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *weeklySearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *weeklyCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainBackgroundImage;

@end

@implementation SecondViewController
@synthesize weeklySearchBar, temperatureLabel, descriptionLabel, locationLabel, weeklyCollectionView, highLabel, lowLabel, weatherImage, dateLabel, mainBackgroundImage;

NSMutableString *searchText;
NSMutableArray *weeklyObjects, *tableWeeklyObjects;
WeatherObject *currentWeekObject;
NSDateFormatter *dFormatter;
NSDictionary *stuff;
AppDelegate *forWeekly;

-(void)viewWillAppear:(BOOL)animated{
    forWeekly = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(forWeekly.isSearched){
        stuff = forWeekly.weeklyCallback;
        weeklyObjects = [forWeekly.weeklyCallback objectForKey:@"list"];
        [self arrangeForView];
    }else{
           
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dFormatter = [[NSDateFormatter alloc]init];
    [dFormatter setDateStyle:NSDateFormatterMediumStyle];
    searchText = [[NSMutableString alloc] init];
    weeklyObjects = [[NSMutableArray alloc] init];
    stuff = [[NSDictionary alloc] init];
    tableWeeklyObjects = [[NSMutableArray alloc] init];
    currentWeekObject = [[WeatherObject alloc] init];
    weeklySearchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Search Delegates
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //if search field is not empty
    if(![weeklySearchBar.text isEqualToString:@""]){
        searchText = [[weeklySearchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]mutableCopy];
    }
    searchBar.text = @"";
    [self.view endEditing:YES];
    [self getWeeklyWeather:searchText];
}
#pragma mark - CollectionView Delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeeklyCollectionViewCell *cell = (WeeklyCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"weekly" forIndexPath:indexPath];
    if([weeklyObjects count]>0){
        double d = [[[weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"dt"] doubleValue];
        NSTimeInterval tInterval= (NSTimeInterval)d;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:tInterval];
        cell.DayLabel.text = [dFormatter stringFromDate:date];
        cell.temperatureLabel.text = [NSString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"day"] floatValue]], @"\u00B0"];
        if([(NSMutableString *)[[[[ weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Rain"]){
            
            cell.backgroundImage.image = [UIImage imageNamed:@"Rain"];
            
        }else if([(NSMutableString *)[[[[ weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Clouds"]){
            cell.backgroundImage.image = [UIImage imageNamed:@"Clouds"];
        }else if([(NSMutableString *)[[[[ weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Snow"]){
            // self.view.backgroundColor = snow;
        }else{
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"HH:mm"];
            NSMutableString *dayOrNightString = [timeFormatter stringFromDate:date];
            if([dayOrNightString floatValue] >= 18.00 || [dayOrNightString floatValue] <=6.00){
                cell.backgroundImage.image = [UIImage imageNamed:@"moon"];
            }else{
                cell.backgroundImage.image = [UIImage imageNamed:@"Clear"];
            }
        }
        
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(forWeekly.isSearched){
    highLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"max"] floatValue]], @"\u00B0"];
    lowLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"min"] floatValue]], @"\u00B0"];
    temperatureLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"day"] floatValue]], @"\u00B0"];
    descriptionLabel.text = (NSMutableString *)[[[[ weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"];
    double d = [[[weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"dt"] doubleValue];
    NSTimeInterval tInterval= (NSTimeInterval)d;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tInterval];
    dateLabel.text = [dFormatter stringFromDate:date];
    if([(NSMutableString *)[[[[ weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Rain"]){
        mainBackgroundImage.image = [UIImage imageNamed:@"RainBackground"];
        weatherImage.image = [UIImage imageNamed:@"Rain"];
    }else if([(NSMutableString *)[[[[ weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Clouds"]){
        mainBackgroundImage.image = [UIImage imageNamed:@"CloudBackground"];
        weatherImage.image = [UIImage imageNamed:@"Clouds"];
    }else if([(NSMutableString *)[[[[ weeklyObjects objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Snow"]){
        // self.view.backgroundColor = snow;
    }else{
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
        NSMutableString *dayOrNightString = [timeFormatter stringFromDate:date];
        if([dayOrNightString floatValue] >= 18.00 || [dayOrNightString floatValue] <=6.00){
            mainBackgroundImage.image = [UIImage imageNamed:@"NightBackground"];
            weatherImage.image = [UIImage imageNamed:@"moon"];
        }else{
            if([temperatureLabel.text integerValue] > 0){
                mainBackgroundImage.image = [UIImage imageNamed:@"SunBackground"];
            }else{
                mainBackgroundImage.image = [UIImage imageNamed:@"Snow"];
            }
            weatherImage.image = [UIImage imageNamed:@"Clear"];
        }
    }
    }
}
#pragma mark - Custom Functions
-(void)getWeeklyWeather:(NSMutableString *) text{
    NSMutableCharacterSet *numSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    NSMutableString *zipOrCity = [[NSMutableString alloc]init];
    BOOL zip = [[searchText stringByTrimmingCharactersInSet:numSet] isEqualToString:@""];
    
    if(zip){
        zipOrCity = @"zip=";
    }else{
        zipOrCity =@"q=";
    }

    //if(firstSearchText)
    NSMutableString *urlForThisCall = [[URL stringByAppendingString:WEEKLY]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:zipOrCity]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:text]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:@"&mode=json"]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:APIURLWITHKEY]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:@"&cnt=10"]mutableCopy];
    NSURL *url = [NSURL URLWithString:urlForThisCall];
    //NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    //create a session
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //handle response
        if(data != nil){
        stuff = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        forWeekly.weeklyCallback = [stuff mutableCopy];
        forWeekly.tenDayCallback = [stuff mutableCopy];
        weeklyObjects = [stuff objectForKey:@"list"];
        NSLog(@"PRINT %lu",[weeklyObjects count]);
        [self arrangeForTable];
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^(void){
        [self arrangeForView];
        });
        }
    }] resume];
    
    urlForThisCall = [[URL stringByAppendingString:DAILY]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:zipOrCity]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:text]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:APIURLWITHKEY]mutableCopy];
    url = [NSURL URLWithString:urlForThisCall];
    //create a session
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //handle response
        if(data != nil){
        stuff = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(![[stuff objectForKey:@"cod"]isEqualToString: @"404"]){
            forWeekly.isSearched = YES;
            forWeekly.dailyCallback = [stuff mutableCopy];
        }else{
            [self presentViewController:forWeekly.unavailableSearch animated:YES completion:nil];
        }
        }else{
            [self presentViewController:forWeekly.checkInternet animated:YES completion:nil];
        }
    }] resume];
    
}

-(float) convertToFahranheit:(float)kelvin{
    float k= (round(kelvin * 9.0/5) - 459.67)-10;
    int f = (int)k;
    return f;
}
-(void)arrangeForTable{
    for(int i=0; i<8; i++){
        float temp=0,high=0,low=0;
        temp = [[[[weeklyObjects objectAtIndex:i] objectForKey:@"temp"] objectForKey:@"day"] floatValue];
        high= [[[[weeklyObjects objectAtIndex:i] objectForKey:@"temp"] objectForKey:@"max"] floatValue];
        low = [[[[weeklyObjects objectAtIndex:i] objectForKey:@"temp"] objectForKey:@"min"] floatValue];
        [currentWeekObject setWeatherDescription:(NSMutableString *)[[[[ weeklyObjects objectAtIndex:i] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"]];
        [currentWeekObject setCurrentTime:(NSDate *)[[weeklyObjects objectAtIndex:i] objectForKey:@"dt"]];
        [currentWeekObject setTemperature: [NSMutableString stringWithFormat:@"%d",(int)[self convertToFahranheit:temp]]];
        [currentWeekObject setWindSpeed:(NSMutableString *)[[weeklyObjects objectAtIndex:i] objectForKey:@"speed"]];
        [currentWeekObject setBackgroundImage:[UIImage imageNamed:currentWeekObject.weatherDescription]];
        [currentWeekObject setHigh:[NSMutableString stringWithFormat:@"%d",(int)[self convertToFahranheit:high]]];
        [currentWeekObject setLow:[NSMutableString stringWithFormat:@"%d",(int)[self convertToFahranheit:low]]];
        [tableWeeklyObjects addObject:currentWeekObject];
        
        //empty currentTodayObjects
        
    }
}
-(void)arrangeForView{
    highLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[weeklyObjects objectAtIndex:0] objectForKey:@"temp"] objectForKey:@"max"] floatValue]], @"\u00B0"];
    lowLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[weeklyObjects objectAtIndex:0] objectForKey:@"temp"] objectForKey:@"min"] floatValue]], @"\u00B0"];
    temperatureLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[weeklyObjects objectAtIndex:0] objectForKey:@"temp"] objectForKey:@"day"] floatValue]], @"\u00B0"];
    locationLabel.text = [NSMutableString stringWithFormat:@"%@",[[stuff objectForKey:@"city"] objectForKey:@"name"]];
    descriptionLabel.text = (NSMutableString *)[[[[ weeklyObjects objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"];
    double d = [[[weeklyObjects objectAtIndex:0] objectForKey:@"dt"] doubleValue];
    NSTimeInterval tInterval= (NSTimeInterval)d;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tInterval];
    dateLabel.text = [dFormatter stringFromDate:date];
    if([(NSMutableString *)[[[[ weeklyObjects objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Rain"]){
        mainBackgroundImage.image = [UIImage imageNamed:@"RainBackground"];
        weatherImage.image = [UIImage imageNamed:@"Rain"];
    }else if([(NSMutableString *)[[[[ weeklyObjects objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Clouds"]){
        mainBackgroundImage.image = [UIImage imageNamed:@"CloudBackground"];
        weatherImage.image = [UIImage imageNamed:@"Clouds"];
    }else if([(NSMutableString *)[[[[ weeklyObjects objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Snow"]){
        // self.view.backgroundColor = snow;
    }else{
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
        NSMutableString *dayOrNightString = [timeFormatter stringFromDate:date];
        if([dayOrNightString floatValue] >= 18.00 || [dayOrNightString floatValue] <=6.00){
            mainBackgroundImage.image = [UIImage imageNamed:@"NightBackground"];
            weatherImage.image = [UIImage imageNamed:@"moon"];
        }else{
            if([temperatureLabel.text integerValue] > 0){
                mainBackgroundImage.image = [UIImage imageNamed:@"SunBackground"];
            }else{
                mainBackgroundImage.image = [UIImage imageNamed:@"Snow"];
            }
            weatherImage.image = [UIImage imageNamed:@"Clear"];
        }
    }
    [self.weeklyCollectionView reloadData];
}
@end
