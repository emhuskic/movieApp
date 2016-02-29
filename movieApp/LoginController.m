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
@class AccountController;
@interface LoginController()
@property (strong, nonatomic) MOVUser *user;
@property (strong, nonatomic) NSArray *ratedMovies;
@end
@implementation LoginController
- (void) viewWillAppear:(BOOL)animated
{
    self.passwordTextField.secureTextEntry = YES;
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
    [self getRequestToken];
        
    }
    else
    {
        self.progressLabel.text=@"Username/Password field empty";
    }
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
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              self.progressLabel.text=[NSString stringWithFormat:@"Error while trying to get Request Token" ];
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
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              self.progressLabel.text=[NSString stringWithFormat:@"Error while trying to validate login"];
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
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              self.progressLabel.text=[NSString stringWithFormat:@"Error while trying to get Session ID"];
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
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                  self.progressLabel.text=[NSString stringWithFormat:@"Error while trying to get User ID" ];
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
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                  self.progressLabel.text=[NSString stringWithFormat:@"Error while trying to get User's Favorite Movies"];
                                  
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
