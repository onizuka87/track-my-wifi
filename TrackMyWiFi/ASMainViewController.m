//
//  ASMainViewController.m
//  TrackMyWiFi
//
//  Created by Pietro Sacco on 14.01.14.
//  Copyright (c) 2014 Pietro Sacco. All rights reserved.
//

#import "ASMainViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Reachability.h"

@interface ASMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startTrackingButton;
@property (strong, nonatomic) NSString *selectedWifiName;
@property (strong, nonatomic) NSMutableArray *log;
@property (weak, nonatomic) IBOutlet UITableView *trackedWifiTableView;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL isConnected;

@end

@implementation ASMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self startStandardUpdates];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.startTrackingButton.titleLabel.text = [NSString stringWithFormat:@"Track %@", [self fetchSSIDInfo]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(ASFlipsideViewController *)controller withSelectedWifis:(NSArray *)list
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
        _selectedWifiName = [list firstObject];
        NSString *string = [[NSString stringWithFormat:@"ON  %@", [NSDate date].description] substringToIndex:20];
        _log = [NSMutableArray arrayWithObject:string];
        [_trackedWifiTableView reloadData];
        _isConnected = true;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
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


#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackedWifiCell"];
    
    cell.textLabel.text = [_log objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_log count];
}


#pragma mark - Private methods

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // Set a movement threshold for new events.
    _locationManager.distanceFilter = 25; // meters
    
    [_locationManager startUpdatingLocation];
}


#pragma mark - Location manager delegate

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];

    
    // If the event is recent, do something with it.
    //NSLog(@"latitude %+.6f, longitude %+.6f\n", location.coordinate.latitude, location.coordinate.longitude);
    
    if ([_selectedWifiName isEqualToString:[self fetchSSIDInfo]]) {
        if (!_isConnected) {
            _isConnected = YES;
            NSString *string = [[NSString stringWithFormat:@"ON  %@", [NSDate date].description] substringToIndex:20];
            [_log addObject:string];
            [_trackedWifiTableView reloadData];
            NSLog(@"%@", string);
        }
    } else {
        if (_isConnected) {
            _isConnected = NO;
            NSString *string = [[NSString stringWithFormat:@"OFF %@", [NSDate date].description] substringToIndex:20];
            [_log addObject:string];
            [_trackedWifiTableView reloadData];
            NSLog(@"OFF %@", [NSDate date].description);
        }
    }
}
@end
