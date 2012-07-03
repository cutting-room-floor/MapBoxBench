//
//  MBBMainViewController.m
//  MapBox Bench
//
//  Created by Justin Miller on 6/20/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import "MBBMainViewController.h"

#import "MBBCommon.h"
#import "MBBOptionsViewController.h"

#import "RMMapView.h"
#import "RMMapBoxSource.h"

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

#define kNormalSourceURL [NSURL URLWithString:@"http://a.tiles.mapbox.com/v3/justin.map-s2effxa8.jsonp"] // see https://tiles.mapbox.com/justin/map/map-s2effxa8
#define kRetinaSourceURL [NSURL URLWithString:@"http://a.tiles.mapbox.com/v3/justin.map-kswgei2n.jsonp"] // see https://tiles.mapbox.com/justin/map/map-kswgei2n

#pragma mark -

@interface RMMapView (BenchExtensions)

- (void)emptyCacheAndForceRefresh;

@end

#pragma mark -

@implementation RMMapView (BenchExtensions)

- (void)emptyCacheAndForceRefresh
{
    [self removeAllCachedImages];

    for (RMMapTiledLayerView *tiledLayerView in [self valueForKeyPath:@"_tiledLayersSuperview.subviews"])
    {
        tiledLayerView.layer.contents = nil;

        [tiledLayerView.layer setNeedsDisplay];
    }
}

@end

#pragma mark -

@interface MBBMainViewController ()

@property (strong, nonatomic) RMMapView *mapView;
@property (strong, nonatomic) UIPopoverController *optionsPopover;
@property (nonatomic) BOOL defaultsDidChange;

@end

#pragma mark -

@implementation MBBMainViewController
{
    UILabel *operationCountLabel;
    NSTimer *operationLabelTimer;
}

@synthesize mapView;
@synthesize optionsPopover;
@synthesize defaultsDidChange;

- (void)viewDidLoad
{
    [super viewDidLoad];

    RMMapBoxSource *tileSource = [[RMMapBoxSource alloc] initWithReferenceURL:([MBBCommon isRetinaCapable] && [[NSUserDefaults standardUserDefaults] boolForKey:@"retinaEnabled"] ? kRetinaSourceURL : kNormalSourceURL)];
    
    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];
    
    self.mapView.zoom = 2;
    
    self.mapView.backgroundColor = [UIColor darkGrayColor];
    
    self.mapView.decelerationMode = RMMapDecelerationFast;
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.mapView.boundingMask = RMMapMinHeightBound;
    
    self.mapView.viewControllerPresentingAttribution = self;
    
    [self.view addSubview:self.mapView];
    
    self.title = [[NSProcessInfo processInfo] processName];
    
    self.navigationController.navigationBar.tintColor = [MBBCommon tintColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStyleBordered target:self action:@selector(reloadMap:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStyleBordered target:self action:@selector(showOptions:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMap:)         name:MBBOptionsDismissedNotification     object:nil];
    
    operationCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    operationCountLabel.textColor = [UIColor blackColor];
    operationCountLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];

    operationCountLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.view addSubview:operationCountLabel];
    
    operationLabelTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateOperationCount:) userInfo:nil repeats:YES];
    
    if ( ! [[NSUserDefaults standardUserDefaults] objectForKey:@"prefetchTileRadius"])
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"prefetchTileRadius"];

    if ( ! [[NSUserDefaults standardUserDefaults] objectForKey:@"maxConcurrentOperationCount"])
        [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:@"maxConcurrentOperationCount"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self reloadMap:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( ! [MBBCommon isRunningOnPhone])
            return YES;
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [operationLabelTimer invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBBOptionsDismissedNotification     object:nil];
}

#pragma mark -

- (void)updateOperationCount:(NSTimer *)timer
{
    int activeCount = [[(NSObject *)self.mapView.tileSource valueForKey:@"executingOperationCount"] intValue];
    int totalCount  = [[(NSObject *)self.mapView.tileSource valueForKey:@"totalOperationCount"]     intValue];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(activeCount > 0)];
    
    operationCountLabel.text = [NSString stringWithFormat:@" %i / %i ", activeCount, totalCount];
}

- (void)defaultsDidChange:(NSNotification *)notification
{
    self.defaultsDidChange = YES;
}
     
