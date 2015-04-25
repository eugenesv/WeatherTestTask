//
//  WeatherController.m
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

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
@property (weak, nonatomic) IBOutlet UILabel *dayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;

@property (strong, nonatomic) YRActivityIndicator *activityIndicator;

@end

@implementation WeatherController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getWeather];
    self.activityIndicator = [YRActivityIndicator makeFromXibWithFileOwner:nil];
    [self.activityIndicator setCenter:self.view.center];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

#pragma mark - UITableViewDataSource methods

#pragma mark - Actions

- (void)getWeather {
    
    __weak typeof(self)weakSelf = self;
    
    self.currentWeather = [[CoreDataStorage sharedStorage] getWeatherByCity:self.choosenCity];
    
    NSDate *weatherDate = [NSDate dateWithTimeIntervalSince1970:[self.currentWeather.weatherDate integerValue]];
    NSDate *expirationDate = [weatherDate dateByAddingTimeInterval:60*10];
    
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
    self.maxTemperatureLabel.text = [NSString stringWithFormat:@"%@", self.currentWeather.temperatureMax];
    self.minTemperatureLabel.text = [NSString stringWithFormat:@"%@", self.currentWeather.temperatureMin];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSDate *sunriseDate = [NSDate dateWithTimeIntervalSince1970:[self.currentWeather.sunrise integerValue]];
    NSDate *sunsetDate = [NSDate dateWithTimeIntervalSince1970:[self.currentWeather.sunset integerValue]];
    
    self.sunriseLabel.text = [dateFormatter stringFromDate:sunriseDate];
    self.sunsetLabel.text = [dateFormatter stringFromDate:sunsetDate];
    [self.weatherIcon setImage:[UIImage imageWithData:self.currentWeather.icon.imageData]];
    
    self.humidityLabel.text = [NSString stringWithFormat:@"%@ percents", self.currentWeather.humidity];
    self.windLabel.text = [NSString stringWithFormat:@"Speed %@, degree %@", self.currentWeather.windSpeed, self.currentWeather.windDegree];
    self.pressureLabel.text = [NSString stringWithFormat:@"%@", self.currentWeather.pressure];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToMap"]) {
        MapViewController *controller = (MapViewController *)segue.destinationViewController;
        controller.choosenCity = self.choosenCity;
    }
}

@end
