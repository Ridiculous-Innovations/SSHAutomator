//
//  RiCoreData.h
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITask.h"
#import "RIJob.h"
#import "RIAccount.h"
#import "RIHistory.h"
#import "RICertificate.h"


@interface RICoreData : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (RIAccount *)newAccount;
- (NSArray *)accounts;

- (RIJob *)newJobForAccount:(RIAccount *)account;
- (NSArray *)jobsForAccount:(RIAccount *)account;

- (RITask *)newTaskForJob:(RIJob *)job;
- (NSArray *)tasksForJob:(RIJob *)job;

- (RIHistory *)newHistoryForJob:(RIJob *)job;
- (NSArray *)historyForJob:(RIJob *)job;
- (void)clearHistoryForJob:(RIJob *)job;

- (RICertificate *)newCertificate;
- (NSArray *)certificates;


@end
