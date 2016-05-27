//
//  TenDaylyCollectionViewCell.h
//  FutureWeather
//
//  Created by Prince on 5/27/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TenDaylyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end
