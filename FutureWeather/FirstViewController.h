//
//  FirstViewController.h
//  FutureWeather
//
//  Created by Prince on 5/20/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantsClass.h"
#import "DailyObject.h"

@interface FirstViewController : UIViewController<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *firstSearchBar;

@end

