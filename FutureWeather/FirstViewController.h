//
//  FirstViewController.h
//  FutureWeather
//
//  Created by Prince on 5/20/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantsClass.h"
#import "WeatherObject.h"
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController : UIViewController<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *firstSearchBar;

@property NSMutableArray *todayObjects, *tabletodayObjects;

-(float) convertToFahranheit:(float) kelvin;

@end

