//
//  MBBOptionsViewController.h
//  MapBox Bench
//
//  Created by Justin Miller on 6/20/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MBBOptionsDismissedNotification = @"MBBOptionsChangedNotification";

#define kDefaultTilePrefetchRadius 2
#define kDefaultMaxConcurrentOps   6

@interface MBBOptionsViewController : UITableViewController <UIAlertViewDelegate>

@end