//
//  MBBViewController.m
//  MapBox Bench
//
//  Created by Justin Miller on 6/20/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import "MBBViewController.h"

#import "RMMapView.h"
#import "RMMapBoxSource.h"

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
    
    tiledLayerView.layer.contents = nil;
    
    [tiledLayerView.layer setNeedsDisplay];
}

@end

#pragma mark -

@interface MBBViewController ()

@property (strong, nonatomic) RMMapView *mapView;

@end

#pragma mark -

@implementation MBBViewController

@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    RMMapBoxSource *onlineSource = [[RMMapBoxSource alloc] initWithReferenceURL:(([[UIScreen mainScreen] scale] > 1.0) ? kRetinaSourceURL : kNormalSourceURL)];
    
    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:onlineSource];
    
    self.mapView.zoom = 2;
    
    self.mapView.backgroundColor = [UIColor darkGrayColor];
    
    self.mapView.decelerationMode = RMMapDecelerationFast;
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.mapView.boundingMask = RMMapMinHeightBound;
    
    self.mapView.viewControllerPresentingAttribution = self;
    
    [self.view addSubview:self.mapView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Empty Cache" style:UIBarButtonItemStyleBordered target:self action:@selector(emptyCache:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStyleBordered target:self action:@selector(showOptions:)];
}

#pragma mark -

- (void)emptyCache:(id)sender
{
    [self.mapView emptyCacheAndForceRefresh];
}

- (void)showOptions:(id)sender
{
    NSLog(@"blah");
}

@end