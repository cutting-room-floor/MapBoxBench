//
//  MBBCommon.m
//  MapBox Bench
//
//  Created by Justin Miller on 6/20/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import "MBBCommon.h"

@implementation MBBCommon

+ (UIColor *)tintColor
{
    return [UIColor colorWithRed:0.120 green:0.550 blue:0.670 alpha:1.000];
}

+ (BOOL)isRunningOnPhone
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

+ (BOOL)isRetinaCapable
{
    return ([[UIScreen mainScreen] scale] > 1.0);
}

@end