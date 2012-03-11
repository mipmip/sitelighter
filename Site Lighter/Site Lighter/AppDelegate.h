//
//  AppDelegate.h
//  Site Lighter
//
//  Created by Pim Snel on 11-03-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Preferences.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain) Preferences *preferences;


- (IBAction)showPreferences:(id)sender;
- (IBAction)saveAction:(id)sender;

@end