

//
//  MOVDetailController.m
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVDetailController.h"
#import "MOVMovie.h"
#import <RestKit/RestKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MOVPerson.h"
#import "MOVMovieCastCollectionViewCell.h"
#import "MOVUpperImageCell.h"
#import "MOVDescriptionTableViewCell.h"
#import "MOVRatingTableViewCell.h"
#import "MOVMovieCastTableViewCell.h"
#import "MOVCastController.h"
#import "MOVRealmMovie.h"
#import "NSString+FontAwesome.h"
#import "FavoritesController.h"
#import "MasterViewController.h"
#import "MOVVideosController.h"
#import "MOVVideo.h"
#import "MOVUser.h"
#import "MOVRealmVisitedMovie.h"
@interface MOVDetailController()
@property (strong, nonatomic) NSArray *cast;
@property (strong, nonatomic) MOVPerson *selectedCast;
@property (strong, nonatomic) MOVCastController *controller;
@property (strong, nonatomic) NSArray *videos;
@property (strong, nonatomic) MOVMovie *movs;
@property (nonatomic) BOOL loggedOut;
@property (strong, nonatomic) NSArray *ratedMovies;
@property (strong, nonatomic) NSString *sessionID;
@property (strong, nonatomic) NSNumber *userID;
@property BOOL readmore;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;

@property RLMRealm *realm;
@end

@implementation MOVDetailController

- (instancetype) init
{
    self = [super init];
    [self registerAsObserver];
    return self;
}

