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

@end

@implementation ThirdViewController

@synthesize tenDaylySearchBar, weatherImage, tenDaylyCollectionView, highLabel, lowLabel, locationLabel, descriptionLabel, temperatureLabel;

NSMutableString *tenDailySearchText;
NSMutableArray *tenDayly, *tableTenDayly;
WeatherObject * currentTenDayly;
NSDateFormatter *tenDaylydFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tenDailySearchText = [[NSMutableString alloc]init];
    tenDayly = [[NSMutableArray alloc] init];
    tableTenDayly = [[NSMutableArray alloc] init];
    currentTenDayly = [[WeatherObject alloc] init];
    tenDaylydFormatter = [[NSDateFormatter alloc] init];
    [tenDaylydFormatter setDateStyle:NSDateFormatterShortStyle];
    tenDaylySearchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self.view endEditing:YES];
    [self getTenDaylyWeather:tenDailySearchText];
}
#pragma mark - CollectionView Delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TenDaylyCollectionViewCell *cell = (TenDaylyCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"tenDayly" forIndexPath:indexPath];
    if([tenDayly count]>0){
        double d = [[[tenDayly objectAtIndex:indexPath.row+1] objectForKey:@"dt"] doubleValue];
        NSTimeInterval tInterval= (NSTimeInterval)d;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:tInterval];
        cell.dayLabel.text = [tenDaylydFormatter stringFromDate:date];
        cell.backgroundImage.image = [UIImage imageNamed:[ NSString stringWithFormat:@"%@",[[[[tenDayly objectAtIndex:indexPath.row+1] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"]]];
        cell.temperatureLabel.text = [NSString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[tenDayly objectAtIndex:indexPath.row+1] objectForKey:@"temp"] objectForKey:@"day"] floatValue]], @"\u00B0"];
    }
    return cell;
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
        
        NSDictionary *stuff = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        tenDayly = [stuff objectForKey:@"list"];
        NSLog(@"PRINT %lu",[tenDayly count]);
        
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
        
        dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^(void){
            highLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[tenDayly objectAtIndex:0] objectForKey:@"temp"] objectForKey:@"max"] floatValue]], @"\u00B0"];
            lowLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[tenDayly objectAtIndex:0] objectForKey:@"temp"] objectForKey:@"min"] floatValue]], @"\u00B0"];
            temperatureLabel.text = [NSMutableString stringWithFormat:@"%d%@F",(int)[self convertToFahranheit:[[[[tenDayly objectAtIndex:0] objectForKey:@"temp"] objectForKey:@"day"] floatValue]], @"\u00B0"];
            weatherImage.image = [UIImage imageNamed:(NSMutableString *)[[[[ tenDayly objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"]];
            locationLabel.text = [NSMutableString stringWithFormat:@"%@",[[stuff objectForKey:@"city"] objectForKey:@"name"]];
            descriptionLabel.text = (NSMutableString *)[[[[ tenDayly objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"];
            if([(NSMutableString *)[[[[ tenDayly objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Rain"]){
                self.view.backgroundColor = rain;
            }else if([(NSMutableString *)[[[[ tenDayly objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Clouds"]){
                self.view.backgroundColor = cloud;
            }else if([(NSMutableString *)[[[[ tenDayly objectAtIndex:0] objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"] isEqualToString:@"Snow"]){
                // self.view.backgroundColor = snow;
            }else{
                //if(
            }
            [self.tenDaylyCollectionView reloadData];
        });
        
    }] resume];
    
}

-(float) convertToFahranheit:(float)kelvin{
    float k= (round(kelvin * 9.0/5) - 459.67)-10;
    int f = (int)k;
    return f;
}

@end
