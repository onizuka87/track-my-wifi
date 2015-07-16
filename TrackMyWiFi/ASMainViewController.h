//
//  ASMainViewController.h
//  TrackMyWiFi
//
//  Created by Pietro Sacco on 14.01.14.
//  Copyright (c) 2014 Pietro Sacco. All rights reserved.
//

#import "ASFlipsideViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ASMainViewController : UIViewController <ASFlipsideViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@end
