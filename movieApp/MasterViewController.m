
//
//  MasterViewController.m
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MasterViewController.h"
#import <RestKit/RestKit.h>
#import "MOVMovie.h"
#import "MOVMovieTableViewCell.h"
#import "MOVDetailController.h"
#import "FavoritesController.h"
#import "NSString+FontAwesome.h"
#import "movieApp-Swift.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>
@class AccountController;

@interface MasterViewController ()

@property NSMutableArray *objects;
@property (strong, nonatomic) NSMutableDictionary *moviesDict;
@property (strong, nonatomic) NSArray *movies;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong)  MOVDetailController *controller;
@property (nonatomic, strong) NSArray *ratedMovies;
@property (nonatomic, strong) MOVMovieTableViewCell *MovieCell;
@property (nonatomic, strong) NSString *query;
@end

@implementation MasterViewController

- (void) detailsegue:(NSString *)movietitle
{
    RLMArray<MOVRealmMovie*><MOVRealmMovie> *movs= [MOVRealmMovie allObjects];
    for (int i=0; i<movs.count; i++)
    {
        if([[[movs objectAtIndex:i] title] isEqualToString:movietitle])
        {
            self.movie=[[MOVMovie alloc] initWithRLMObject:[movs objectAtIndex:i]];
            [self performSegueWithIdentifier:@"showDetail" sender:self];
            break;
        }
    }
}
- (void)registerAsObserver {
    
    UINavigationController *navcontroller=(UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:1];
    FavoritesController *rootViewController = (FavoritesController *)[[navcontroller viewControllers] firstObject];
    [rootViewController registerAsObserver];
    [rootViewController setupCoreSpotlightSearch];
    navcontroller=(UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:2];
    AccountController *accController = (AccountController *)[[navcontroller viewControllers] firstObject];
    [accController registerAsObserver];
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
    //[self loadUser];
    
}
- (void) logOut:(NSNotification*)notification
{
    self.ratedMovies=nil;
    [[self tableView] reloadData];
}

