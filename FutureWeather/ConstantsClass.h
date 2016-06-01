//
//  ConstantsClass.h
//  FutureWeather
//
//  Created by Prince on 5/23/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstantsClass : NSObject

FOUNDATION_EXPORT NSString *const URL;
FOUNDATION_EXPORT NSString *const DAILY;
FOUNDATION_EXPORT NSString *const WEEKLY;
FOUNDATION_EXPORT NSString *const APIURLWITHKEY;
FOUNDATION_EXPORT NSString *const SEARCHED;

#define rain [UIColor colorWithRed:240/255.0 green:248/255.0 blue:253/255.0 alpha:1.0]
#define night [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0]
#define day [UIColor colorWithRed:255/255.0 green:238/255.0 blue:196/255.0 alpha:1.0]
#define cloud [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]

@end