- (IBAction)postToFacebook:(id)sender {
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])  {
        NSLog(@"log output of your choice here");
    }
    // Facebook may not be available but the SLComposeViewController will handle the error for us.
    self.mySLComposerSheet = [[SLComposeViewController alloc] init];
    self.mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [self.mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Check out this movie:\n %@ \n", [self.movie title]]];
    
    NSURL * url= [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", self.movie.posterPath]];
        NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    [self.mySLComposerSheet addImage:image]; //an image you could post
    
    [self presentViewController:self.mySLComposerSheet animated:YES completion:nil];
    
    [self.mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        }
        if (![output isEqualToString:@"Action Cancelled"]) {
            // Only alert if the post was a success. Or not! Up to you.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }];
}


- (void) refreshDetail:(MasterViewController *)view
{
    [self.tableView reloadData];
}
- (void)selectCast:(MOVMovieCastTableViewCell *)view withItem:(MOVPerson *)item
{
    self.selectedCast=item;
    self.controller.persID=[item personID];
    [self performSegueWithIdentifier:@"castSegue" sender:self];
}
- (void)registerAsObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"MoviesAreRated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut:) name:@"LoggedOut" object:nil];
}
- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) updateView:(NSNotification*)notification
{
    self.ratedMovies=notification.userInfo[@"ratedMovies"];
    [[self tableView] reloadData];
}
- (void) logOut:(NSNotification*)notification
{
    self.ratedMovies=nil;
    self.loggedOut=YES;
    [[self tableView] reloadData];
}
- (void) loadUser
{
    
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    //IMAGES MAPPING
    RKObjectMapping* movieMapping2 = [RKObjectMapping mappingForClass:[MOVUser class]];
    [movieMapping2 addAttributeMappingsFromDictionary:@{
                                                        @"id":@"userID",
                                                        @"username":@"username"
                                                        }];
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping2 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/account"]  keyPath:@"" statusCodes:statusCodes];
    RKObjectManager *sharedManager2 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager2 addResponseDescriptorsFromArray:@[responseDescriptor2]];
    [ sharedManager2 getObjectsAtPath:[NSString stringWithFormat:@"/3/account"]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825", @"session_id" : [NSString stringWithFormat:@"%@",self.sessionID]}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  self.userID=[[mappingResult.array firstObject] userID];
                                  [self loadRatings];
                                  //[self configureView];
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              }];
    
}
- (void) loadRatings
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    //IMAGES MAPPING
    RKObjectMapping* movieMapping2 = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping2 addAttributeMappingsFromDictionary:@{
                                                        @"rating":@"userRating",
                                                        @"id": @"movID",
                                                        @"backdrop_path": @"backdropPath",
                                                        @"original_title": @"originalTitle",
                                                        @"poster_path": @"posterPath",
                                                        @"release_date": @"releaseDate",
                                                        @"title": @"title",
                                                        @"vote_count": @"voteCount",
                                                        @"vote_average": @"voteAverage"
                                                        
                                                        }];
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping2 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/account/%@/rated/movies", self.userID]  keyPath:@"results" statusCodes:statusCodes];
    RKObjectManager *sharedManager2 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager2 addResponseDescriptorsFromArray:@[responseDescriptor2]];
    [ sharedManager2 getObjectsAtPath:[NSString stringWithFormat:@"/3/account/%@/rated/movies", self.userID]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825", @"session_id" : [NSString stringWithFormat:@"%@",self.sessionID]}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  self.ratedMovies=mappingResult.array;
                                  [[self tableView] reloadData];
                                  //[self configureView];
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              }];
    
}
- (void) loadGenres
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectMapping* movieMapping = [RKObjectMapping mappingForClass:[MOVGenre class]];
    [movieMapping addAttributeMappingsFromDictionary:@{
                                                       @"id":@"genreID",
                                                       @"name":@"name"
                                                       }];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/genre/movie/list"]  keyPath:@"genres" statusCodes:statusCodes];
    
    RKObjectManager *sharedManager = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager addResponseDescriptorsFromArray:@[responseDescriptor]];
    [ sharedManager getObjectsAtPath:[NSString stringWithFormat:@"/3/genre/movie/list"]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                 self.genres=mappingResult.array;
                                 [[self tableView] reloadData];
                             }
                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                             }];
    
}
- (void) loadVideos
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectMapping* movieMapping = [RKObjectMapping mappingForClass:[MOVVideo class]];
    [movieMapping addAttributeMappingsFromDictionary:@{
                                                       @"key": @"key",
                                                       @"site": @"site",
                                                       @"size": @"size",
                                                       @"type": @"type",
                                                       @"name": @"name"
                                                       }];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/movie/%@/videos",self.movie.movID]  keyPath:@"results" statusCodes:statusCodes];
    
    RKObjectManager *sharedManager = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager addResponseDescriptorsFromArray:@[responseDescriptor]];
    [ sharedManager getObjectsAtPath:[NSString stringWithFormat:@"/3/movie/%@/videos",self.movie.movID]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                 NSLog(@"prije dodjele count videos je %ld", self.videos.count);
                                 self.videos=mappingResult.array;
                                 NSLog(@"poslije dodjele count videos je: %ld", self.videos.count);
                             }
                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                             }];
    
}
- (void) loadCast
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectMapping* movieMapping = [RKObjectMapping mappingForClass:[MOVPerson class]];
    [movieMapping addAttributeMappingsFromDictionary:@{
                                                       @"cast_id": @"castID",
                                                       @"character": @"character",
                                                       @"credit_id": @"creditID",
                                                       @"id": @"personID",
                                                       @"name": @"name",
                                                       @"order": @"order",
                                                       @"profile_path": @"profilePath"
                                                       
                                                       }];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/movie/%@/credits",self.movie.movID]  keyPath:@"cast" statusCodes:statusCodes];
    
    RKObjectManager *sharedManager = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager addResponseDescriptorsFromArray:@[responseDescriptor]];
    [ sharedManager getObjectsAtPath:[NSString stringWithFormat:@"/3/movie/%@/credits",self.movie.movID]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                 NSLog(@"prije dodjele je %ld", self.cast.count);
                                 self.cast=mappingResult.array;
                                 NSLog(@"poslije dodjele count je: %ld", self.cast.count);
                                 [self.tableView reloadData];
                             }
                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                             }];
}

