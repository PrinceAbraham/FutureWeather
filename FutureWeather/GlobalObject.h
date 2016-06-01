//
//  GlobalObject.h
//  FutureWeather
//
//  Created by Prince on 6/1/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalObject : NSObject

@property NSMutableDictionary *dailyCallback, *weeklyCallback, *tenDayCallback;
@property BOOL isSearched;

-(void)setDailyCallback:(NSMutableDictionary *)dailyCallback;
-(void)setWeeklyCallback:(NSMutableDictionary *)weeklyCallback;
-(void)setTenDayCallback:(NSMutableDictionary *)tenDayCallback;
-(void)setIsSearched:(BOOL)isSearched;
@end
