//
//  MBBOptionsViewController.m
//  MapBox Bench
//
//  Created by Justin Miller on 6/20/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import "MBBOptionsViewController.h"

#import "MBBCommon.h"

#define MBBSectionCount 8;

typedef enum {
    MBBSectionRetina               = 0,
    MBBSectionConcurrencyMethod    = 1,
    MBBSectionConcurrencyOptions   = 2,
    MBBSectionUserLocationServices = 3,
    MBBSectionDebugging            = 4,
    MBBSectionTileJSON             = 5,
    MBBSectionMapKit               = 6,
    MBBSectionLatency              = 7,
} MBBSection;

typedef enum {
    MBBSwitchRetina       = 0,
    MBBSwitchUserTracking = 1,
    MBBSwitchCenterMap    = 2,
    MBBSwitchShowTiles    = 3,
    MBBSwitchUseMapKit    = 4,
} MBBSwitch;

typedef enum {
    MBBAlertConcurrencyPrefetch          = 0,
    MBBAlertConcurrencyMaxOps            = 1,
    MBBAlertConcurrencyMissingTilesDepth = 2,
    MBBAlertTileJSON                     = 3,
    MBBAlertLatency                      = 4,
} MBBAlert;

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MBBOptionsDismissedNotification object:self];
}

#pragma mark -

