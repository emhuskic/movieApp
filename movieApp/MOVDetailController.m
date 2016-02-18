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
@interface MOVDetailController()
@property (strong, nonatomic) NSArray *cast;
@property (strong, nonatomic) MOVPerson *selectedCast;
@property (strong, nonatomic) MOVCastController *controller;
@property RLMRealm *realm;
@end

@implementation MOVDetailController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.realm = [RLMRealm defaultRealm];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;
    
    UITabBarController *tabBarController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController ;
    [tabBarController setDelegate:self];
    [self loadCast];
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
        favcontroller.delegate=self;
         [favcontroller.delegate refreshDetail:favcontroller];
    }
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
            static NSString *CellIdentifier = @"upperCell";
            MOVUpperImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[MOVUpperImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            //Upper image
            NSURL * url= [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w1280", self.movie.backdropPath]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *cellimg=[UIImage imageWithData:data];
            cell.img.image = cellimg;
            // Get the Layer of any view
            
            //Title label
            cell.titleLabel.text = self.movie.title;
            //Duration label
            
            //Genre label
            
            //Year label
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self.movie releaseDate]];
            cell.yearLabel.text=[NSString stringWithFormat:@"%ld",(long)[components year]];
            
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
            NSURL * url= [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w1280", self.movie.posterPath]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            cell.img.image = [UIImage imageWithData:data];
            
            [cell.videosButton setTitle:[NSString stringWithFormat:@"%@ Videos",[NSString fontAwesomeIconStringForEnum:FAFilm]]forState:UIControlStateNormal];
            
            [cell.smallVideosButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAAngleRight]]forState:UIControlStateNormal];
            
            [cell.descriptionButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAInfoCircle]]forState:UIControlStateNormal];
            
            cell.descriptionLabel.text=[self.movie overview];
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
            [cell refresh];
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
            return cell;
        }
}
@synthesize realm;
-(void)favoritesButtonTapped:(id)sender
{
    UIButton *button = (UIButton *) sender;
    int tag = [(UIButton *)sender tag];
    MOVRealmMovie *mov = [[MOVRealmMovie alloc] init];
    mov.posterPath=self.movie.posterPath;
    mov.title=self.movie.title;
    mov.originalLanguage=self.movie.originalLanguage;
    mov.originalTitle=self.movie.originalTitle;
    mov.popularity=self.movie.popularity;
    mov.voteCount=self.movie.voteCount;
    mov.releaseDate=self.movie.releaseDate;
    mov.backdropPath=self.movie.backdropPath;
    mov.belongsToCollection=self.movie.belongsToCollection;
    mov.revenue=self.movie.revenue;
    mov.overview=self.movie.overview;
    mov.movID=self.movie.movID;
    mov.imdbID=self.movie.imdbID;
    mov.isFavorite=self.movie.isFavorite;
    mov.voteAverage=self.movie.voteAverage;
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

    [self.delegate updateFavorites:self];
    
    NSLog(@"tapped button in cell at row %i", tag);
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 200;
    }
    else if (indexPath.row==1)
    {
        return 210;
    }
    else if (indexPath.row==2)
    {
        return 45;
    }
    else
    {
        if(self.cast)
        return 163;
        else return 0;
    }
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
}
@end
