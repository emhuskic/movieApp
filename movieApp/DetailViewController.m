//
//  DetailViewController.m
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "DetailViewController.h"
#import "MOVMovie.h"
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *upperImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lowerImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {\
        self.title = [self.detailItem title];
        self.titleLabel.text= [self.detailItem title];
        self.releaseDateLabel.text=[self.detailItem releaseDate];
        self.descriptionLabel.text=[self.detailItem overview];
        self.detailDescriptionLabel.text = [self.detailItem tagline];
        NSURL *url = [NSURL URLWithString:@"http://weknowyourdreamz.com/images/sea/sea-08.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        self.upperImage.image=img;
        self.lowerImage.image=img;
        
    }
}
/*
// Movie image
NSURL * urlImage = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", self.m]];
[self.movieImage sd_setImageWithURL:urlImage];

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
