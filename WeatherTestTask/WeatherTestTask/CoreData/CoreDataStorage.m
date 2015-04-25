//
//  CoreDataStorage.m
//  CoreDataDevelopment
//
//  Created by Eugene Sokolenko on 07.02.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

#import "CoreDataStorage.h"
#import "CoreDataManager.h"

@interface CoreDataStorage ()

@property (strong, nonatomic) NSManagedObjectContext    *managedObjectContext;
@property (strong, nonatomic) CoreDataManager           *coreDataManager;

@end

@implementation CoreDataStorage

#pragma mark - Accessors

- (NSManagedObjectContext*)managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[CoreDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

- (CoreDataManager *)coreDataManager {
    if (!_coreDataManager) {
        _coreDataManager = [CoreDataManager sharedManager];
    }
    return _coreDataManager;
}

+ (CoreDataStorage*)sharedStorage {
    static CoreDataStorage *storage = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storage = [[CoreDataStorage alloc] init];
    });
    
    return storage;
}

#pragma mark - CoreData to SQL requests



@end