- (void) findMovies
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectMapping* movieMapping = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping addAttributeMappingsFromDictionary:@{
                                                       @"title": @"title",
                                                       @"id": @"movID",
                                                       @"backdrop_path": @"backdropPath",
                                                       @"belongs_to_collection":@"belongsToCollection",
                                                       @"adult": @"adult",
                                                       
                                                       @"genre_ids": @"genres",
                                                       @"homepage": @"homepage",
                                                       @"original_language": @"originalLanguage",
                                                       @"overview": @"overview",
                                                       @"imdb_id": @"imdbID",
                                                       @"original_title": @"originalTitle",
                                                       @"poster_path": @"posterPath",
                                                       @"production_companies": @"productionCompanies",
                                                       @"popularity": @"popularity",
                                                       @"production_countries": @"productionCountries",
                                                       @"release_date": @"releaseDate",
                                                       @"revenue": @"revenue",
                                                       @"spoken_languages": @"spokenLanguages",
                                                       @"status": @"status",
                                                       @"tagline": @"tagline",
                                                       @"title": @"title",
                                                       @"video": @"video",
                                                       @"vote_count": @"voteCount",
                                                       @"vote_average": @"voteAverage"
                                                       
                                                       }];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/search/movie"]
                                               keyPath:@"results" statusCodes:statusCodes];
    
    
    RKObjectManager *sharedManager = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager addResponseDescriptorsFromArray:@[responseDescriptor]];
    [ sharedManager getObjectsAtPath:@"/3/search/movie" parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825", @"query":self.query}
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                 
                                 self.searchResult = mappingResult.array;
                             //   [self.tableView reloadData];
                                 [self.searchDisplayController.searchResultsTableView reloadData];
                             }
                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                             }];
    
    

}
- (void)loadMovies
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectMapping* movieMapping = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping addAttributeMappingsFromDictionary:@{
                                                       @"title": @"title",
                                                       @"id": @"movID",
                                                       @"backdrop_path": @"backdropPath",
                                                       @"belongs_to_collection":@"belongsToCollection",
                                                       @"adult": @"adult",
                                                       
                                                       @"genre_ids": @"genres",
                                                       @"homepage": @"homepage",
                                                       @"original_language": @"originalLanguage",
                                                       @"overview": @"overview",
                                                       @"imdb_id": @"imdbID",
                                                       @"original_title": @"originalTitle",
                                                       @"poster_path": @"posterPath",
                                                       @"production_companies": @"productionCompanies",
                                                       @"popularity": @"popularity",
                                                       @"production_countries": @"productionCountries",
                                                       @"release_date": @"releaseDate",
                                                       @"revenue": @"revenue",
                                                       @"spoken_languages": @"spokenLanguages",
                                                       @"status": @"status",
                                                       @"tagline": @"tagline",
                                                       @"title": @"title",
                                                       @"video": @"video",
                                                       @"vote_count": @"voteCount",
                                                       @"vote_average": @"voteAverage"
                                                       
                                                       }];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodAny pathPattern:@"/3/movie/top_rated" keyPath:@"results" statusCodes:statusCodes];
    
    
    RKObjectManager *sharedManager = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager addResponseDescriptorsFromArray:@[responseDescriptor]];
    [ sharedManager getObjectsAtPath:@"/3/movie/top_rated" parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                 
                                 self.movies = mappingResult.array;
                                 [self.moviesDict setObject:self.movies forKey:@"top_rated"];
                                 self.objects=[NSMutableArray arrayWithCapacity:5];
                                 [self.objects addObject:self.movies];
                                 //self.objects = [NSMutableArray arrayWithArray:self.movies];
                                 [self.tableView reloadData];
                             }
                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                             }];
    
    
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodAny pathPattern:@"/3/movie/upcoming" keyPath:@"results" statusCodes:statusCodes];
    RKObjectManager *sharedManager2 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager2 addResponseDescriptorsFromArray:@[responseDescriptor2]];
    [ sharedManager2 getObjectsAtPath:@"/3/movie/upcoming" parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  
                                  self.movies = mappingResult.array;
                                  [self.moviesDict setObject:self.movies forKey:@"upcoming"];
                                  
                                  //  self.objects=[NSMutableArray arrayWithCapacity:5];
                                  [self.objects addObject:self.movies];
                                  NSLog(@"tu2");
                                  //self.objects = [NSMutableArray arrayWithArray:self.movies];
                                  [self.tableView reloadData];
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              }];
    
    
    RKResponseDescriptor *responseDescriptor3 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodAny pathPattern:@"/3/movie/popular" keyPath:@"results" statusCodes:statusCodes];
    RKObjectManager *sharedManager3 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager3 addResponseDescriptorsFromArray:@[responseDescriptor3]];
    [ sharedManager3 getObjectsAtPath:@"/3/movie/popular" parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  
                                  self.movies = mappingResult.array;
                                  [self.moviesDict setObject:self.movies forKey:@"popular"];
                                  [self.objects addObject:self.movies ];
                                  NSLog(@"tu3");
                                  [self.tableView reloadData];
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              }];
    
    
    
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<[[self.moviesDict objectForKey:@"top_rated"] count]; i++){
        [arr addObject:[[self.moviesDict objectForKey:@"top_rated"] objectAtIndex:i]];
        [arr addObject:[[self.moviesDict objectForKey:@"popular"] objectAtIndex:i]];
        [arr addObject:[[self.moviesDict objectForKey:@"upcoming"] objectAtIndex:i]];
    }
    
    self.searchResult = [arr filteredArrayUsingPredicate:resultPredicate];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
   /* [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];*/
    self.query=searchString;
    [self findMovies];
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerAsObserver];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    if(!self.moviesDict)
        self.moviesDict=[[NSMutableDictionary alloc] init];
    //Search
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.objects count]];
    
    //Movie for DetailView controller
    if(!self.movie)
        self.movie = [[MOVMovie alloc]init];
    //RESTKIT
    UIImage *image = [UIImage imageNamed:@"HEARTicon.png"];
    [[[self.tabBarController.tabBar items] objectAtIndex:1 ] setImage: [self imageWithImage:image scaledToSize:CGSizeMake(30, 30)]];
    UIImage *image1 = [UIImage imageNamed:@"videocamicon.png"];
    [[[self.tabBarController.tabBar items] objectAtIndex:0 ] setImage: [self imageWithImage:image1 scaledToSize:CGSizeMake(30, 30)]];
    UIImage *image2 = [UIImage imageNamed:@"fa-user.png"];
    self.definesPresentationContext = NO;
    [[[self.tabBarController.tabBar items] objectAtIndex:2 ] setImage: [self imageWithImage:image2 scaledToSize:CGSizeMake(30, 30)]];
    [self loadMovies];
    
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"masterViewInactive" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    //self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    
    self.tabBarController.tabBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"masterViewActive" object:nil];
    
    
    [super viewWillAppear:animated];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:10.0f]
                                                        } forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"HEARTicon.png"];
    [[[self.tabBarController.tabBar items] objectAtIndex:1 ] setImage: [self imageWithImage:image scaledToSize:CGSizeMake(30, 30)]];
    UIImage *image1 = [UIImage imageNamed:@"videocamicon.png"];
    [[[self.tabBarController.tabBar items] objectAtIndex:0 ] setImage: [self imageWithImage:image1 scaledToSize:CGSizeMake(30, 30)]];
    UIImage *image2 = [UIImage imageNamed:@"fa-user.png"];
    
    
    [[[self.tabBarController.tabBar items] objectAtIndex:2 ] setImage: [self imageWithImage:image2 scaledToSize:CGSizeMake(30, 30)]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

@synthesize controller;

- (void) selectMovie:(MOVMovieTableViewCell *)view withItem:(MOVMovie *)item
{
    self.movie=item;
    controller.movie=item;
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Preparing for Segue in Master view controller...");
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        controller = (MOVDetailController *)[segue destinationViewController];
        
        //controller = (MOVDetailController *)[segue destinationViewController] ;
        if (self.searchDisplayController.active) {
            NSLog(@"Search Display Controller");
            controller.movie = [self.searchResult objectAtIndex: self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow.row];
            for (int i=0; i<[self.ratedMovies count]; i++)
            {
                if ([[[self.searchResult objectAtIndex: self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow.row] movID] isEqual:[[self.ratedMovies objectAtIndex:i] movID]])
                {
                   controller.movie.userRating=[[self.ratedMovies objectAtIndex:i] userRating];
                    break;
                }
                else
                    controller.movie.userRating=0;
            }
            if ([self.ratedMovies count]==0)
                controller.movie.userRating=0;

            
        } else {
            NSLog(@"tututu Default Display Controller");
            for (int i=0; i<[self.ratedMovies count]; i++)
            {
                if ([[[self.ratedMovies objectAtIndex:i] movID] isEqual:[self.movie movID]])
                {
                    self.movie.userRating=[[self.ratedMovies objectAtIndex:i] userRating];
                    break;
                }
                else
                   self.movie.userRating=0;
            }
           
            controller.movie=self.movie;
            if ([self.ratedMovies count]==0)
                controller.movie.userRating=0;
            
        }
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResult count];
    }
    else
    {
        return self.objects.count;//  return [self.objects count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        static NSString *CellIdentifier = @"NormalCell";
        
        UITableViewCell *cell = [self.searchDisplayController.searchResultsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text=[[self.searchResult objectAtIndex:indexPath.row] title];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        
        MOVMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MOVMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       }
        if (indexPath.row==0) {cell.typeLabel.text=@"Top rated movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"top_rated"]];}
        
        else if (indexPath.row==1) {cell.typeLabel.text = @"Upcoming movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"upcoming"]];}
        
        else if(indexPath.row==2) {cell.typeLabel.text=@"Most popular movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"popular"]];}
        
        cell.backgroundColor=[UIColor whiteColor];
        cell.delegate=self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        controller.movie= [self.searchResult objectAtIndex: self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow.row];
        [self performSegueWithIdentifier: @"showDetail" sender:self];
        
        NSLog(@"Search Display Controller");
    } else {
         NSLog(@"Default Display Controller");
    }
    controller.navigationItem.leftItemsSupplementBackButton = YES;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
        return 47;
    else return 268;
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
    self.navigationController.navigationBar.translucent = YES;
}

-(void)willDismissSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.translucent = NO;
}

@end

