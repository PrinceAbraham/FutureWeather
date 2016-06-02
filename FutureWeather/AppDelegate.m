//
//  AppDelegate.m
//  FutureWeather
//
//  Created by Prince on 5/20/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize location;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    location = [[CLLocationManager alloc]init];
    location.desiredAccuracy = kCLLocationAccuracyBest;
    location.distanceFilter = kCLDistanceFilterNone;
    [location requestWhenInUseAuthorization];
    location.delegate = self;
    [location requestLocation];
    _checkInternet = [UIAlertController alertControllerWithTitle:@"No Internet Connection" message:@"Please check your Internet!" preferredStyle:UIAlertControllerStyleAlert];
    _unavailableSearch = [UIAlertController alertControllerWithTitle:@"Invalid Search" message:@"Please enter a valid City or Zip." preferredStyle:UIAlertControllerStyleAlert];
    _ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [_unavailableSearch addAction:_ok];
    [_checkInternet addAction:_ok];
    return YES;
}
#pragma mark - Location Delegates
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    float latitude=0.0, longitude=0.0;
    latitude = [locations lastObject].coordinate.latitude;
    longitude = [locations lastObject].coordinate.longitude;
    NSLog(@"%.2f", [locations lastObject].coordinate.latitude);
    NSString *cityCall = [NSString stringWithFormat:@"lat=%f&lon=%f",latitude,longitude];
    NSMutableString *urlForThisCall = [[URL stringByAppendingString:WEEKLY]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:cityCall]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:@"&mode=json"]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:APIURLWITHKEY]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:@"&cnt=10"]mutableCopy];
    NSURL *url = [NSURL URLWithString:urlForThisCall];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //handle response
        if(data != nil){
        NSDictionary *stuff = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(![[stuff objectForKey:@"cod"]isEqualToString: @"404"]){
            _weeklyCallback = [stuff mutableCopy];
            _tenDayCallback = [stuff mutableCopy];
        }else{
            //Show error Alert
        }
        }
    }] resume];
    urlForThisCall = [[URL stringByAppendingString:DAILY]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:cityCall]mutableCopy];
    urlForThisCall = [[urlForThisCall stringByAppendingString:APIURLWITHKEY]mutableCopy];
    url = [NSURL URLWithString:urlForThisCall];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //handle response
        if(data !=nil){
        NSDictionary *stuff = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(![[stuff objectForKey:@"cod"]isEqualToString: @"404"]){
            _dailyCallback = [stuff mutableCopy];
            _isSearched = YES;
        }else{
            //Show error Alert
        }
        }
    }] resume];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    _isSearched = NO;
}

@end
