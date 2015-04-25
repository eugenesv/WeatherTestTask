//
//  CitiesListController.m
//  WeatherTestTask
//
//  Created by Eugene Sokolenko on 25.04.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import "CitiesListController.h"
#import "CoreDataManager.h"
#import "CityCell.h"
#import "City.h"

@interface CitiesListController ()

@end

@implementation CitiesListController

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
    static NSString *cityCellIdentifier = @"CityCell";
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CityCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    City *city = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.cityNameLabel.text = city.cityName;
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
