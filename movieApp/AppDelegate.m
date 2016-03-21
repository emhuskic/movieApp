//
//  AppDelegate.m
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import <CoreSpotlight/CoreSpotlight.h>
#import "MOVMovie.h"
#import "MOVDetailController.h"
#import "FavoritesController.h"
#import "movieApp-Swift.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@interface AppDelegate () <UISplitViewControllerDelegate>
- (void)configureRestKit;
- (void) imageCaching;
@end

@implementation AppDelegate
    - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler
{
    if ([[userActivity activityType] isEqualToString:CSSearchableItemActionType])
    {
        NSString *uniqueIdentifier = [userActivity.userInfo objectForKey:CSSearchableItemActivityIdentifier];
        NSLog(@"Unique identifier: %@",uniqueIdentifier);
        // Launch Detail controller
       
        if (self.activeFavorites)
        {
            [((FavoritesController *)[[((UINavigationController *)[[((UITabBarController *)self.window.rootViewController) viewControllers] objectAtIndex:1]) viewControllers] objectAtIndex:0]) detailsegue:uniqueIdentifier];
            
        }
        else if(self.activeMaster){
        [((MasterViewController *)[[((UINavigationController *)[[((UITabBarController *)self.window.rootViewController) viewControllers] objectAtIndex:0]) viewControllers] objectAtIndex:0]) detailsegue:uniqueIdentifier];
        }
        else
        {
             [((AccountController *)[[((UINavigationController *)[[((UITabBarController *)self.window.rootViewController) viewControllers] objectAtIndex:2]) viewControllers] objectAtIndex:0]) detailsegue:uniqueIdentifier];
        }
    }
    return YES;
}

-(void)updateBooleanMaster:(NSNotification *)notification
{
    if(self.activeMaster)
    self.activeMaster=false;
    else
        self.activeMaster=true;
    
}
- (void)updateBooleanFavorites:(NSNotification *)notification
{
    if(self.activeFavorites)
        self.activeFavorites=false;
    else
        self.activeFavorites=true;

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.activeMaster=false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBooleanMaster:) name:@"masterViewActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBooleanMaster:) name:@"masterViewInactive" object:nil];
    self.activeFavorites=false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBooleanFavorites:) name:@"favoritesViewActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBooleanFavorites:) name:@"favoritesViewInactive" object:nil];
    [Fabric with:@[[Crashlytics class]]];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    RLMArray<MOVRealmMovie*><MOVRealmMovie> *movs= [MOVRealmMovie allObjects];
    for (int i=0; i<movs.count; i++)
    {
        if([[movs objectAtIndex:i] releaseDate] > [NSDate date])
        {
            UILocalNotification *notification = [[UILocalNotification alloc]init];
            [notification setAlertBody:[NSString stringWithFormat:@"Premiere of %@ is in 24hours!", [[movs objectAtIndex:i] title]]];
            [notification setFireDate:[[[movs objectAtIndex:i] releaseDate] dateByAddingTimeInterval:60*60*24]];
            [notification setTimeZone:[NSTimeZone defaultTimeZone]];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

@end
