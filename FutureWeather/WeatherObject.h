//
//  DailyObject.h
//  FutureWeather
//
//  Created by Prince on 5/24/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface WeatherObject : NSObject

@property (nonatomic, copy) NSMutableString *weatherDescription, *temperature, *windSpeed, *high, *low;
@property (nonatomic, copy) NSDate *currentTime;
@property (nonatomic, copy) UIImage *backgroundImage;

-(void)setWeatherDescription:(NSMutableString *)weatherDescription;
-(void)setBackgroundImage:(UIImage *)backgroundImage;
-(void)setTemperature:(NSMutableString *)temperature;
-(void)setWindSpeed:(NSMutableString *)windSpeed;
-(void)setCurrentTime:(NSDate *)currentTime;
-(void)setHigh:(NSMutableString *)high;
-(void)setLow:(NSMutableString *)low;
@end
