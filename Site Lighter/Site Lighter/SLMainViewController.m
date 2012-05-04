//
//  SLMainViewController.m
//  Site Lighter
//
//  Created by Pim Snel on 04-05-12.
//  Copyright (c) 2012 Lingewoud b.v. All rights reserved.
//

#import "SLMainViewController.h"
#import "SLSite.h"

@interface SLMainViewController ()

@end

@implementation SLMainViewController

@synthesize sitesTable;
@synthesize sitesArrayController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        //self.mainView.delegate = self;
    }
    
    return self;
}

- (void) loadView{
    [super loadView];
  
    [SLSite defaultSite];

    self.sitesTable.delegate = self;
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification{
    NSTableView* table = [notification object];
    NSInteger selection = table.selectedRow;
    NSArray* sites = [self.sitesArrayController arrangedObjects];
    
    SLSite * site = [sites objectAtIndex:selection];
    [[NSApp delegate] setValue:site forKey: @"selectedSite"];
    
    NSLog(@"%@",site);
}

@end
