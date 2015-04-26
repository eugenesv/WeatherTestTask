//
//  WeatherController.m
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

static NSUInteger const kTimeBeforeUpdate = 60*10;

#import "WeatherController.h"
#import "CoreDataManager.h"

#import "Weather.h"
#import "City.h"
#import "SEProjectFacade.h"
#import "CoreDataStorage.h"
#import "CustomImage.h"
#import "YRActivityIndicator.h"
#import "UIView+MakeFromXib.h"
#import "MapViewController.h"

@interface WeatherController ()

@property (strong, nonatomic) Weather *currentWeather;

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *seaLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *groundLevelLabel;

@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;

@property (strong, nonatomic) YRActivityIndicator *activityIndicator;

@end

@implementation WeatherController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addActivityIndicator];
    [self getWeather];
}

#pragma mark - Actions

- (void)addActivityIndicator {
    self.activityIndicator = [YRActivityIndicator makeFromXibWithFileOwner:nil];
    [self.activityIndicator setCenter:self.view.center];
    [self.view addSubview:self.activityIndicator];
}

- (void)getWeather {
    
    __weak typeof(self)weakSelf = self;
    
    self.currentWeather = [[CoreDataStorage sharedStorage] getWeatherByCity:self.choosenCity];
    
    NSDate *weatherDate     = [NSDate dateWithTimeIntervalSince1970:[self.currentWeather.weatherDate integerValue]];
    NSDate *expirationDate  = [weatherDate dateByAddingTimeInterval:kTimeBeforeUpdate];
    
    //if there is no current weather of if user tries to update weather before 10 minutes pass
    if (!self.currentWeather || [expirationDate compare:[NSDate date]] == NSOrderedAscending) {
        [self.activityIndicator startAnimating];
        [SEProjectFacade getWeatherByCity:self.choosenCity onSuccess:^(Weather *weather) {
            weakSelf.currentWeather = weather;
            [weakSelf setWeatherInfo];
            [weakSelf.activityIndicator stopAnimating];
        } onFailure:^(NSError *error, BOOL isCanceled) {
            [weakSelf.activityIndicator stopAnimating];
        }];
    } else {
        [self setWeatherInfo];
    }
}

- (void)setWeatherInfo {
    
    NSDate *sunriseDate         = [NSDate dateWithTimeIntervalSince1970:[self.currentWeather.sunrise integerValue]];
    NSDate *sunsetDate          = [NSDate dateWithTimeIntervalSince1970:[self.currentWeather.sunset integerValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    
    self.sunriseLabel.text      = [dateFormatter stringFromDate:sunriseDate];
    self.sunsetLabel.text       = [dateFormatter stringFromDate:sunsetDate];
    
    [self.weatherIcon setImage:[UIImage imageWithData:self.currentWeather.icon.imageData]];
    
    self.humidityLabel.text     = [NSString stringWithFormat:@"%@ %%", self.currentWeather.humidity];
    self.windLabel.text         = [NSString stringWithFormat:@"Speed: %@ , mps\nDirection: %@, degrees", self.currentWeather.windSpeed, self.currentWeather.windDegree];
    self.pressureLabel.text     = [NSString stringWithFormat:@"%@, hPa", self.currentWeather.pressure];
    
    self.cityNameLabel.text = [NSString stringWithFormat:@"%@, %@", self.choosenCity.cityName, self.choosenCity.countryName];
    self.currentTemperatureLabel.text = [NSString stringWithFormat:@"%.0f ˚", [self.currentWeather.temperature floatValue]];
    self.descriptionLabel.text  = self.currentWeather.weatherDescription;
    self.seaLevelLabel.text     = [NSString stringWithFormat:@"%@, hPa", self.currentWeather.seaLevel];
    self.groundLevelLabel.text  = [NSString stringWithFormat:@"%@, hPa", self.currentWeather.groundLevel];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToMap"]) {
        MapViewController *controller = (MapViewController *)segue.destinationViewController;
        controller.choosenCity = self.choosenCity;
    }
}

@end
