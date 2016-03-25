//
//  MOVVideosController.m
//  movieApp
//
//  Created by Adis Cehajic on 22/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVVideosController.h"
#import "Reachability.h"
@implementation MOVVideosController

- (BOOL) connectedToNetwork{
    Reachability* reachability = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    BOOL isInternet=YES;
    if(remoteHostStatus == NotReachable)
    {
        isInternet =NO;
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        isInternet = TRUE;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        isInternet = TRUE;
        
    }
    return isInternet;
}
- (void) viewWillAppear:(BOOL)animated
{
    BOOL connected=[self connectedToNetwork];
    if(!connected)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"This can't be true"
                                                                       message:@"This app needs internet, but you don't have it, please connect"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

}
- (void)viewDidLoad
{
    self.nameLabel.text=self.video.name;
    if(self.path)
    [self.playerView loadWithVideoId:self.path];
}
@end