- (void) loadMovie
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectMapping* movieMapping = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping addAttributeMappingsFromDictionary:@{
                                                       @"runtime":@"runtime",
                                                       @"id":@"movID"
                                                       
                                                       }];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/movie/%@",self.movie.movID]  keyPath:@"" statusCodes:statusCodes];
    
    RKObjectManager *sharedManager = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager addResponseDescriptorsFromArray:@[responseDescriptor]];
    [ sharedManager getObjectsAtPath:[NSString stringWithFormat:@"/3/movie/%@",self.movie.movID]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                 self.movs=[mappingResult.array firstObject];
                                 [self.tableView reloadData];
                             }
                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                             }];
    
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if(self.movie){
    self.movie.lastVisited=[NSDate date];
    MOVRealmVisitedMovie *mov=[[MOVRealmVisitedMovie alloc]initWithMOVObject:self.movie];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title = %@",
                         [self.movie title]];
    RLMResults<MOVRealmVisitedMovie *> *movies=[MOVRealmVisitedMovie objectsWithPredicate:pred];
    
    if (movies.count)
    {
        RLMArray *arr = [[RLMArray alloc] initWithObjectClassName:@"MOVRealmVisitedMovie"];
        [arr addObjects:movies];
        [realm beginWriteTransaction];
        [realm deleteObject:[arr firstObject]];
        [realm addObject:mov];
        [realm commitWriteTransaction];
    }
    else
    {
        [realm beginWriteTransaction];
        [realm addObject:mov];
        [realm commitWriteTransaction];
    }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerAsObserver];
    [self loadVideos];
    [self loadGenres];
    [self loadMovie];
    self.realm = [RLMRealm defaultRealm];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.topViewController.title = [NSString stringWithFormat:@"%@", [self.movie title]];
    self.navigationController.navigationBar.hidden = NO;
    
    UITabBarController *tabBarController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController ;
    [tabBarController setDelegate:self];
    [self loadCast];
    UIImage *image = [UIImage imageNamed:@"HEARTicon.png"];
    [[[self.tabBarController.tabBar items] objectAtIndex:1 ] setImage: [self imageWithImage:image scaledToSize:CGSizeMake(30, 30)]];
    UIImage *image1 = [UIImage imageNamed:@"videocamicon.png"];
    [[[self.tabBarController.tabBar items] objectAtIndex:0 ] setImage: [self imageWithImage:image1 scaledToSize:CGSizeMake(30, 30)]];
    UIImage *image2 = [UIImage imageNamed:@"fa-user.png"];
    [[[self.tabBarController.tabBar items] objectAtIndex:2 ] setImage: [self imageWithImage:image2 scaledToSize:CGSizeMake(30, 30)]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:(NSWeekOfYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSWeekdayCalendarUnit) fromDate:[NSDate date]];
    NSLog(@"Datum je %@",dateComponent);
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogInSuccessful" object:dateComponent];
    NSDictionary *dict = @{@"weekday" : [NSNumber numberWithInt:dateComponent.weekday], @"weekOfYear":[NSNumber numberWithInt:dateComponent.weekOfYear]};
    self.movie.lastVisited=[NSDate date];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"movieViewed" object:nil userInfo:dict];
    [[self tableView] reloadData];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if([viewController.title isEqual:@"FavoritesNavigationController"])
    {
        UINavigationController *navController = (UINavigationController *)[tabBarController selectedViewController];
        FavoritesController *favcontroller=navController.viewControllers[0];
        [favcontroller.tableView reloadData];
    }
    else
    {
        UINavigationController *navController = (UINavigationController *)[tabBarController selectedViewController];
        MasterViewController *favcontroller=navController.viewControllers[0];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


-(void)infoButtonTapped:(UIButton *)button
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    [self addOrRemoveSelectedIndexPath:indexPath];
}

