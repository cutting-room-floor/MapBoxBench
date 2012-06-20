//
//  MBBCommon.h
//  MapBox Bench
//
//  Created by Justin Miller on 6/20/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBBCommon : NSObject

+ (UIColor *)tintColor;
+ (BOOL)isRunningOnPhone;
+ (BOOL)isRetinaCapable;

@end