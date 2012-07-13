//
//  MBBOptionsViewController.h
//  MapBox Bench
//
//  Created by Justin Miller on 6/20/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MBBOptionsDismissedNotification = @"MBBOptionsChangedNotification";

static NSString *const MBBDefaultsKeyRetinaEnabled           = @"retinaEnabled";
static NSString *const MBBDefaultsKeyConcurrencyMethod       = @"concurrencyMethod";
static NSString *const MBBDefaultsKeyPrefetchTileRadius      = @"prefetchTileRadius";
static NSString *const MBBDefaultsKeyMaxConcurrentOperations = @"maxConcurrentOperationCount";
static NSString *const MBBDefaultsKeyShowUserLocation        = @"userTrackingEnabled";
static NSString *const MBBDefaultsKeyCenterUserLocation      = @"centerMapEnabled";
static NSString *const MBBDefaultsKeyDebugTiles              = @"showTilesEnabled";
static NSString *const MBBDefaultsKeyTileJSONURL             = @"tileJSONURL";
static NSString *const MBBDefaultsKeyShowMapKit              = @"useMapKitEnabled";
static NSString *const MBBDefaultsKeyLatency                 = @"artificialLatency";

#define kDefaultTilePrefetchRadius 1
#define kDefaultMaxConcurrentOps   6

typedef enum {
    MBBConcurrencyMethodProduction   = 0,
    MBBConcurrencyMethodAsynchronous = 1,
} MBBConcurrencyMethod;

@interface MBBOptionsViewController : UITableViewController <UIAlertViewDelegate>

@end