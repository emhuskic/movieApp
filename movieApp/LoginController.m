//
//  LoginController.m
//  movieApp
//
//  Created by Adis Cehajic on 27/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "LoginController.h"
#import "MOVUser.h"
#import "MOVMovie.h"
#import "movieApp-Swift.h"
#import "LoadingView.h"
#import "Reachability.h"
@class AccountController;
@interface LoginController()
@property (weak, nonatomic) IBOutlet LoadingView *activityimage;
@property (strong, nonatomic) MOVUser *user;
@property (strong, nonatomic) NSArray *ratedMovies;

@property BOOL errorOccured;
@end
@implementation LoginController

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

    self.passwordTextField.secureTextEntry = YES;
    [self.activityimage setHidden:YES];
    self.errorOccured=NO;
}
- (IBAction)loginButtonTapped:(id)sender {
    if(self.usernameTextField.hasText && self.passwordTextField.hasText)
    {
    NSString *username=self.usernameTextField.text;
    NSString *password=self.passwordTextField.text;
  if(!self.user) self.user=[[MOVUser alloc] init];
    self.user.password=password;
    self.user.username=username;
    NSLog(@"Username: %@, password: %@", username, password);
         self.progressLabel.text=@"Logging in...";
        [self.activityimage setHidden:NO];
        [LoadingView rotateLayerInfinite:self.activityimage.layer];
    [self getRequestToken];
           }
    else
    {
        self.progressLabel.text=@"Username/Password field empty";
    }
}


- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}
- (void) getRequestToken
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    //IMAGES MAPPING
    RKObjectMapping* movieMapping2 = [RKObjectMapping mappingForClass:[MOVUser class]];
    [movieMapping2 addAttributeMappingsFromDictionary:@{
                                                        @"request_token":@"requestToken"
                                                        }];
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping2 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/authentication/token/new"]  keyPath:@"" statusCodes:statusCodes];
    RKObjectManager *sharedManager2 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager2 addResponseDescriptorsFromArray:@[responseDescriptor2]];
    [ sharedManager2 getObjectsAtPath:[NSString stringWithFormat:@"/3/authentication/token/new"]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  self.user.requestToken=[[[mappingResult array] firstObject] requestToken];
                                  [self loginWithToken];
                                  self.errorOccured=NO;
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              self.progressLabel.text=[NSString stringWithFormat:@"Error while trying to get Request Token" ];
                                  self.errorOccured=YES;
                                  [[[self activityimage] layer] removeAllAnimations];
                              }];
}
- (void) loginWithToken
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    //IMAGES MAPPING
    RKObjectMapping* movieMapping2 = [RKObjectMapping mappingForClass:[MOVUser class]];
    [movieMapping2 addAttributeMappingsFromDictionary:@{
                                                        @"request_token":@"requestToken"
                                                        }];
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping2 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/authentication/token/validate_with_login"]  keyPath:@"" statusCodes:statusCodes];
    RKObjectManager *sharedManager2 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager2 addResponseDescriptorsFromArray:@[responseDescriptor2]];
    [ sharedManager2 getObjectsAtPath:[NSString stringWithFormat:@"/3/authentication/token/validate_with_login"]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825", @"request_token": [NSString stringWithFormat:@"%@", self.user.requestToken], @"username":self.user.username, @"password":self.user.password}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  self.user.requestToken=[[[mappingResult array] firstObject] requestToken];
                                  [self getSessionID];
                                  self.errorOccured=NO;
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                  self.progressLabel.text=[NSString stringWithFormat:@"Error while trying to validate login"];
                                  [[[self activityimage] layer] removeAllAnimations];
                                  self.errorOccured=YES;
                                 
                              }];
}

