//
//  DetailViewController.m
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "DetailViewController.h"
#import "MOVMovie.h"
#import <RestKit/RestKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MOVPerson.h"
#import "MOVMovieCastCollectionViewCell.h"
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *averageRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *upperImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lowerImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) MOVMovie *movie;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *cast;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        if(!_movie)
        _movie=[[MOVMovie alloc] init];
        _movie = _detailItem;
        // Update the view.
        [self configureView];
    }
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
                                 self.cast=mappingResult.array;
                              }
                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                             }];
    
    
   
    
    // https://api.themoviedb.org/3/movies/%d/credits?=
    
    
}
- (void)configureView {
     // Update the user interface for the detail item.
    if (self.detailItem) {
        
       
        self.title = [self.detailItem title];
        self.titleLabel.text= [self.detailItem title];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self.detailItem releaseDate]];
        self.releaseDateLabel.text=[NSString stringWithFormat:@"(%ld)",[components year]];
        self.descriptionLabel.text=[self.detailItem overview];
        self.detailDescriptionLabel.text = [self.detailItem tagline];
        self.releaseDateLabel.numberOfLines =0;
        [self.releaseDateLabel sizeToFit];
        NSLog(@"genre: %@",  self.movie.posterPath);
     //   self.genreLabel.text= [[[self.movie genres] firstObject] name];
      NSURL * urlLower = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", self.movie.posterPath]];
        NSURL *urlUpper = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w1280", self.movie.backdropPath]];
        //NSURL *url = [NSURL URLWithString:str];
        NSData *dataLower = [NSData dataWithContentsOfURL:urlLower];
        UIImage *imgLower= [[UIImage alloc] initWithData:dataLower];
        NSData *dataUpper = [NSData dataWithContentsOfURL:urlUpper];
        UIImage *imgUpper= [[UIImage alloc] initWithData:dataUpper];
        [self.upperImage sd_setImageWithURL:urlUpper];
        [self.lowerImage sd_setImageWithURL:urlLower];
        self.voteCountLabel.text=[NSString stringWithFormat:@"%@", self.movie.voteCount];
        self.averageRatingLabel.text=[NSString stringWithFormat:@"%@", self.movie.voteAverage];
     //   self.rateView.delegate = self;
        self.rateView.rating=[[self.movie voteAverage] floatValue]/2.;
        [self loadCast];
        
        
               //self.upperImage.image=imgUpper;
        //self.lowerImage.image=imgLower;
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.rateView.notSelectedImage = [UIImage imageNamed:@"redstarnotselected.png"];
    
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"redstarhald.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"redstarfullselected.png"];
    
    self.userRateView.notSelectedImage = [UIImage imageNamed:@"redstarnotselected.png"];
    
    self.userRateView.halfSelectedImage = [UIImage imageNamed:@"redstarhald.png"];
    self.userRateView.fullSelectedImage = [UIImage imageNamed:@"redstarfullselected.png"];
    
    
    self.rateView.rating = 0;
    self.rateView.editable = NO;
    self.rateView.maxRating = 5;
    
    self.userRateView.rating = 0;
    self.userRateView.editable = YES;
    self.userRateView.maxRating = 5;
    self.rateView.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self configureView];
}
- (void)rateView:(MOVMovieStarRateView *)rateView ratingDidChange:(float)rating {
   // self.statusLabel.text = [NSString stringWithFormat:@"Rating: %f", rating];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cast.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                        cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *cellIdentifier = @"castCell";
    MOVMovieCastCollectionViewCell *customCell = (MOVMovieCastCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    customCell.backgroundColor=[UIColor whiteColor];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    MOVPerson *pers;
    if([self.cast count])
    {
        pers = [self.cast objectAtIndex:indexPath.row];
        NSURL * urlLower = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", [pers profilePath]]];
        [customCell.img sd_setImageWithURL:urlLower];
        customCell.nameLabel.text=[pers name];
        return customCell;
    }
    else
        return customCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
