//
//  AppDelegate.h
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Restkit/Restkit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSURLSession *sharedSession;
@property (strong, nonatomic) NSString *requestToken;
@property int userID;

//- (NSURL *) tmdbURLFromParameters:(NSString *)parameters withPathExtension:(NSString *)PathExtension;

/*
var sharedSession = NSURLSession.sharedSession()
var requestToken: String? = nil
var sessionID: String? = nil
var userID: Int? = nil

// configuration for TheMovieDB, we'll take care of this for you =)...
var config = Config()

// MARK: UIApplicationDelegate

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    // if necessary, update the configuration...
    config.updateIfDaysSinceUpdateExceeds(7)
    
    return true
}
}

// MARK: Create URL from Parameters

extension AppDelegate {
    
    func tmdbURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.TMDB.ApiScheme
        components.host = Constants.TMDB.ApiHost
        components.path = Constants.TMDB.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
*/

@end

