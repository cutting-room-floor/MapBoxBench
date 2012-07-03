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

typedef enum {
    MBBConcurrencyMethodProduction   = 0,
    MBBConcurrencyMethodAsynchronous = 1,
    MBBConcurrencyMethodBatched      = 2,
} MBBConcurrencyMethod;

@interface MBBOptionsViewController : UITableViewController <UIAlertViewDelegate>

@end