- (void)addOrRemoveSelectedIndexPath:(NSIndexPath *)indexPath
{
   if (!self.selectedIndexPaths) {
        self.selectedIndexPaths = [NSMutableArray new];
    }
//    
    BOOL containsIndexPath = [self.selectedIndexPaths containsObject:indexPath];
    
    if (containsIndexPath) {
        [self.selectedIndexPaths removeObject:indexPath];
    }else{        [self.selectedIndexPaths addObject:indexPath];
    }
    
    
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0)
    {
        static NSString *CellIdentifier = @"upperCell";
        MOVUpperImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MOVUpperImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //Upper image
        NSURL * url= [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w640", self.movie.backdropPath]];
       // NSData *data = [NSData dataWithContentsOfURL:url];
        //UIImage *cellimg=[UIImage imageWithData:data];
        if (self.movie.backdropPath)
        [cell.img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed: @"imgplaceholder.png"]];
        else
            cell.img.image=[UIImage imageNamed:@"imgplaceholder.png"];
        //cell.img.image = cellimg;
        // Get the Layer of any view
        
        //Title label
        cell.titleLabel.text = self.movie.title;
        //Duration label
        
        int hour = [[self.movs runtime] intValue] / 60;
        int min = [[self.movs runtime] intValue] % 60;
        
        NSString *timeString = [NSString stringWithFormat: @" %dh %02dmin|", hour, min];
        cell.durationLabel.text = [NSString stringWithFormat:@"%@",timeString];
        //Genre label
        for (int i=0; i<self.genres.count; i++)
        {
            if ([[[self.genres objectAtIndex:i] genreID] isEqual:(NSNumber*)[[self.movie genres] firstObject]] )
            {
                cell.genreLabel.text=[[self.genres objectAtIndex:i] name];
                break;
            }
        }
        
        //Year label
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self.movie releaseDate]];
        cell.yearLabel.text=[NSString stringWithFormat:@"(%ld)",(long)[components year]];
        
        //Favorites button
        [cell.favorite addTarget:self action:@selector(favoritesButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"title = %@",
                             [self.movie title]];
        RLMResults<MOVRealmMovie *> *dbmovies = [MOVRealmMovie objectsWithPredicate:pred];
        if(dbmovies.count)
            [cell.favorite setTitle:[NSString fontAwesomeIconStringForEnum:FAHeart] forState:UIControlStateNormal];
        else
            [cell.favorite setTitle:[NSString fontAwesomeIconStringForEnum:FAHeartO] forState:UIControlStateNormal];
        // bla bla bla
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.facebook setTitle:[NSString fontAwesomeIconStringForEnum:FAfacebookOfficial] forState:UIControlStateNormal];
        return cell;
        
    }
    
    else if (indexPath.row==1)
    {
        static NSString *CellIdentifier = @"descriptionCell";
        MOVDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MOVDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSURL * url= [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", self.movie.posterPath]];
       // NSData *data = [NSData dataWithContentsOfURL:url];
        //cell.img.image = [UIImage imageWithData:data];
        [cell.img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed: @"imgplaceholder.png"]];

        
        [cell.videosButton setTitle:[NSString stringWithFormat:@"%@ Videos",[NSString fontAwesomeIconStringForEnum:FAFilm]]forState:UIControlStateNormal];
        [cell.smallVideosButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAAngleRight]]forState:UIControlStateNormal];
        [cell.descriptionButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAInfoCircle]]forState:UIControlStateNormal];
        cell.descriptionLabel.text=[self.movie overview];
       [cell.smallVideosButton addTarget:self action:@selector(videosButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.videosButton addTarget:self action:@selector(videosButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        BOOL isSelected = [self.selectedIndexPaths containsObject:indexPath];
        cell.descriptionLabel.numberOfLines = isSelected?0:7;
        
       // cell.descriptionLabel.adjustsFontSizeToFitWidth=isSelected?YES:NO;
        [cell.descriptionButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.descriptionButton setTag:indexPath.row];

        return cell;
    }
    
    
    else if(indexPath.row==2)
    {
        static NSString *CellIdentifier = @"ratingCell";
        MOVRatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MOVRatingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.avgLabel.text=[NSString stringWithFormat:@"%@",[self.movie voteAverage]];
        cell.countLabel.text=[NSString stringWithFormat:@"%@", [self.movie voteCount]];
        cell.avg=self.movie.voteAverage;
        cell.rating=self.movie.userRating;
        if (self.loggedOut) cell.rating=0;
        else if (self.ratedMovies)
        {
            for (int i=0; i<[self.ratedMovies count]; i++)
            {
                if ([[[self.ratedMovies objectAtIndex:i] movID] isEqual:[self.movie movID]])
                {
                    cell.rating=[[self.ratedMovies objectAtIndex:i] userRating];
                    break;
                }
                else
                    cell.rating=0;
            }
        }
         [cell.ratingButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAAngleRight]]forState:UIControlStateNormal];
        [cell refresh];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"movieCastCell";
        MOVMovieCastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MOVMovieCastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.cast=self.cast;
        cell.delegate=self;
        [cell refreshCollection];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}
