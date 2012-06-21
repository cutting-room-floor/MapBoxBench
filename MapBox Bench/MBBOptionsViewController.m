//
//  MBBOptionsViewController.m
//  MapBox Bench
//
//  Created by Justin Miller on 6/20/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import "MBBOptionsViewController.h"

#import "MBBCommon.h"

@implementation MBBOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Options";
    
    self.navigationController.navigationBar.tintColor = [MBBCommon tintColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModalViewControllerAnimated:)];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MBBOptionsChangedNotification object:self];
}

#pragma mark -

- (void)toggleSwitch:(UISwitch *)sender
{
    NSString *defaultName;
    
    switch (sender.tag)
    {
        case 1:
        {
            defaultName = @"retina";
            break;
        }
        case 2:
        {
            defaultName = @"userTracking";
            break;
        }
        case 3:
        {
            defaultName = @"showTiles";
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:[NSString stringWithFormat:@"%@Enabled", defaultName]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return ([MBBCommon isRetinaCapable] ? 1 : 0);
        }
        case 1:
        {
            return 3;
        }
        case 2:
        {
            return 1;
        }
        case 3:
        {
            return 1;
        }
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return @"Retina";
        }
        case 1:
        {
            return @"Concurrency";
        }
        case 2:
        {
            return @"User Location Services";
        }
        case 3:
        {
            return @"Debugging";
        }
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    switch (indexPath.section)
    {
        case 0:
        {
            if ([MBBCommon isRetinaCapable])
            {
                UISwitch *retinaSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                
                retinaSwitch.onTintColor = [MBBCommon tintColor];
                
                retinaSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"retinaEnabled"];
                
                retinaSwitch.tag = 1;
                
                cell.accessoryView = retinaSwitch;
                
                cell.textLabel.text = @"Use retina tiles";
                
                [retinaSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                cell.textLabel.text = @"Not available on device";
            }
            
            break;
        }
        case 1:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"method %i", indexPath.row + 1];
            
            break;
        }
        case 2:
        {
            UISwitch *userTrackingSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            userTrackingSwitch.onTintColor = [MBBCommon tintColor];
            
            userTrackingSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"userTrackingEnabled"];
            
            userTrackingSwitch.tag = 2;
            
            cell.accessoryView = userTrackingSwitch;
            
            cell.textLabel.text = @"Show user location";
            
            [userTrackingSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        }
        case 3:
        {
            UISwitch *showTilesSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            showTilesSwitch.onTintColor = [MBBCommon tintColor];
            
            showTilesSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"showTilesEnabled"];
            
            showTilesSwitch.tag = 3;
            
            cell.accessoryView = showTilesSwitch;
            
            cell.textLabel.text = @"Tile borders & labels";
            
            [showTilesSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return cell;
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && ! [MBBCommon isRetinaCapable])
        return 0;
    
    return [tableView sectionHeaderHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%@", indexPath);
}

@end