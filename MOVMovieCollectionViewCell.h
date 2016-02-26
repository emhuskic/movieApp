//
//  MOVMovieCollectionViewCell.h
//  
//
//  Created by Adis Cehajic on 05/02/16.
//
//

#import <UIKit/UIKit.h>
#import "MOVMovie.h"
@interface MOVMovieCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) MOVMovie *movie;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end
