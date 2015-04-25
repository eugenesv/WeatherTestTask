//
//  WeatherController.m
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import "WeatherController.h"
#import "CoreDataManager.h"

#import "TemperatureCell.h"
#import "WeatherCell.h"
#import "Weather.h"
#import "Wind.h"

@interface WeatherController ()

@end

@implementation WeatherController

@synthesize fetchedResultsController    = _fetchedResultsController;
@synthesize managedObjectContext        = _managedObjectContext;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Accessors

- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[CoreDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        static NSString *temperatureCellIdentifier = @"TemperatureCell";
        cell = (TemperatureCell *)[tableView dequeueReusableCellWithIdentifier:temperatureCellIdentifier forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
    } else if (indexPath.row == 1) {
        static NSString *weatherCellIdentifier = @"WeatherCell";
        cell = (WeatherCell *)[tableView dequeueReusableCellWithIdentifier:weatherCellIdentifier forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Weather *weather = [self.fetchedResultsController objectAtIndexPath:indexPath];
    City *city = weather.city;

    if ([cell isKindOfClass:[TemperatureCell class]]) {
        
    } else if ([cell isKindOfClass:[WeatherCell class]]) {
        
    }
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    //    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"cityName" ascending:YES];
    
    //    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor1];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

@end