
//
//  MOVCastController.m
//  movieApp
//
//  Created by Adis Cehajic on 16/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVCastController.h"
#import "MOVCastUpperImageCell.h"
#import "MOVCastBiographyCell.h"
#import "MOVCastMovieTableViewCell.h"
#import "MOVDetailController.h"
#import "NSString+FontAwesome.h"
#import "Reachability.h"
@interface MOVCastController()
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property (nonatomic, strong)  MOVDetailController *controller;
@property (nonatomic, strong) MOVMovie *selectedMovie;
@property (nonatomic, strong) NSString *selectedMovieID;
@end
@implementation MOVCastController

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
- (void) loadMovie
{
    
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    //IMAGES MAPPING
    RKObjectMapping* movieMapping2 = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping2 addAttributeMappingsFromDictionary:@{
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
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping2 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/search/movie"]  keyPath:@"results" statusCodes:statusCodes];
    
    
    
    RKObjectManager *sharedManager2 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager2 addResponseDescriptorsFromArray:@[responseDescriptor2]];
    [ sharedManager2 getObjectsAtPath:[NSString stringWithFormat:@"/3/search/movie"]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825", @"query" : [NSString stringWithFormat:@"%@",self.selectedMovieID]}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  self.selectedMovie = [mappingResult.array firstObject];
                                  [self performSegueWithIdentifier:@"showDetail" sender:self];
                                  //[self configureView];
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              }];
    
    
}
- (void)selectCastMovie:(MOVCastMovieTableViewCell *)view withItem:(MOVMovie*)item
{
    self.selectedMovieID=[item title];
    [self loadMovie];
    self.controller.movie=item;
    // self.selectedMovie=item;
}

