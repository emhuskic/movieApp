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
        NSLog(@"%@",uniqueIdentifier);
        // Launch Detail controller
        MOVDetailController *detailVC = [[MOVDetailController alloc] init];
        
        [(UINavigationController *)self.window.rootViewController pushViewController:detailVC animated:YES];
    }
    return YES;
}
/*
- (void) imageCaching
{
    static NSString *XXImageFormatNameUserThumbnailSmall = @"com.mycompany.myapp.XXImageFormatNameUserThumbnailSmall";
    static NSString *XXImageFormatNameUserThumbnailMedium = @"com.mycompany.myapp.XXImageFormatNameUserThumbnailMedium";
    static NSString *XXImageFormatFamilyUserThumbnails = @"com.mycompany.myapp.XXImageFormatFamilyUserThumbnails";
    
    FICImageFormat *smallUserThumbnailImageFormat = [[FICImageFormat alloc] init];
    smallUserThumbnailImageFormat.name = XXImageFormatNameUserThumbnailSmall;
    smallUserThumbnailImageFormat.family = XXImageFormatFamilyUserThumbnails;
    smallUserThumbnailImageFormat.style = FICImageFormatStyle16BitBGR;
    smallUserThumbnailImageFormat.imageSize = CGSizeMake(50, 50);
    smallUserThumbnailImageFormat.maximumCount = 250;
    smallUserThumbnailImageFormat.devices = FICImageFormatDevicePhone;
    smallUserThumbnailImageFormat.protectionMode = FICImageFormatProtectionModeNone;
    
    FICImageFormat *mediumUserThumbnailImageFormat = [[FICImageFormat alloc] init];
    mediumUserThumbnailImageFormat.name = XXImageFormatNameUserThumbnailMedium;
    mediumUserThumbnailImageFormat.family = XXImageFormatFamilyUserThumbnails;
    mediumUserThumbnailImageFormat.style = FICImageFormatStyle32BitBGRA;
    mediumUserThumbnailImageFormat.imageSize = CGSizeMake(100, 100);
    mediumUserThumbnailImageFormat.maximumCount = 250;
    mediumUserThumbnailImageFormat.devices = FICImageFormatDevicePhone;
    mediumUserThumbnailImageFormat.protectionMode = FICImageFormatProtectionModeNone;
    
    NSArray *imageFormats = @[smallUserThumbnailImageFormat, mediumUserThumbnailImageFormat];
    FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
    sharedImageCache.delegate = self;
    sharedImageCache.formats = imageFormats;
}

- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {
    // Images typically come from the Internet rather than from the app bundle directly, so this would be the place to fire off a network request to download the image.
    // For the purposes of this demo app, we'll just access images stored locally on disk.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *sourceImage = [(MOVMovie*)entity posterPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sourceImage);
        });
    });
}
*/

- (void)configureRestKit
{
    
        // initialize AFNetworking HTTPClient
     
  //  [objectManager addResponseDescriptorsFromArray:@[responseDescriptor]];
   /*
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.themoviedb.org"]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    [operation start];*/

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    //UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    //navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    //splitViewController.delegate = self;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
