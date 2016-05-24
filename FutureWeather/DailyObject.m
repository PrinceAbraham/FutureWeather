//
//  DailyObject.m
//  FutureWeather
//
//  Created by Prince on 5/24/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import "DailyObject.h"

@implementation DailyObject

-(void)setWeatherDescription:(NSMutableString *)weatherDescription{
    self.weatherDescription = weatherDescription;
}
-(void)setCloudiness:(NSMutableString *)cloudiness{
    self.cloudiness = cloudiness;
}
-(void)setWindSpeed:(NSMutableString *)windSpeed{
    self.windSpeed = windSpeed;
}
-(void)setCurrentTime:(NSDate *)currentTime{
    self.currentTime = currentTime;
}
-(void)setTemperature:(NSMutableString *)temperature{
    self.temperature = temperature;
}
-(void)setBackgroundImage:(UIImage *)backgroundImage{
    self.backgroundImage = backgroundImage;
}
-(void)setHigh:(NSMutableString *)high{
    self.high = high;
}
-(void)setLow:(NSMutableString *)low{
    self.low = low;
}
@end
