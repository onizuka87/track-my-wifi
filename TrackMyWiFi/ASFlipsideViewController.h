//
//  ASFlipsideViewController.h
//  TrackMyWiFi
//
//  Created by Pietro Sacco on 14.01.14.
//  Copyright (c) 2014 Pietro Sacco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASFlipsideViewController;

@protocol ASFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(ASFlipsideViewController *)controller withSelectedWifis:(NSArray *)list;
@end

@interface ASFlipsideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <ASFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
