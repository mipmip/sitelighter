//
//  AppDelegate.h
//  Site Lighter
//
//  Created by Pim Snel on 11-03-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SLSite.h"
#import "PreferencesController.h"


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (retain) PreferencesController *preferencesController;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain) SLSite* selectedSite;

@property (assign) IBOutlet NSView *targetView;

- (IBAction)overlay1:(id)sender;


- (IBAction)showPreferences:(id)sender;
- (IBAction)saveAction:(id)sender;
//- (IBAction)newSite:(id)sender;
- (IBAction)addSite:(id)sender;
- (NSURL *)applicationFilesDirectory;

@end
