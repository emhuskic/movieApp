//
//  DetailViewController.m
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "DetailViewController.h"
#import "MOVMovie.h"

#import <SDWebImage/UIImageView+WebCache.h>
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *upperImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lowerImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) MOVMovie *movie;

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

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.title = [self.detailItem title];
        self.titleLabel.text= [self.detailItem title];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self.detailItem releaseDate]];
        
        self.releaseDateLabel.text=[NSString stringWithFormat:@"%ld",[components year]];
        self.descriptionLabel.text=[self.detailItem overview];
        self.detailDescriptionLabel.text = [self.detailItem tagline];
        self.releaseDateLabel.numberOfLines =0;
        [self.releaseDateLabel sizeToFit];
        self.genreLabel.text= [[[self.movie genres] firstObject] name];
      NSURL * urlLower = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", self.movie.posterPath]];
        NSURL *urlUpper = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w1280", self.movie.backdropPath]];
        //NSURL *url = [NSURL URLWithString:str];
        NSData *dataLower = [NSData dataWithContentsOfURL:urlLower];
        UIImage *imgLower= [[UIImage alloc] initWithData:dataLower];
        NSData *dataUpper = [NSData dataWithContentsOfURL:urlUpper];
        UIImage *imgUpper= [[UIImage alloc] initWithData:dataUpper];
        [self.upperImage sd_setImageWithURL:urlUpper];
        [self.lowerImage sd_setImageWithURL:urlLower];
        //self.upperImage.image=imgUpper;
        //self.lowerImage.image=imgLower;
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
