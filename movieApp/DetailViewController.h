//
//  DetailViewController.h
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVMovie.h"
#import "MOVMovieStarRateView.h"
#import "MOVMovieCastCollectionViewCell.h"
@interface DetailViewController : UIViewController <RateViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (strong, nonatomic) MOVMovie *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet MOVMovieStarRateView *rateView;
@property (weak, nonatomic) IBOutlet MOVMovieStarRateView *userRateView;

@end

