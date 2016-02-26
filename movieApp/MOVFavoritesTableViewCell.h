//
//  MOVFavoritesTableViewCell.h
//  movieApp
//
//  Created by Adis Cehajic on 17/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//
/*
#import <UIKit/UIKit.h>

@interface MOVFavoritesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
*/

#import <UIKit/UIKit.h>

@interface MOVFavoritesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end
