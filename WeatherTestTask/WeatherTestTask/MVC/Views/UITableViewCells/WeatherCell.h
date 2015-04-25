//
//  WeatherCell.h
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel * sunsetLabel;
@property (weak, nonatomic) IBOutlet UILabel * humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel * windLabel;
@property (weak, nonatomic) IBOutlet UILabel * pressureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;

@end
