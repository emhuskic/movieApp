//
//  CastViewController.m
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "CastViewController.h"
#import "MOVMovieCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MOVPersonDetail.h"
#import <Restkit/Restkit.h>
@interface CastViewController()
@property (weak, nonatomic) IBOutlet UIImageView *lowerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bornLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) MOVPersonDetail *personDetails;
@property (strong, nonatomic) NSArray *personImages;
@property (strong, nonatomic) NSArray *movieCredits;
@property (weak, nonatomic) IBOutlet UIImageView *upperImage;


@end
@implementation CastViewController



- (void)configureView {
    if( self.personDetails)
    {
        self.nameLabel.text=self.personDetails.name;
        NSURL * urlLower = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", [self.person profilePath]]];
        [self.lowerImage sd_setImageWithURL:urlLower];
         self.descriptionLabel.text=[self.personDetails biography];
        self.bornLabel.text=[NSString stringWithFormat:@"Born %@ in %@", [self.personDetails birthday], [self.personDetails birthPlace]];
    }
    if (self.personImages)
    {
        NSURL * urlUpper = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w1295", [[self.personImages firstObject] filePath]]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w1920", [[self.personImages firstObject] filePath]]);
        [self.upperImage sd_setImageWithURL:urlUpper];
        
    }

}
- (void) loadPerson
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKObjectMapping* movieMapping2 = [RKObjectMapping mappingForClass:[MOVPersonDetail class]];
    [movieMapping2 addAttributeMappingsFromDictionary:@{
                                                        @"file_path": @"filePath"
                                                        
                                                        }];
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping2 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/person/%@/tagged_images",self.person.personID]  keyPath:@"results" statusCodes:statusCodes];
    
    RKObjectManager *sharedManager2 = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager2 addResponseDescriptorsFromArray:@[responseDescriptor2]];
    [ sharedManager2 getObjectsAtPath:[NSString stringWithFormat:@"/3/person/%@/tagged_images",self.person.personID]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                  self.personImages=mappingResult.array;
                                  [self configureView];
                              }
                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                              }];
    
    
    
    RKObjectMapping* movieMapping = [RKObjectMapping mappingForClass:[MOVPersonDetail class]];
    [movieMapping addAttributeMappingsFromDictionary:@{
                                                       @"biography": @"biography",
                                                       @"birthday": @"birthday",
                                                       @"deathday": @"deathday",
                                                       @"id": @"personID",
                                                       @"homepage": @"homepage",
                                                       @"name": @"name",
                                                       @"place_of_birth": @"birthPlace",
                                                       @"profilePath": @"profilePath"
                                                       }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/person/%@",self.person.personID]  keyPath:@"" statusCodes:statusCodes];
    
    RKObjectManager *sharedManager = [[RKObjectManager alloc] initWithHTTPClient:client];    [sharedManager addResponseDescriptorsFromArray:@[responseDescriptor]];
    [ sharedManager getObjectsAtPath:[NSString stringWithFormat:@"/3/person/%@",self.person.personID]  parameters:@{@"api_key" : @"41965971728f5fe48c3a8db464bd3825"}
                             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                               
                                  self.personDetails=[mappingResult.array firstObject];
                                 [self configureView];
                                                              }
                             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                             }];
    

    
    
    
    // https://api.themoviedb.org/3/movies/%d/credits?=
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPerson];
    [self configureView];
    
}




-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"movieCell";
    MOVMovieCollectionViewCell *customCell = (MOVMovieCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    customCell.backgroundColor=[UIColor whiteColor];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
  /*  MOVMovie *mov;
    if([self.movies count])
    {
        pers = [self.cast objectAtIndex:indexPath.row];
        NSURL * urlLower = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", [pers profilePath]]];
        [customCell.img sd_setImageWithURL:urlLower];
        customCell.nameLabel.text=[pers name];
        return customCell;
    }
    else
        return customCell;*/
    customCell.titleLabel.text=[self.person name];
    NSURL * urlLower = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", [self.person profilePath]]];
    [customCell.img sd_setImageWithURL:urlLower];
    return customCell;
}

@end
