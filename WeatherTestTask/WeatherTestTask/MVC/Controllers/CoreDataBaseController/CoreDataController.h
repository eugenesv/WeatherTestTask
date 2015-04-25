//
//  CoreDataController.h
//  CoreDataDevelopment
//
//  Created by Eugene Sokolenko on 01.02.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "YRActivityIndicator.h"

@interface CoreDataController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) YRActivityIndicator *activityIndicator;

@end
