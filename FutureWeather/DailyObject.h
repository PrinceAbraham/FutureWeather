//
//  DailyObject.h
//  FutureWeather
//
//  Created by Prince on 5/24/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface DailyObject : NSObject

@property NSMutableString *weatherDescription, *temperature, *cloudiness, *windSpeed, *high, *low;
@property NSDate *currentTime;
@property UIImage *backgroundImage;

-(void)setWeatherDescription:(NSMutableString *)weatherDescription;
-(void)setBackgroundImage:(UIImage *)backgroundImage;
-(void)setTemperature:(NSMutableString *)temperature;
-(void)setCloudiness:(NSMutableString *)cloudiness;
-(void)setWindSpeed:(NSMutableString *)windSpeed;
-(void)setCurrentTime:(NSDate *)currentTime;
-(void)setHigh:(NSMutableString *)high;
-(void)setLow:(NSMutableString *)low;
@end
