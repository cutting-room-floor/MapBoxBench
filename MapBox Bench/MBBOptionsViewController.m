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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MBBOptionsDismissedNotification object:self];
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
            defaultName = @"centerMap";

            if (sender.on)
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userTrackingEnabled"];
                [((UISwitch *)[self.tableView viewWithTag:2]) setOn:YES animated:YES];
            }
            
            break;
        }
        case 4:
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
    return 5;
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
            return 2;
        }
        case 3:
        {
            return 1;
        }
        case 4:
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
        case 4:
        {
            return @"TileJSON URL";
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
            if (indexPath.row == 0)
            {
                UISwitch *userTrackingSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                
                userTrackingSwitch.onTintColor = [MBBCommon tintColor];
                
                userTrackingSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"userTrackingEnabled"];
                
                userTrackingSwitch.tag = 2;
                
                cell.accessoryView = userTrackingSwitch;
                
                cell.textLabel.text = @"Show user location";
                
                [userTrackingSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (indexPath.row == 1)
            {
                UISwitch *centerMapSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                
                centerMapSwitch.onTintColor = [MBBCommon tintColor];
                
                centerMapSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"centerMapEnabled"];
                
                centerMapSwitch.tag = 3;
                
                cell.accessoryView = centerMapSwitch;
                
                cell.textLabel.text = @"Center on user location";
                
                [centerMapSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            break;
        }
        case 3:
        {
            UISwitch *showTilesSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            showTilesSwitch.onTintColor = [MBBCommon tintColor];
            
            showTilesSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"showTilesEnabled"];
            
            showTilesSwitch.tag = 4;
            
            cell.accessoryView = showTilesSwitch;
            
            cell.textLabel.text = @"Tile borders & labels";
            
            [showTilesSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        }
        case 4:
        {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            if ([[NSUserDefaults standardUserDefaults] URLForKey:@"tileJSONURL"])
                cell.textLabel.text = [[[NSUserDefaults standardUserDefaults] URLForKey:@"tileJSONURL"] absoluteString];
            else
                cell.textLabel.text = @"Production MapBox Streets";
            
            cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
            
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
    if (section == 0 && ! [MBBCommon isRetinaCapable])
        return 0;
    
    return [tableView sectionHeaderHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 1:
        {
            NSLog(@"Concurrency option %i", indexPath.row + 1);
            
            break;
        }
        
        case 4:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TileJSON URL"
                                                            message:@"Enter a custom TileJSON URL to load or just select the default."
                                                           delegate:self
                                                  cancelButtonTitle:@"Use Default"
                                                  otherButtonTitles:@"Use Entered", nil];
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            if ([[NSUserDefaults standardUserDefaults] URLForKey:@"tileJSONURL"])
                [alert textFieldAtIndex:0].text = [[[NSUserDefaults standardUserDefaults] URLForKey:@"tileJSONURL"] absoluteString];
            
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
    if (indexPath.section == 4)
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && [[NSUserDefaults standardUserDefaults] URLForKey:@"tileJSONURL"])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tileJSONURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (buttonIndex == 1 && [[alertView textFieldAtIndex:0].text length] && [NSURL URLWithString:[alertView textFieldAtIndex:0].text])
    {
        [[NSUserDefaults standardUserDefaults] setURL:[NSURL URLWithString:[alertView textFieldAtIndex:0].text] forKey:@"tileJSONURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:4]] withRowAnimation:UITableViewRowAnimationFade];
}

@end