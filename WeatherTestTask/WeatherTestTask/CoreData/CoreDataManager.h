//
//  CoreDataManager.h
//  CoreDataDevelopment
//
//  Created by Eugene Sokolenko on 01.02.15.
//  Copyright (c) 2015 Eugene Sokolenko. All rights reserved.
//

@interface CoreDataManager : NSObject

+(CoreDataManager*) sharedManager;

#pragma mark - CoreData

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (weak, nonatomic) dispatch_queue_t contextQueue;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)deleteManagedObject:(NSManagedObject*)object;
- (void)deleteCollection:(id<NSFastEnumeration>)collection;
- (NSManagedObject*)addNewManagedObjectForName:(NSString*)name;
- (NSArray*)getEntities:(NSString*)entityName byPredicate:(NSPredicate*)predicate;
- (NSArray*)getEntities:(NSString*)entityName;

@end
