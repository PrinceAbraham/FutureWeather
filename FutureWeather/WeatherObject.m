//
//  DailyObject.m
//  FutureWeather
//
//  Created by Prince on 5/24/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import "WeatherObject.h"

@implementation WeatherObject

-(void)setWeatherDescription:(NSMutableString *)wDescription{
    _weatherDescription = wDescription;
}
-(void)setWindSpeed:(NSMutableString *)wSpeed{
    _windSpeed = wSpeed;
}
-(void)setCurrentTime:(NSDate *)currentTime{
    _currentTime = currentTime;
}
-(void)setTemperature:(NSMutableString *)temp{
    _temperature = temp;
}
-(void)setBackgroundImage:(UIImage *)bImage{
    _backgroundImage = bImage;
}
-(void)setHigh:(NSMutableString *)h{
    _high = h;
}
-(void)setLow:(NSMutableString *)l{
    _low = l;
}
@end
