//
//  MOVRatingTableViewCell.m
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVRatingTableViewCell.h"
#import "NSString+FontAwesome.h"
@implementation MOVRatingTableViewCell


- (void)awakeFromNib {
    // Initialization code
    self.apiRateView.notSelectedImage = [UIImage imageNamed:@"redstarnotselected.png"];
    self.apiRateView.halfSelectedImage = [UIImage imageNamed:@"redstarhald.png"];
    self.apiRateView.fullSelectedImage = [UIImage imageNamed:@"redstarfullselected.png"];
    self.userRateView.notSelectedImage = [UIImage imageNamed:@"redstarnotselected.png"];
    self.userRateView.halfSelectedImage = [UIImage imageNamed:@"redstarhald.png"];
    self.userRateView.fullSelectedImage = [UIImage imageNamed:@"redstarfullselected.png"];
    self.apiRateView.rating = 0;
    self.apiRateView.editable = NO;
    self.apiRateView.maxRating = 5;
    self.userRateView.rating = 0;
    self.userRateView.editable = YES;
    self.userRateView.maxRating = 5;
    self.apiRateView.delegate = self;
    self.apiRateView.rating=[self.avg floatValue]/2.;
    
}
- (void) refresh
{
    self.apiRateView.rating=[self.avg floatValue]/2.;
    self.userRateView.rating=[self.rating floatValue]/2.;
    if (self.userRateView.rating==0)
    {
        [self.ratingLabel setHidden:NO];
        [self.ratingButton setHidden:NO];
         self.ratingLabel.text=@"Not Yet Rated";
         [self.ratingButton setTitle:[NSString stringWithFormat:@"%@",[NSString fontAwesomeIconStringForEnum:FAAngleRight]]forState:UIControlStateNormal];
        [self.userRateView setHidden:YES];
    }
    else
    {
        [self.userRateView setHidden:NO];
        [self.ratingLabel setHidden:YES];
        }
}
- (void)rateView:(MOVMovieStarRateView *)rateView ratingDidChange:(float)rating {
    // self.statusLabel.text = [NSString stringWithFormat:@"Rating: %f", rating];
}

@end
