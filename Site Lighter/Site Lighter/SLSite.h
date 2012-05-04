//
//  SLSite.h
//  Site Lighter
//
//  Created by Pim Snel on 06-04-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SLSite : NSManagedObject

@property (retain) NSString* name;

+(id) defaultSite;
+(id) siteInDefaultContext;

@end
