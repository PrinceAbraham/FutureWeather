//
//  ThirdViewController.m
//  FutureWeather
//
//  Created by Prince on 5/23/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *tenDaylySearchBar;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UICollectionView *tenDaylyCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainBackgroundImage;

@end

@implementation ThirdViewController

@synthesize tenDaylySearchBar, weatherImage, tenDaylyCollectionView, highLabel, lowLabel, locationLabel, descriptionLabel, temperatureLabel, dateLabel, mainBackgroundImage;

NSMutableString *tenDailySearchText;
NSMutableArray *tenDayly, *tableTenDayly;
WeatherObject * currentTenDayly;
NSDateFormatter *tenDaylydFormatter;
AppDelegate *forTenDay;
NSDictionary *stuffForTenDay;

-(void)viewWillAppear:(BOOL)animated{
    forTenDay = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    stuffForTenDay = [[NSMutableDictionary alloc] init];
    if(forTenDay.isSearched){
        stuffForTenDay = forTenDay.tenDayCallback;
        tenDayly = [stuffForTenDay objectForKey:@"list"];
        [self arrangeForTable];
        [self arrangeForView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tenDailySearchText = [[NSMutableString alloc]init];
    tenDayly = [[NSMutableArray alloc] init];
    tableTenDayly = [[NSMutableArray alloc] init];
    currentTenDayly = [[WeatherObject alloc] init];
    tenDaylydFormatter = [[NSDateFormatter alloc] init];
    [tenDaylydFormatter setDateStyle:NSDateFormatterMediumStyle];
    tenDaylySearchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Search Delegates
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //if search field is not empty
    if(![searchBar.text isEqualToString:@""]){
        tenDailySearchText = [[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]mutableCopy];
    }
    searchBar.text = @"";
    [self.view endEditing:YES];
    [self getTenDaylyWeather:tenDailySearchText];
}
#pragma mark - CollectionView Delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TenDaylyCollectionViewCell *cell = (TenDaylyCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"tenDayly" forIndexPath:indexPath];
    if([tenDayly count]>0){
        double d = [[[tenDayly objectAtIndex:indexPath.row] objectForKey:@"dt"] doubleValue];
        NSTimeInterval tInterval= (NSTimeInterval)d;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:tInterval];
        cell.dayLabel.text = [tenDaylydFormatter stringFromDate:date];
        cell.temperatureLabel.text = [NSString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[tenDayly objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"day"] floatValue]], @"\u00B0"];
        
        if([(NSMutableString *)[[[[ tenDayly objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Rain"]){

            cell.backgroundImage.image = [UIImage imageNamed:@"Rain"];
        
        }else if([(NSMutableString *)[[[[ tenDayly objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Clouds"]){
           cell.backgroundImage.image = [UIImage imageNamed:@"Clouds"];
        }else if([(NSMutableString *)[[[[ tenDayly objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Snow"]){
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
    if(forTenDay.isSearched){
    highLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[tenDayly objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"max"] floatValue]], @"\u00B0"];
    lowLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[tenDayly objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"min"] floatValue]], @"\u00B0"];
    temperatureLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[tenDayly objectAtIndex:indexPath.row] objectForKey:@"temp"] objectForKey:@"day"] floatValue]], @"\u00B0"];
    descriptionLabel.text = (NSMutableString *)[[[[ tenDayly objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"];
    double d = [[[tenDayly objectAtIndex:indexPath.row] objectForKey:@"dt"] doubleValue];
    NSTimeInterval tInterval= (NSTimeInterval)d;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tInterval];
    dateLabel.text = [tenDaylydFormatter stringFromDate:date];
    if([(NSMutableString *)[[[[ tenDayly objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Rain"]){
        mainBackgroundImage.image = [UIImage imageNamed:@"RainBackground"];
        weatherImage.image = [UIImage imageNamed:@"Rain"];
    }else if([(NSMutableString *)[[[[ tenDayly objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Clouds"]){
        mainBackgroundImage.image = [UIImage imageNamed:@"CloudBackground"];
        weatherImage.image = [UIImage imageNamed:@"Clouds"];
    }else if([(NSMutableString *)[[[[ tenDayly objectAtIndex:indexPath.row] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Snow"]){
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
    [self.tenDaylyCollectionView reloadData];
    }
}


#pragma mark - Custom Functions
-(void)getTenDaylyWeather:(NSMutableString *) text{
    NSMutableCharacterSet *numSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    NSMutableString *zipOrCity = [[NSMutableString alloc]init];
    BOOL zip = [[tenDailySearchText stringByTrimmingCharactersInSet:numSet] isEqualToString:@""];
    
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
        stuffForTenDay = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(![[stuffForTenDay objectForKey:@"cod"]isEqualToString: @"404"]){
        forTenDay.isSearched = YES;
        forTenDay.weeklyCallback = [stuffForTenDay mutableCopy];
        forTenDay.tenDayCallback = [stuffForTenDay mutableCopy];
        tenDayly = [stuffForTenDay objectForKey:@"list"];
        NSLog(@"PRINT %lu",[tenDayly count]);
        
        [self arrangeForTable];
        
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^(void){
        
        [self arrangeForView];
        
        });
          }else{
              [self presentViewController:forTenDay.unavailableSearch animated:YES completion:nil];
          }
        }else{
            [self presentViewController:forTenDay.checkInternet animated:YES completion:nil];
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
        stuffForTenDay = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(![[stuffForTenDay objectForKey:@"cod"]isEqualToString: @"404"]){
            forTenDay.dailyCallback = [stuffForTenDay mutableCopy];
        }else{
            //Show Search Alert
        }
        }else{
            //[self presentViewController:forTenDay.checkInternet animated:YES completion:nil];
        }
    }] resume];

}

-(float) convertToFahranheit:(float)kelvin{
    float k= (round(kelvin * 9.0/5) - 459.67)-10;
    int f = (int)k;
    return f;
}
-(void) arrangeForTable{
    for(int i=0; i<[tenDayly count]; i++){
        float temp=0,high=0,low=0;
        temp = [[[[tenDayly objectAtIndex:i] objectForKey:@"temp"] objectForKey:@"day"] floatValue];
        high= [[[[tenDayly objectAtIndex:i] objectForKey:@"temp"] objectForKey:@"max"] floatValue];
        low = [[[[tenDayly objectAtIndex:i] objectForKey:@"temp"] objectForKey:@"min"] floatValue];
        [currentTenDayly setWeatherDescription:(NSMutableString *)[[[[ tenDayly objectAtIndex:i] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"]];
        [currentTenDayly setCurrentTime:(NSDate *)[[tenDayly objectAtIndex:i] objectForKey:@"dt"]];
        [currentTenDayly setTemperature: [NSMutableString stringWithFormat:@"%d",(int)[self convertToFahranheit:temp]]];
        [currentTenDayly setWindSpeed:(NSMutableString *)[[tenDayly objectAtIndex:i] objectForKey:@"speed"]];
        [currentTenDayly setBackgroundImage:[UIImage imageNamed:currentTenDayly.weatherDescription]];
        [currentTenDayly setHigh:[NSMutableString stringWithFormat:@"%d",(int)[self convertToFahranheit:high]]];
        [currentTenDayly setLow:[NSMutableString stringWithFormat:@"%d",(int)[self convertToFahranheit:low]]];
        [tableTenDayly addObject:currentTenDayly];
        
        //empty currentTodayObjects
        
    }
}
-(void) arrangeForView{
    highLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[tenDayly objectAtIndex:0] objectForKey:@"temp"] objectForKey:@"max"] floatValue]], @"\u00B0"];
    lowLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[tenDayly objectAtIndex:0] objectForKey:@"temp"] objectForKey:@"min"] floatValue]], @"\u00B0"];
    temperatureLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[tenDayly objectAtIndex:0] objectForKey:@"temp"] objectForKey:@"day"] floatValue]], @"\u00B0"];
    locationLabel.text = [NSMutableString stringWithFormat:@"%@",[[stuffForTenDay objectForKey:@"city"] objectForKey:@"name"]];
    descriptionLabel.text = (NSMutableString *)[[[[ tenDayly objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"];
    double d = [[[tenDayly objectAtIndex:0] objectForKey:@"dt"] doubleValue];
    NSTimeInterval tInterval= (NSTimeInterval)d;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tInterval];
    dateLabel.text = [tenDaylydFormatter stringFromDate:date];
    if([(NSMutableString *)[[[[ tenDayly objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Rain"]){
        mainBackgroundImage.image = [UIImage imageNamed:@"RainBackground"];
        weatherImage.image = [UIImage imageNamed:@"Rain"];
    }else if([(NSMutableString *)[[[[ tenDayly objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Clouds"]){
        mainBackgroundImage.image = [UIImage imageNamed:@"CloudBackground"];
        weatherImage.image = [UIImage imageNamed:@"Clouds"];
    }else if([(NSMutableString *)[[[[ tenDayly objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Snow"]){
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
    [self.tenDaylyCollectionView reloadData];
}
@end
