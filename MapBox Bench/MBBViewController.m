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

#define kNormalSourceURL [NSURL URLWithString:@"http://a.tiles.mapbox.com/v3/justin.map-s2effxa8.jsonp"] // see https://tiles.mapbox.com/justin/map/map-s2effxa8
#define kRetinaSourceURL [NSURL URLWithString:@"http://a.tiles.mapbox.com/v3/justin.map-kswgei2n.jsonp"] // see https://tiles.mapbox.com/justin/map/map-kswgei2n

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
}

@end