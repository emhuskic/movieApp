//
//  MOVRatingTableViewCell.h
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVMovieStarRateView.h"
@interface MOVRatingTableViewCell : UITableViewCell <RateViewDelegate>
@property (weak, nonatomic) IBOutlet MOVMovieStarRateView *apiRateView;
@property (weak, nonatomic) IBOutlet MOVMovieStarRateView *userRateView;
@property (weak, nonatomic) IBOutlet UILabel *avgLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) NSNumber *avg;
@property (strong, nonatomic) NSNumber *rating;
- (void) refresh;
@end