- (void) getSessionID
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    //IMAGES MAPPING
    RKObjectMapping* movieMapping2 = [RKObjectMapping mappingForClass:[MOVUser class]];
    [movieMapping2 addAttributeMappingsFromDictionary:@{
                                                        @"session_id":@"sessionID"
                                                        }];
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping2 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/authentication/session/new"]  keyPath:@"" statusCodes:statusCodes];
    RKObjectManager *sharedManager2 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager2 addResponseDescriptorsFromArray:@[responseDescriptor2]];
    [ sharedManager2 getObjectsAtPath:[NSString stringWithFormat:@"/3/authentication/session/new"]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825", @"request_token": [NSString stringWithFormat:@"%@", self.user.requestToken]}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  self.user.sessionID=[[[mappingResult array] firstObject] sessionID];
                                  [self getUserID];
                                  self.errorOccured=NO;
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              self.progressLabel.text=[NSString stringWithFormat:@"Error while trying to get Session ID"];
                                  self.errorOccured=YES;
                                  [[[self activityimage] layer] removeAllAnimations];

                              }];
}

- (void) getUserID
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    //IMAGES MAPPING
    RKObjectMapping* movieMapping2 = [RKObjectMapping mappingForClass:[MOVUser class]];
    [movieMapping2 addAttributeMappingsFromDictionary:@{
                                                        @"id":@"userID",
                                                        @"name":@"name"
                                                        }];
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping2 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/account"]  keyPath:@"" statusCodes:statusCodes];
    RKObjectManager *sharedManager2 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager2 addResponseDescriptorsFromArray:@[responseDescriptor2]];
    [ sharedManager2 getObjectsAtPath:[NSString stringWithFormat:@"/3/account"]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825", @"session_id": [NSString stringWithFormat:@"%@", self.user.sessionID]}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  self.user.userID=[[[mappingResult array] firstObject] userID];
                                  self.user.name=[[[mappingResult array] firstObject] name];
                                  [self getFavoriteMovies];
                                  self.errorOccured=NO;
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                  self.progressLabel.text=[NSString stringWithFormat:@"Error while trying to get User ID" ];
                                  self.errorOccured=YES;
                                  [[[self activityimage] layer] removeAllAnimations];

                              }];

}
- (void) getFavoriteMovies
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    //IMAGES MAPPING
    RKObjectMapping* movieMapping2 = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping2 addAttributeMappingsFromDictionary:@{
                                                        @"original_title":@"originalTitle",
                                                        @"title":@"title",
                                                        @"release_date":@"releaseDate",
                                                        @"poster_path":@"posterPath",
                                                        @"backdrop_path":@"backdropPath",
                                                        @"vote_average":@"voteAverage",
                                                        @"vote_count":@"voteCount",
                                                        @"rating":@"userRating",
                                                        @"id":@"movID"
                                                        }];
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping2 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/account/%@/rated/movies", self.user.userID]  keyPath:@"results" statusCodes:statusCodes];
    RKObjectManager *sharedManager2 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager2 addResponseDescriptorsFromArray:@[responseDescriptor2]];
    [ sharedManager2 getObjectsAtPath:[NSString stringWithFormat:@"/3/account/%@/rated/movies", self.user.userID]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825", @"session_id": [NSString stringWithFormat:@"%@", self.user.sessionID]}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  self.ratedMovies=[mappingResult array];
                                  [self loginComplete];
                                  self.errorOccured=NO;
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                  self.progressLabel.text=[NSString stringWithFormat:@"Error while trying to get User's Favorite Movies"];
                                  self.errorOccured=YES;
                                  [[[self activityimage] layer] removeAllAnimations];

                              }];
}
- (void) loginComplete
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogInSuccessful" object:self];
    self.progressLabel.text=@"Login Successful";
    NSDictionary *dict = @{@"ratedMovies" : self.ratedMovies};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MoviesAreRated"
                                                        object:self
                                                      userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoggedIn"
                                                        object:self
                                                      userInfo:nil];
   [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"backToLogin"]) {
        AccountController *controller = (AccountController *)[segue destinationViewController];
        controller.loggedIn=true;
}
}
@end
