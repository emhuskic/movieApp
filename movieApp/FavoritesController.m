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
RLM_ARRAY_TYPE(MOVRealmMovie)
@interface FavoritesController()
@property RLMArray<MOVRealmMovie*><MOVRealmMovie> *movies;
@property (strong, nonatomic) MOVDetailController *controller;
@property (strong, nonatomic) MOVMovie *selectedMovie;
@end
@implementation FavoritesController
/*
 
 specimens = Specimen.allObjects()  // 2
 // Create annotations for each one
 for specimen in specimens {
 let aSpecimen = specimen as Specimen
 let coord = CLLocationCoordinate2D(latitude: aSpecimen.latitude, longitude: aSpecimen.longitude);
 let specimenAnnotation = SpecimenAnnotation(coordinate: coord,
 title: aSpecimen.name,
 subtitle: aSpecimen.category.name,
 specimen: aSpecimen) // 3
 mapView.addAnnotation(specimenAnnotation) // 4
 }
 */
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.movies = [MOVRealmMovie allObjects];

}
- (void) viewDidLoad
{
    MOVDetailController *detailViewController = [[MOVDetailController alloc] init];
    // Assign self as the delegate for the child view controller
    detailViewController.delegate = self;
   self.movies = [MOVRealmMovie allObjects];
    self.selectedMovie =[[MOVMovie alloc] init];
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
    cell.titleLabel.text = [[self.movies objectAtIndex:indexPath.row] title];
    NSURL * url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", [[self.movies objectAtIndex:indexPath.row] posterPath]]];
    // NSData *dataLower = [NSData dataWithContentsOfURL:urlLower];
    //UIImage *imgLower= [[UIImage alloc] initWithData:dataLower];
    // customCell.img.image=imgLower;
    [cell.img sd_setImageWithURL:url];
    //cell.img.image=[[self.movies objectAtIndex:indexPath.row]
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
    }
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    self.selectedMovie.overview=[[self.movies objectAtIndex: indexPath.row] overview];
    self.selectedMovie.posterPath=[[self.movies objectAtIndex: indexPath.row] posterPath];
    self.selectedMovie.imdbID=[[self.movies objectAtIndex: indexPath.row] imdbID];
    self.selectedMovie.movID=[[self.movies objectAtIndex: indexPath.row] movID];
    self.selectedMovie.releaseDate=[[self.movies objectAtIndex: indexPath.row] releaseDate];
    self.selectedMovie.backdropPath=[[self.movies objectAtIndex: indexPath.row] backdropPath];
    self.selectedMovie.title=[[self.movies objectAtIndex: indexPath.row] title];
    self.selectedMovie.tagline=[[self.movies objectAtIndex: indexPath.row] tagline];
    self.selectedMovie.originalLanguage=[[self.movies objectAtIndex: indexPath.row] originalTitle];
    self.selectedMovie.voteAverage=[[self.movies objectAtIndex: indexPath.row] voteAverage];
    self.selectedMovie.voteCount=[[self.movies objectAtIndex: indexPath.row] voteCount];
        controller.movie = self.selectedMovie;
     //   [self performSegueWithIdentifier: @"showDetail" sender: self];
        NSLog(@"Default Display Controller");
}


@end