- (void)toggleSwitch:(UISwitch *)sender
{
    NSString *defaultName;
    
    switch (sender.tag)
    {
        case MBBSwitchRetina:
        {
            defaultName = MBBDefaultsKeyRetinaEnabled;
            
            break;
        }
        case MBBSwitchUserTracking:
        {
            defaultName = MBBDefaultsKeyShowUserLocation;
            
            if ( ! sender.on)
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MBBDefaultsKeyCenterUserLocation];
                [((UISwitch *)[self.tableView viewWithTag:MBBSwitchCenterMap]) setOn:NO animated:YES];
            }

            break;
        }
        case MBBSwitchCenterMap:
        {
            defaultName = MBBDefaultsKeyCenterUserLocation;

            if (sender.on)
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MBBDefaultsKeyShowUserLocation];
                [((UISwitch *)[self.tableView viewWithTag:MBBSwitchUserTracking]) setOn:YES animated:YES];
            }
            
            break;
        }
        case MBBSwitchShowTiles:
        {
            defaultName = MBBDefaultsKeyDebugTiles;
            
            break;
        }
        case MBBSwitchUseMapKit:
        {
            defaultName = MBBDefaultsKeyShowMapKit;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue(), ^(void)
            {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.tableView numberOfSections])] withRowAnimation:UITableViewRowAnimationFade];
            });
            
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MBBSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case MBBSectionRetina:
        {
            return ([MBBCommon isRetinaCapable] ? 1 : 0);
        }
        case MBBSectionConcurrencyMethod:
        {
            return 3;
        }
        case MBBSectionConcurrencyOptions:
        {
            return 3;
        }
        case MBBSectionUserLocationServices:
        {
            return 2;
        }
        case MBBSectionDebugging:
        {
            return 1;
        }
        case MBBSectionTileJSON:
        {
            return 1;
        }
        case MBBSectionMapKit:
        {
            return 1;
        }
        case MBBSectionLatency:
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
        case MBBSectionRetina:
        {
            return @"Retina";
        }
        case MBBSectionConcurrencyMethod:
        {
            return @"Concurrency";
        }
        case MBBSectionConcurrencyOptions:
        {
            return @"Concurrency Options";
        }
        case MBBSectionUserLocationServices:
        {
            return @"User Location Services";
        }
        case MBBSectionDebugging:
        {
            return @"Debugging";
        }
        case MBBSectionTileJSON:
        {
            return @"TileJSON URL";
        }
        case MBBSectionMapKit:
        {
            return @"MapKit Debug Layer";
        }
        case MBBSectionLatency:
        {
            return @"Artificial latency";
        }
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    switch (indexPath.section)
    {
        case MBBSectionRetina:
        {
            UISwitch *retinaSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            retinaSwitch.onTintColor = [MBBCommon tintColor];
            
            retinaSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:MBBDefaultsKeyRetinaEnabled];
            
            retinaSwitch.tag = MBBSwitchRetina;
            
            cell.accessoryView = retinaSwitch;
            
            cell.textLabel.text = @"Use retina tiles";
            
            [retinaSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        }
        case MBBSectionConcurrencyMethod:
        {
            int concurrencyMethod = [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyConcurrencyMethod];
            
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"Production default";
                    cell.accessoryType  = (concurrencyMethod == MBBConcurrencyMethodProduction ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);

                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"Asynchronous prefetch";
                    cell.accessoryType  = (concurrencyMethod == MBBConcurrencyMethodAsynchronousPrefetch ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);

                    break;
                }
                case 2:
                {
                    cell.textLabel.text = @"Asynchronous redraw";
                    cell.accessoryType = (concurrencyMethod == MBBConcurrencyMethodAsynchronousRedraw ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
                    
                    break;
                }
            }
            
            break;
        }
        case MBBSectionConcurrencyOptions:
        {
            if (indexPath.row == 0)
            {
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                
                cell.textLabel.text = [NSString stringWithFormat:@"Prefetch Radius: %i", [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyPrefetchTileRadius]];
            }
            else if (indexPath.row == 1)
            {
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                
                cell.textLabel.text = [NSString stringWithFormat:@"Max Concurrency: %i", [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyMaxConcurrentOperations]];
            }
            else if (indexPath.row == 2)
            {
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                
                cell.textLabel.text = [NSString stringWithFormat:@"Missing tiles depth: %i", [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyMissingTilesDepth]];
            }
            
            break;
        }
        case MBBSectionUserLocationServices:
        {
            if (indexPath.row == 0)
            {
                UISwitch *userTrackingSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                
                userTrackingSwitch.onTintColor = [MBBCommon tintColor];
                
                userTrackingSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:MBBDefaultsKeyShowUserLocation];
                
                userTrackingSwitch.tag = MBBSwitchUserTracking;
                
                cell.accessoryView = userTrackingSwitch;
                
                cell.textLabel.text = @"Show user location";
                
                [userTrackingSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (indexPath.row == 1)
            {
                UISwitch *centerMapSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                
                centerMapSwitch.onTintColor = [MBBCommon tintColor];
                
                centerMapSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:MBBDefaultsKeyCenterUserLocation];
                
                centerMapSwitch.tag = MBBSwitchCenterMap;
                
                cell.accessoryView = centerMapSwitch;
                
                cell.textLabel.text = @"Center on user location";
                
                [centerMapSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            break;
        }
        case MBBSectionDebugging:
        {
            UISwitch *showTilesSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            showTilesSwitch.onTintColor = [MBBCommon tintColor];
            
            showTilesSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:MBBDefaultsKeyDebugTiles];
            
            showTilesSwitch.tag = MBBSwitchShowTiles;
            
            cell.accessoryView = showTilesSwitch;
            
            cell.textLabel.text = @"Tile borders & labels";
            
            [showTilesSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        }
        case MBBSectionTileJSON:
        {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            if ([[NSUserDefaults standardUserDefaults] URLForKey:MBBDefaultsKeyTileJSONURL])
                cell.textLabel.text = [[[NSUserDefaults standardUserDefaults] URLForKey:MBBDefaultsKeyTileJSONURL] absoluteString];
            else
                cell.textLabel.text = @"Production MapBox Streets";
            
            cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
            
            break;
        }
        case MBBSectionMapKit:
        {
            UISwitch *useMapKitSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            useMapKitSwitch.onTintColor = [MBBCommon tintColor];
            
            useMapKitSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:MBBDefaultsKeyShowMapKit];
            
            useMapKitSwitch.tag = MBBSwitchUseMapKit;
            
            cell.accessoryView = useMapKitSwitch;
            
            cell.textLabel.text = @"Show MapKit";
            
            [useMapKitSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        }
        case MBBSectionLatency:
        {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            if ([[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyLatency])
                cell.textLabel.text = [NSString stringWithFormat:@"%ims", [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyLatency]];
            else
                cell.textLabel.text = @"None";
                        
            break;
        }
    }
    
    if ([cell.accessoryView isKindOfClass:[UISwitch class]])
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = [MBBCommon tintColor];
    
    return cell;
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == MBBSectionRetina && ! [MBBCommon isRetinaCapable])
        return 0;

    if (section == MBBSectionConcurrencyOptions && [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyConcurrencyMethod] != MBBConcurrencyMethodAsynchronousPrefetch && [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyConcurrencyMethod] != MBBConcurrencyMethodAsynchronousRedraw)
        return 0;
    
    if (section != MBBSectionMapKit && section != MBBSectionUserLocationServices && [[NSUserDefaults standardUserDefaults] boolForKey:MBBDefaultsKeyShowMapKit])
        return 0;
    
    return [tableView sectionHeaderHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == MBBSectionConcurrencyOptions)
    {
        if (indexPath.row < 2 && [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyConcurrencyMethod] != MBBConcurrencyMethodAsynchronousPrefetch)
            return 0;
        
        if (indexPath.row == 2 && [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyConcurrencyMethod] != MBBConcurrencyMethodAsynchronousRedraw)
            return 0;
    }
    
    if (indexPath.section != MBBSectionMapKit && indexPath.section != MBBSectionUserLocationServices && [[NSUserDefaults standardUserDefaults] boolForKey:MBBDefaultsKeyShowMapKit])
        return 0;
    
    return [tableView rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case MBBSectionConcurrencyMethod:
        {
            if ( ! [[tableView cellForRowAtIndexPath:indexPath].textLabel.textColor isEqual:[UIColor lightGrayColor]])
            {
                [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:MBBDefaultsKeyConcurrencyMethod];
                [[NSUserDefaults standardUserDefaults] synchronize];

                [tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(MBBSectionConcurrencyMethod, 2)] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            break;
        }
        
        case MBBSectionConcurrencyOptions:
        {
            if (indexPath.row == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Prefetch Radius"
                                                                message:@"Enter a number of tiles or just select the default:"
                                                               delegate:self
                                                      cancelButtonTitle:[NSString stringWithFormat:@"Use Default (%i)", kDefaultTilePrefetchRadius]
                                                      otherButtonTitles:@"Use Entered", nil];
                
                alert.tag = MBBAlertConcurrencyPrefetch;
                
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                if ([[NSUserDefaults standardUserDefaults] objectForKey:MBBDefaultsKeyPrefetchTileRadius])
                    [alert textFieldAtIndex:0].text = [NSString stringWithFormat:@"%i", [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyPrefetchTileRadius]];
                
                [alert show];
            }
            else if (indexPath.row == 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Max Concurrency"
                                                                message:@"Enter a number of threads or just select the default:"
                                                               delegate:self
                                                      cancelButtonTitle:[NSString stringWithFormat:@"Use Default (%i)", kDefaultMaxConcurrentOps]
                                                      otherButtonTitles:@"Use Entered", nil];
                
                alert.tag = MBBAlertConcurrencyMaxOps;
                
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                if ([[NSUserDefaults standardUserDefaults] objectForKey:MBBDefaultsKeyMaxConcurrentOperations])
                    [alert textFieldAtIndex:0].text = [NSString stringWithFormat:@"%i", [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyMaxConcurrentOperations]];
                
                [alert show];
            }
            else if (indexPath.row == 2)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Tiles Depth"
                                                                message:@"Enter a number of zoom levels or just select the default:"
                                                               delegate:self
                                                      cancelButtonTitle:[NSString stringWithFormat:@"Use Default (%i)", kDefaultMissingTilesDepth]
                                                      otherButtonTitles:@"Use Entered", nil];
                
                alert.tag = MBBAlertConcurrencyMissingTilesDepth;
                
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                if ([[NSUserDefaults standardUserDefaults] objectForKey:MBBDefaultsKeyMissingTilesDepth])
                    [alert textFieldAtIndex:0].text = [NSString stringWithFormat:@"%i", [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyMissingTilesDepth]];
                
                [alert show];
            }
            
            break;
        }
            
        case MBBSectionTileJSON:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TileJSON URL"
                                                            message:@"Enter a custom TileJSON URL or just select the default:"
                                                           delegate:self
                                                  cancelButtonTitle:@"Use Default"
                                                  otherButtonTitles:@"Use Entered", nil];
            
            alert.tag = MBBAlertTileJSON;
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            if ([[NSUserDefaults standardUserDefaults] URLForKey:MBBDefaultsKeyTileJSONURL])
                [alert textFieldAtIndex:0].text = [[[NSUserDefaults standardUserDefaults] URLForKey:MBBDefaultsKeyTileJSONURL] absoluteString];
            
            [alert show];
            
            break;
        }
        case MBBSectionLatency:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Artificial Latency"
                                                            message:@"Enter a value in milliseconds:"
                                                           delegate:self
                                                  cancelButtonTitle:@"None"
                                                  otherButtonTitles:@"Use Entered", nil];
            
            alert.tag = MBBAlertLatency;
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            if ([[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyLatency])
                [alert textFieldAtIndex:0].text = [NSString stringWithFormat:@"%i", [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyLatency]];
            
            [alert show];
            
            break;
        }
        default:
        {
            NSLog(@"%@", indexPath);
            
            break;
        }
    }    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == MBBAlertConcurrencyPrefetch)
    {
        if (buttonIndex == 0 && [[NSUserDefaults standardUserDefaults] objectForKey:MBBDefaultsKeyPrefetchTileRadius])
        {
            [[NSUserDefaults standardUserDefaults] setInteger:kDefaultTilePrefetchRadius forKey:MBBDefaultsKeyPrefetchTileRadius];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MBBSectionConcurrencyOptions] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (buttonIndex == 1 && [[alertView textFieldAtIndex:0].text length] && [[alertView textFieldAtIndex:0].text integerValue])
        {
            [[NSUserDefaults standardUserDefaults] setInteger:[[alertView textFieldAtIndex:0].text integerValue] forKey:MBBDefaultsKeyPrefetchTileRadius];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MBBSectionConcurrencyOptions] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (alertView.tag == MBBAlertConcurrencyMaxOps)
    {
        if (buttonIndex == 0 && [[NSUserDefaults standardUserDefaults] objectForKey:MBBDefaultsKeyMaxConcurrentOperations])
        {
            [[NSUserDefaults standardUserDefaults] setInteger:kDefaultMaxConcurrentOps forKey:MBBDefaultsKeyMaxConcurrentOperations];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MBBSectionConcurrencyOptions] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (buttonIndex == 1 && [[alertView textFieldAtIndex:0].text length] && [[alertView textFieldAtIndex:0].text integerValue])
        {
            [[NSUserDefaults standardUserDefaults] setInteger:[[alertView textFieldAtIndex:0].text integerValue] forKey:MBBDefaultsKeyMaxConcurrentOperations];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MBBSectionConcurrencyOptions] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (alertView.tag == MBBAlertConcurrencyMissingTilesDepth)
    {
        if (buttonIndex == 0 && [[NSUserDefaults standardUserDefaults] objectForKey:MBBDefaultsKeyMissingTilesDepth])
        {
            [[NSUserDefaults standardUserDefaults] setInteger:kDefaultMissingTilesDepth forKey:MBBDefaultsKeyMissingTilesDepth];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MBBSectionConcurrencyOptions] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (buttonIndex == 1 && [[alertView textFieldAtIndex:0].text length] && [[alertView textFieldAtIndex:0].text integerValue])
        {
            [[NSUserDefaults standardUserDefaults] setInteger:[[alertView textFieldAtIndex:0].text integerValue] forKey:MBBDefaultsKeyMissingTilesDepth];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MBBSectionConcurrencyOptions] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (alertView.tag == MBBAlertTileJSON)
    {
        if (buttonIndex == 0 && [[NSUserDefaults standardUserDefaults] URLForKey:MBBDefaultsKeyTileJSONURL])
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:MBBDefaultsKeyTileJSONURL];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MBBSectionTileJSON] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (buttonIndex == 1 && [[alertView textFieldAtIndex:0].text length] && [NSURL URLWithString:[alertView textFieldAtIndex:0].text])
        {
            [[NSUserDefaults standardUserDefaults] setURL:[NSURL URLWithString:[alertView textFieldAtIndex:0].text] forKey:MBBDefaultsKeyTileJSONURL];
            [[NSUserDefaults standardUserDefaults] synchronize];
        
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MBBSectionTileJSON] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (alertView.tag == MBBAlertLatency)
    {
        if (buttonIndex == 0 && [[NSUserDefaults standardUserDefaults] integerForKey:MBBDefaultsKeyLatency])
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:MBBDefaultsKeyLatency];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MBBSectionLatency] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (buttonIndex == 1 && [[alertView textFieldAtIndex:0].text length] && [[alertView textFieldAtIndex:0].text integerValue])
        {
            [[NSUserDefaults standardUserDefaults] setInteger:[[alertView textFieldAtIndex:0].text integerValue] forKey:MBBDefaultsKeyLatency];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MBBSectionLatency] withRowAnimation:UITableViewRowAnimationFade];
        }        
    }
}

@end