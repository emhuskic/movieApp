//
//  MOVCastMovieCollectionViewCell.h
//  movieApp
//
//  Created by Adis Cehajic on 16/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOVMovie.h"

@interface MOVCastMovieCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) MOVMovie *movie;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@end
