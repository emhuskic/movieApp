//
//  MasterViewController.m
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//
/*
#import "MasterViewController.h"
#import <RestKit/RestKit.h>
#import "MOVMovie.h"
#import "MOVMovieTableViewCell.h"
#import "MOVDetailController.h"

#import "NSString+FontAwesome.h"
@interface MasterViewController ()

@property NSMutableArray *objects;
@property (strong, nonatomic) NSMutableDictionary *moviesDict;
@property (strong, nonatomic) NSArray *movies;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong)  MOVDetailController *controller;
@property (nonatomic, strong) MOVMovieTableViewCell *MovieCell;
@end

@implementation MasterViewController




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
                                                      
                                                       @"genres": @"genre_ids",
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
    [self filterContentForSearchText:searchString
scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
       objectAtIndex:[self.searchDisplayController.searchBar
                      selectedScopeButtonIndex]]];
    
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

   // UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
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
    [self loadMovies];
    
 }

- (void)viewWillAppear:(BOOL)animated {
    //self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
                                                        } forState:UIControlStateNormal];

   [[self.tabBarController.tabBar.items objectAtIndex:0]  setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAVideoCamera]]];
    [[self.tabBarController.tabBar.items objectAtIndex:1]  setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAHeartO]]];
    [[self.tabBarController.tabBar.items objectAtIndex:2]  setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAUser]]];
    
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
        } else {
            NSLog(@"tututu Default Display Controller");
         controller.movie=self.movie;
            
                
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
      //  NSLog(<#NSString * _Nonnull format, ...#>)
        return [self.searchResult count];
    }
    else
    {
       /* switch (section) {
            case 0:
                return [[self.moviesDict objectForKey:@"top_rated"] count];
                
                break;
                
            default: return [self.moviesDict count];
                break;
        }
        return [self.objects count];
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    MOVMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil)
     {
         cell = [[MOVMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         
         // cell.movies=[NSArray arrayWithArray:self.movies];
     }
    if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        
    }
    else{
      if (indexPath.row==0) {cell.typeLabel.text=@"Top rated movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"top_rated"]];}
        
    else if (indexPath.row==1) {cell.typeLabel.text = @"Upcoming movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"upcoming"]];}
        
    else if(indexPath.row==2) {cell.typeLabel.text=@"Most popular movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"popular"]];}
     
    cell.backgroundColor=[UIColor whiteColor];
    cell.delegate=self;
     }
    return cell;
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
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        
        MOVMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MOVMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            // cell.movies=[NSArray arrayWithArray:self.movies];
        }
        if (indexPath.row==0) {cell.typeLabel.text=@"Top rated movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"top_rated"]];}
        
        else if (indexPath.row==1) {cell.typeLabel.text = @"Upcoming movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"upcoming"]];}
        
        else if(indexPath.row==2) {cell.typeLabel.text=@"Most popular movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"popular"]];}
        
        cell.backgroundColor=[UIColor whiteColor];
        cell.delegate=self;
      //  cell.selectionStyle = UITableViewCellSelectionStyle.none;
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
        controller.movie = [self.objects objectAtIndex: indexPath.row];
        [self performSegueWithIdentifier: @"showDetail" sender: self];
        NSLog(@"Default Display Controller");
    }
    controller.navigationItem.leftItemsSupplementBackButton = YES;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(!self.movies.count)
            return 0;
        else if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
            return 47;
        else return 297;
            
}




@end*/

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

#import "NSString+FontAwesome.h"
@interface MasterViewController ()

@property NSMutableArray *objects;
@property (strong, nonatomic) NSMutableDictionary *moviesDict;
@property (strong, nonatomic) NSArray *movies;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong)  MOVDetailController *controller;
@property (nonatomic, strong) MOVMovieTableViewCell *MovieCell;
@end

@implementation MasterViewController




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
    
    
    
    /*  RKObjectMapping* issueMapping = [RKObjectMapping mappingForClass: [MOVMovie class] usingBlock:^(RKObjectMapping *mapping) {
     [movieMapping addAttributeMappingsFromDictionary:@{
     @"genr"
     [mapping mapKeyPathsToAttributes:
     @"id", @"identifier",
     nil];
     }];
     issueMapping.rootKeyPath = @"issue";
     [omp setObjectMaping: issueMapping forKeyPath: @"issuelist"];
     */
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
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
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

- (void)viewWillAppear:(BOOL)animated {
    //self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
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
    
    
    /* [[self.tabBarController.tabBar.items objectAtIndex:0]  setTitle:[NSString stringWithFormat:@"%@\nFeed",[NSString fontAwesomeIconStringForEnum:FAVideoCamera]]];
     [[self.tabBarController.tabBar.items objectAtIndex:1]  setTitle:[NSString stringWithFormat:@"%@\nFavorites",[NSString fontAwesomeIconStringForEnum:FAHeartO]]];
     [[self.tabBarController.tabBar.items objectAtIndex:2]  setTitle:[NSString stringWithFormat:@"%@\nAccount",[NSString fontAwesomeIconStringForEnum:FAUser]]];*/
    
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
        } else {
            NSLog(@"tututu Default Display Controller");
            controller.movie=self.movie;
            
            
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
        //  NSLog(<#NSString * _Nonnull format, ...#>)
        return [self.searchResult count];
    }
    else
    {
        /* switch (section) {
         case 0:
         return [[self.moviesDict objectForKey:@"top_rated"] count];
         
         break;
         
         default: return [self.moviesDict count];
         break;
         }*/
        return [self.objects count];
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
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        
        MOVMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MOVMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            // cell.movies=[NSArray arrayWithArray:self.movies];
        }
        if (indexPath.row==0) {cell.typeLabel.text=@"Top rated movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"top_rated"]];}
        
        else if (indexPath.row==1) {cell.typeLabel.text = @"Upcoming movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"upcoming"]];}
        
        else if(indexPath.row==2) {cell.typeLabel.text=@"Most popular movies";  cell.movies=[NSArray arrayWithArray:[self.moviesDict objectForKey:@"popular"]];}
        
        cell.backgroundColor=[UIColor whiteColor];
        cell.delegate=self;
        //  cell.selectionStyle = UITableViewCellSelectionStyle.none;
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
        controller.movie = [self.objects objectAtIndex: indexPath.row];
        [self performSegueWithIdentifier: @"showDetail" sender: self];
        NSLog(@"Default Display Controller");
    }
    controller.navigationItem.leftItemsSupplementBackButton = YES;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.movies.count)
        return 0;
    else if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
        return 47;
    else return 297;
    
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

