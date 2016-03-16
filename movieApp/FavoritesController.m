//
//  FavoritesController.m
//  movieApp
//
//  Created by Adis Cehajic on 17/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "FavoritesController.h"
#import "MOVRealmMovie.h"
#import "MOVFavoritesTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MOVDetailController.h"
#import "NSString+FontAwesome.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>
RLM_ARRAY_TYPE(MOVRealmMovie)
@interface FavoritesController()
@property (strong, nonatomic) NSArray *ratedMovies;
@end
@implementation FavoritesController
- (void) detailsegue:(NSString *)movietitle
{
    for (int i=0; i<self.movies.count; i++)
    {
        if([[[self.movies objectAtIndex:i] title] isEqualToString:movietitle])
        {
            self.selectedMovie=[[MOVMovie alloc] initWithRLMObject:[self.movies objectAtIndex:i]];
            [self performSegueWithIdentifier:@"showDetail" sender:self];
            break;}
    }
}
-(void) setupCoreSpotlightSearch
{
    /*CSSearchableItemAttributeSet *attributeset=[[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
    attributeset.title=@"My first spotlight search";
    attributeset.contentDescription=@"";
    attributeset.keywords=[NSArray arrayWithObjects:@"Hello", @"Welcome", @"Spotlight", nil];
    UIImage *image=[UIImage imageNamed:@"fa-user.png"];
    NSData *imageData=[NSData dataWithData:UIImagePNGRepresentation(image)];
    attributeset.thumbnailData=imageData;
    
    CSSearchableItem *item=[[CSSearchableItem alloc]initWithUniqueIdentifier:@"com.deeplink"  domainIdentifier:@"spotlight.sample" attributeSet:attributeset];
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError *__nullable error)
     {
         if(!error) NSLog(@"uspjelo");
     }];*/
    self.movies = [MOVRealmMovie allObjects];
    self.selectedMovie =[[MOVMovie alloc] init];
    for (int i=0; i<self.movies.count; i++)
    {
        [self indexing:i];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.movies = [MOVRealmMovie allObjects];
    [self.tableView reloadData];
    [self registerAsObserver];

}

- (instancetype) init
{
    self = [super init];
    [self registerAsObserver];
    return self;
}
- (void)registerAsObserver {
    /*
     Register 'inspector' to receive change notifications for the "openingBalance" property of
     the 'account' object and specify that both the old and new values of "openingBalance"
     should be provided in the observe… method.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateView:) name:@"MoviesAreRated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut:) name:@"LoggedOut" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFavs:) name:@"FavoritesUpdated" object:nil];
}

- (void)updateFavs:(NSNotification*)notification
{
    [self setupCoreSpotlightSearch];
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

-(void)indexing:(int)which
{
    MOVMovie *mov=[[MOVMovie alloc] initWithRLMObject:[self.movies objectAtIndex:which]];
    CSSearchableItemAttributeSet *attributeSet=[[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeText];
    attributeSet.title = mov.title;
    attributeSet.contentDescription = mov.overview;
    CSSearchableItem *item;
    NSString *identifier = [NSString stringWithFormat:@"%@",attributeSet.title];
    item = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:@"com.example.apple_sample.theapp.search" attributeSet:attributeSet];
    
    // Index the item.
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler: ^(NSError * __nullable error) {
        if (!error)
            NSLog(@"Search item indexed");
        else {
            NSLog(@"******************* E R R O R *********************");}}];
}
- (void) viewDidLoad
{
    MOVDetailController *detailViewController = [[MOVDetailController alloc] init];
    // Assign self as the delegate for the child view controller
    detailViewController.delegate = self;
    self.navigationController.topViewController.title = @"Favorites";
    [self setupCoreSpotlightSearch];
   }
    

- (void) viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return self.movies.count;
}

- (void)updateFavorites:(MOVDetailController *)view
{
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"FavoriteCell";
    self.movies = [MOVRealmMovie allObjects];
    MOVFavoritesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[MOVFavoritesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[[self.movies objectAtIndex:indexPath.row] releaseDate]];
    cell.titleLabel.text = [[self.movies objectAtIndex:indexPath.row] title];
    cell.ratingLabel.text=[NSString stringWithFormat:@"%@/10", [[self.movies objectAtIndex:indexPath.row]voteAverage ]];
    cell.yearLabel.text=[NSString stringWithFormat:@"From %ld", (long)[components year]];
    NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", [[self.movies objectAtIndex:indexPath.row] posterPath]]];
    [cell.img sd_setImageWithURL:url];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:[self.movies objectAtIndex:indexPath.row]];
        [realm commitWriteTransaction];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // [self.movies removeObjectAtIndex:indexPath.row]; /// delete record from Array
        [self.tableView reloadData]; /// Custom method
    }
}
@synthesize controller;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Preparing for Segue in Master view controller...");
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        controller = (MOVDetailController *)[segue destinationViewController];
        controller.movie=self.selectedMovie;
        for (int i=0; i<[self.ratedMovies count]; i++)
        {
            if ([[[self.ratedMovies objectAtIndex:i] movID] isEqual:[self.selectedMovie movID]])
            {
                self.selectedMovie.userRating=[[self.ratedMovies objectAtIndex:i] userRating];
                break;
            }
            else
                self.selectedMovie.userRating=0;
        }
        
        controller.movie=self.selectedMovie;
        if ([self.ratedMovies count]==0)
            controller.movie.userRating=0;

    }
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSNumber *num;
    for (int i=0; i<[self.ratedMovies count]; i++)
    {
        if ([[[self.ratedMovies objectAtIndex:i] movID] isEqual:[[self.movies objectAtIndex:indexPath.row] movID]])
        {
            num=[[self.ratedMovies objectAtIndex:i] userRating];
            break;
        }
        else
            num=0;
    }
    controller.movie= [[MOVMovie alloc] initWithRLMObject: [self.movies objectAtIndex:indexPath.row]];
    controller.movie.userRating=num;
    NSLog(@"Default Display Controller");
}



@end
