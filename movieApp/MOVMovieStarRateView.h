//
//  MOVMovieStarRateView.h
//  movieApp
//
//  Created by Adis Cehajic on 10/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOVMovieStarRateView;

@protocol RateViewDelegate
- (void)rateView:(MOVMovieStarRateView *)rateView ratingDidChange:(float)rating;
@end

@interface MOVMovieStarRateView : UIView

@property (strong, nonatomic) UIImage *notSelectedImage;
@property (strong, nonatomic) UIImage *halfSelectedImage;
@property (strong, nonatomic) UIImage *fullSelectedImage;
@property (assign, nonatomic) float rating;
@property (assign) BOOL editable;
@property (strong) NSMutableArray * imageViews;
@property (assign, nonatomic) int maxRating;
@property (assign) int midMargin;
@property (assign) int leftMargin;
@property (assign) CGSize minImageSize;
@property (assign) id <RateViewDelegate> delegate;

@end
