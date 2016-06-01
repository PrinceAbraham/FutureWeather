//
//  AppDelegate.h
//  FutureWeather
//
//  Created by Prince on 5/20/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalObject.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

#define UIAppDelegate (AppDelegate *)[UIApplication sharedApplication].delegate)

@property (nonatomic, strong) GlobalObject *mainProperty;
@property (nonatomic, strong) NSMutableDictionary *dailyCallback, *weeklyCallback, *tenDayCallback;
@property BOOL isSearched;
@end