-(void)videosButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"videosSegue" sender:self];
}
@synthesize realm;
-(void)favoritesButtonTapped:(id)sender
{
    UIButton *button = (UIButton *) sender;
    int tag = [(UIButton *)sender tag];
    MOVRealmMovie *mov = [[MOVRealmMovie alloc] initWithMOVObject:self.movie];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title = %@",
                         [self.movie title]];
    RLMResults<MOVRealmMovie *> *movies = [MOVRealmMovie objectsWithPredicate:pred];
    if (movies.count)
    {
        RLMArray *arr = [[RLMArray alloc] initWithObjectClassName:@"MOVRealmMovie"];
        [arr addObjects:movies];
        [realm beginWriteTransaction];
        [realm deleteObject:[arr firstObject]];
        [realm commitWriteTransaction];
        [button.titleLabel setHidden:NO];
        NSString *str=[NSString fontAwesomeIconStringForEnum:FAHeartO];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTag:1];
        
        self.movie.isFavorite=NO;
        
    }
    else
    {
        [realm beginWriteTransaction];
        [realm addObject:mov];
        [realm commitWriteTransaction];
        self.movie.isFavorite=YES;
        [button.titleLabel setHidden:NO];
        NSString *str =[NSString fontAwesomeIconStringForEnum:FAHeart];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTag:2];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FavoritesUpdated" object:nil];
    [self.delegate updateFavorites:self];
    NSLog(@"tapped button in cell at row %i", tag);
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 202;
    }
    else if (indexPath.row==1)
    {
        BOOL isSelected = [self.selectedIndexPaths containsObject:indexPath];
        if(isSelected)
        {
       CGFloat maxHeight = MAXFLOAT;
        CGFloat minHeight = 135.0f;
        CGFloat constrainHeight = isSelected?maxHeight:minHeight;
        //CGFloat constrainWidth  = tableView.frame.size.width-50.0f;
        CGFloat constrainWidth=381.0f;
        NSString *text       = [self.movie overview];
        CGSize constrainSize = CGSizeMake(constrainWidth, constrainHeight);

            CGRect labelSizer     = [text boundingRectWithSize:constrainSize options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil];
            CGSize labelsize = [text sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:constrainSize];//sizeWithFont:[UIFont systemFontOfSize:20.0f]
                                //constrainedToSize:constrainSize
                                    //lineBreakMode:NSLineBreakByCharWrapping];
            CGFloat height = [self calculateHeightOfLabel:text ofFont:[UIFont systemFontOfSize:20.0f] andlabelWidth:381];
        return MAX(height+100.0f, 202.0f);
        }
        return 202;
    }
    else if (indexPath.row==2)
    {
        return 45;
    }
    else
    {
        if(self.cast)
            return 178;
        else return 0;
    }
}
- (CGFloat)calculateHeightOfLabel:(NSString *)text ofFont:(UIFont *)font andlabelWidth:(NSInteger)width
{
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    float height = 0;
    testLabel.lineBreakMode = NSLineBreakByWordWrapping;
    testLabel.font = font;
    testLabel.text = text;
    height = [testLabel.text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:testLabel.font forKey:NSFontAttributeName] context:nil].size.height;
    return height;
}
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Preparing for Segue in DETAIL controller...");
    if ([[segue identifier] isEqualToString:@"castSegue"]) {
        self.controller = (MOVCastController *)[segue destinationViewController] ;
        self.controller.persID=self.selectedCast.personID;
        //self.controller.person=self.selectedCast;
    }
    else if([[segue identifier] isEqualToString:@"videosSegue"]) {
        MOVVideosController *videocontroller = (MOVVideosController *)[segue destinationViewController];
        videocontroller.path=[[self.videos firstObject] key];
        videocontroller.video=[self.videos firstObject];
    }
}
@end