- (void) loadPerson
{
    
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    //IMAGES MAPPING
    RKObjectMapping* movieMapping2 = [RKObjectMapping mappingForClass:[MOVPerson class]];
    [movieMapping2 addAttributeMappingsFromDictionary:@{
                                                        @"file_path": @"filePath"
                                                        
                                                        }];
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping2 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/person/%@/tagged_images",self.persID]  keyPath:@"results" statusCodes:statusCodes];
    
    RKObjectManager *sharedManager2 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager2 addResponseDescriptorsFromArray:@[responseDescriptor2]];
    [ sharedManager2 getObjectsAtPath:[NSString stringWithFormat:@"/3/person/%@/tagged_images",self.persID]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  self.images=mappingResult.array;
                                  [self.tableView reloadData];
                                  //[self configureView];
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              }];
    
    
    // PERSON MAPPING
    RKObjectMapping* movieMapping = [RKObjectMapping mappingForClass:[MOVPerson class]];
    [movieMapping addAttributeMappingsFromDictionary:@{
                                                       @"biography": @"biography",
                                                       @"birthday": @"birthday",
                                                       @"deathday": @"deathday",
                                                       @"id": @"personID",
                                                       @"homepage": @"homepage",
                                                       @"name": @"name",
                                                       @"place_of_birth": @"birthPlace",
                                                       @"profile_path": @"profilePath"
                                                       }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/person/%@",self.persID]  keyPath:@"" statusCodes:statusCodes];
    
    RKObjectManager *sharedManager = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager addResponseDescriptorsFromArray:@[responseDescriptor]];
    [ sharedManager getObjectsAtPath:[NSString stringWithFormat:@"/3/person/%@",self.persID]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                 
                                 self.person=[mappingResult.array firstObject];
                                 [[self navigationController] setNavigationBarHidden:NO animated:YES];
                                 self.navigationController.topViewController.title = [NSString stringWithFormat:@"%@", [self.person name]];
                                 self.navigationController.navigationBar.hidden = NO;
                                 [self.tableView reloadData];
                                 //[self configureView];
                             }
                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                             }];
    
    
    
    //MOVIES IN COLLECTION VIEW
    RKObjectMapping* movieMapping3 = [RKObjectMapping mappingForClass:[MOVMovie class]];
    [movieMapping3 addAttributeMappingsFromDictionary:@{
                                                        @"id": @"movID",
                                                        @"title": @"title",
                                                        @"poster_path": @"posterPath",
                                                        @"release_date" : @"releaseDate"
                                                        }];
    RKResponseDescriptor *responseDescriptor3 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping3 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/person/%@/movie_credits", self.persID] keyPath:@"cast" statusCodes:statusCodes];
    RKObjectManager *sharedManager3 = [[RKObjectManager alloc] initWithHTTPClient:client];
    [sharedManager3 addResponseDescriptorsFromArray:@[responseDescriptor3]];
    [ sharedManager3 getObjectsAtPath:[NSString stringWithFormat:@"/3/person/%@/movie_credits", self.persID] parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  
                                  self.movies = mappingResult.array;
                                  [self.tableView reloadData];
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                  NSLog(@"%@",error);
                              }];
    
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadPerson];
    
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
    if (containsIndexPath)
    {
        [self.selectedIndexPaths removeObject:indexPath];
    }
    else
    {
        [self.selectedIndexPaths addObject:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0)
    {
        static NSString *CellIdentifier = @"CastUpperCell";
        MOVCastUpperImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MOVCastUpperImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //Upper image
        NSURL * urlUpper = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w300", [[self.images firstObject] filePath]]];
        NSLog(@"IMAGE IS %@",[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w300", [[self.images firstObject] filePath]]);
        
        NSData *data = [NSData dataWithContentsOfURL:urlUpper];
        [cell.img sd_setImageWithURL:urlUpper placeholderImage:[UIImage imageNamed: @"imgplaceholder.png"]];

        
        //Namelabel
        cell.nameLabel.text = self.person.name;
        
        //Birthday label
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self.person birthday]];
        [NSString stringWithFormat:@"%ld",(long)[components year]];
        NSArray *listItems = [[self.person birthPlace] componentsSeparatedByString:@", "];
        cell.birthdayLabel.text=[NSString stringWithFormat:@"Born %@ in %@", [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[components year], [components month], [components day]], [listItems firstObject]];
        
        //Birthplace label
        cell.birthplaceLabel.text=@"";
        for (int i=1; i<listItems.count; i++)
            cell.birthplaceLabel.text=[NSString stringWithFormat:@"%@-%@", cell.birthplaceLabel.text, [listItems objectAtIndex:i]];
        return cell;
    }
    
    else if (indexPath.row==1)
    {
        static NSString *CellIdentifier = @"CastBiographyCell";
        BOOL isSelected = [self.selectedIndexPaths containsObject:indexPath];
        MOVCastBiographyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MOVCastBiographyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSURL * urlLower = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", [self.person profilePath]]];
        NSLog(@"IMAGE 2 IS %@",[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", [self.person profilePath]]);
        
        NSData *data = [NSData dataWithContentsOfURL:urlLower];
        [cell.img sd_setImageWithURL:urlLower placeholderImage:[UIImage imageNamed: @"imgplaceholder.png"]];

        cell.biographyLabel.text=[self.person biography];
       [cell.infoButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAInfoCircle]]forState:UIControlStateNormal];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.infoButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.infoButton setTag:indexPath.row];
        if(isSelected)
           [cell.biographyLabel sizeToFit];
       return cell;
    }
    
    
    else if(indexPath.row==2)
    {
        static NSString *CellIdentifier = @"CastNormalCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"CastMoviesCell";
        MOVCastMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MOVCastMovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            // cell.movies=[NSArray arrayWithArray:self.movies];
        }
        cell.backgroundColor=[UIColor clearColor];
        cell.typeLabel.text=@"Movies";
        cell.movies=[NSArray arrayWithArray:self.movies];
        cell.backgroundColor=[UIColor whiteColor];
        cell.delegate=self;
        [cell refreshCollection];
        return cell;
    }
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    
    //  self.controller.movie = [self.movies objectAtIndex: indexPath.row];
    //[self performSegueWithIdentifier: @"showMovieDetail" sender: self];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        self.controller = (MOVDetailController *)[segue destinationViewController] ;
        self.controller.movie=self.selectedMovie;
        [self.controller.tableView reloadData];
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


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 200;
    }
    else if (indexPath.row==1)
    {
        BOOL isSelected = [self.selectedIndexPaths containsObject:indexPath];
        if(isSelected)
        {
            CGFloat maxHeight = MAXFLOAT;
            CGFloat minHeight = 172.0f;
            CGFloat constrainHeight = isSelected?maxHeight:minHeight;
            //CGFloat constrainWidth  = tableView.frame.size.width-50.0f;
            CGFloat constrainWidth=416.0f;
            NSString *text       = [self.person biography];
            CGSize constrainSize = CGSizeMake(constrainWidth, constrainHeight);
            
            CGRect labelSizer     = [text boundingRectWithSize:constrainSize options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil];
            CGSize labelsize = [text sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:constrainSize];
            CGFloat height = [self calculateHeightOfLabel:text ofFont:[UIFont systemFontOfSize:15.0f] andlabelWidth:416.0f];
            
            return MAX(height, 182.0f);

        }
        return 182;
    }
    else if (indexPath.row==2)
    {
        return 37;
    }
    else
    {
        if(self.movies.count)
            return 169;
        else return 0;
    }
}

@end
