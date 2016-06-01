//
//  GlobalObject.m
//  FutureWeather
//
//  Created by Prince on 6/1/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import "GlobalObject.h"

@implementation GlobalObject


-(void)setDailyCallback:(NSMutableDictionary *)dailyCallback{
    _dailyCallback = dailyCallback;
}
-(void)setWeeklyCallback:(NSMutableDictionary *)weeklyCallback{
    _weeklyCallback = weeklyCallback;
}
-(void)setTenDayCallback:(NSMutableDictionary *)tenDayCallback{
    _tenDayCallback = tenDayCallback;
}
-(void)setIsSearched:(BOOL)isSearched{
    _isSearched = isSearched;
}
@end
