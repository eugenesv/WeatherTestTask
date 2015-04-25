//
//  MapViewController.m
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "City.h"
#import "City+Annotation.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAnnotation];
}

#pragma mark - Actions

- (void)addAnnotation {
    [self.mapView addAnnotation:self.choosenCity];
}

@end
