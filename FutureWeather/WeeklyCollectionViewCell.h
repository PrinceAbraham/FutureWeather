//
//  WeeklyCollectionViewCell.h
//  FutureWeather
//
//  Created by Prince on 5/26/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeklyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *DayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end
