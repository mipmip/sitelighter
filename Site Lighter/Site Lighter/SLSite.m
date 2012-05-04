//
//  SLSite.m
//  Site Lighter
//
//  Created by Pim Snel on 06-04-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "SLSite.h"

@implementation SLSite

@dynamic name;

+(id) siteInDefaultContext {
    NSManagedObjectContext* context = [[NSApp delegate] managedObjectContext];
    
    SLSite* newItem;
    newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Site" inManagedObjectContext:context];
    
    return newItem;
}


+ (id) defaultSite {
    NSManagedObjectContext* context = [[NSApp delegate] managedObjectContext];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Site" inManagedObjectContext:context];
    
    // create a fetch request to find default album
    NSFetchRequest* fetch = [[NSFetchRequest alloc] init];
    fetch.entity = entity;
    fetch.predicate = [NSPredicate predicateWithFormat:@"name == 'Default'"];
    
    // run fetch and make sure it  succeeded.
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:fetch error:&error];
    [fetch release];
    if (error) {
        NSLog(@"error: %@", error);
        return nil;
    }
    
    // create the album if it doesn't exist.
    SLSite* site = nil;
    if (results.count >0) {
        site = [results objectAtIndex:0];
    }
    else{
        site = [self siteInDefaultContext];
        site.name = @"Default";
    }
    return site;
}

@end
