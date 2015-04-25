//
//  TemperatureCell.h
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * dayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel * maxTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel * minTemperatureLabel;

@end