- (void)reloadMap:(id)sender
{
    if (self.optionsPopover.popoverVisible)
        [self.optionsPopover dismissPopoverAnimated:NO];

    if (self.defaultsDidChange || [sender isEqual:self])
    {
        RMMapBoxSource *tileSource;
        
        if ([[NSUserDefaults standardUserDefaults] URLForKey:@"tileJSONURL"])
            tileSource = [[RMMapBoxSource alloc] initWithReferenceURL:[[NSUserDefaults standardUserDefaults] URLForKey:@"tileJSONURL"]];
        else
            tileSource = [[RMMapBoxSource alloc] initWithReferenceURL:([MBBCommon isRetinaCapable] && [[NSUserDefaults standardUserDefaults] boolForKey:@"retinaEnabled"] ? kRetinaSourceURL : kNormalSourceURL)];

        self.mapView.tileSource = tileSource;
        
        self.mapView.adjustTilesForRetinaDisplay = ! [[NSUserDefaults standardUserDefaults] boolForKey:@"retinaEnabled"];

        self.mapView.showsUserLocation           =   [[NSUserDefaults standardUserDefaults] boolForKey:@"userTrackingEnabled"];
        self.mapView.userTrackingMode            =   ([[NSUserDefaults standardUserDefaults] boolForKey:@"centerMapEnabled"] ? RMUserTrackingModeFollow : RMUserTrackingModeNone);
                                                        
        self.mapView.debugTiles                  =   [[NSUserDefaults standardUserDefaults] boolForKey:@"showTilesEnabled"];
        
        self.mapView.loadAsynchronously          = ([[NSUserDefaults standardUserDefaults] integerForKey:@"concurrencyMethod"] == 1);
        self.mapView.prefetchTileRadius          = [[NSUserDefaults standardUserDefaults] integerForKey:@"prefetchTileRadius"];
        self.mapView.maxConcurrentOperationCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"maxConcurrentOperationCount"];
        self.mapView.artificialLatency           = [[NSUserDefaults standardUserDefaults] integerForKey:@"artificialLatency"];
        
        [self.mapView performSelector:@selector(emptyCacheAndForceRefresh) withObject:nil afterDelay:0];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"useMapKitEnabled"])
        {
            if ( ! [[[self.view subviews] valueForKeyPath:@"class"] containsObject:[MKMapView class]])
            {
                MKMapView *mapKitMapView = [[MKMapView alloc] initWithFrame:self.mapView.bounds];

                CLLocationCoordinate2D bottomLeft = [self.mapView pixelToCoordinate:self.mapView.bounds.origin];
                CLLocationCoordinate2D topRight   = [self.mapView pixelToCoordinate:CGPointMake(self.mapView.bounds.size.width, self.mapView.bounds.size.height)];
                
                mapKitMapView.region = MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(fabs(topRight.latitude - bottomLeft.latitude), fabs(topRight.longitude - bottomLeft.longitude)));
                
                [self.view addSubview:mapKitMapView];
            }

            self.mapView.hidden = YES;
        }
        else
        {
            if ([[[self.view subviews] valueForKeyPath:@"class"] containsObject:[MKMapView class]])
            {
                MKMapView *mapKitMapView;
                
                for (UIView *subview in [self.view subviews])
                    if ([subview isKindOfClass:[MKMapView class]])
                        mapKitMapView = (MKMapView *)subview;
                
                MKCoordinateRegion region = mapKitMapView.region;
                
                [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:CLLocationCoordinate2DMake(region.center.latitude  - region.span.latitudeDelta  / 2, 
                                                                                                  region.center.longitude - region.span.longitudeDelta / 2) 
                                                             northEast:CLLocationCoordinate2DMake(region.center.latitude  + region.span.latitudeDelta  / 2, 
                                                                                                  region.center.longitude + region.span.longitudeDelta / 2) 
                                                              animated:NO];
                
                [mapKitMapView removeFromSuperview];
            }
                 
            self.mapView.hidden = NO;
        }
    }
}

- (void)showOptions:(id)sender
{
    if ([MBBCommon isRunningOnPhone])
    {
        UINavigationController *wrapper = [[UINavigationController alloc] initWithRootViewController:[[MBBOptionsViewController alloc] initWithNibName:nil bundle:nil]];
        
        [self presentModalViewController:wrapper animated:YES];
    }
    else
    {
        if (self.optionsPopover.popoverVisible)
        {
            [self.optionsPopover dismissPopoverAnimated:YES];
        }
        else
        {
            self.optionsPopover = [[UIPopoverController alloc] initWithContentViewController:[[MBBOptionsViewController alloc] initWithNibName:nil bundle:nil]];
            
            self.optionsPopover.delegate = self;
            
            [self.optionsPopover setPopoverContentSize:CGSizeMake(400, 600)];
            
            [self.optionsPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    
    self.defaultsDidChange = NO;
}

#pragma mark -

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    popoverController = nil;
}

@end