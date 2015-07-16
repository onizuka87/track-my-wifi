//
//  ASFlipsideViewController.m
//  TrackMyWiFi
//
//  Created by Pietro Sacco on 14.01.14.
//  Copyright (c) 2014 Pietro Sacco. All rights reserved.
//

#import "ASFlipsideViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Reachability.h"

@interface ASFlipsideViewController ()

@property (nonatomic) NSArray *wifiList;
@property (nonatomic) NSArray *selectedWifiList;
@property (weak, nonatomic) IBOutlet UITableView *wifiListTableView;

- (IBAction)refreshButtonAction:(id)sender;

@end

@implementation ASFlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshButtonAction:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    //NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return [info valueForKey:@"SSID"];
}


#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self withSelectedWifis:_wifiList];
}

- (IBAction)refreshButtonAction:(id)sender
{
    if ([self fetchSSIDInfo]) {
        _wifiList = [NSArray arrayWithObject:[self fetchSSIDInfo]];
    } else {
        _wifiList = [NSArray array];
    }
    [_wifiListTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = [_wifiList objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_wifiList count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end
