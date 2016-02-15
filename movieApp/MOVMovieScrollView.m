//
//  MOVMovieScrollView.m
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVMovieScrollView.h"
#import "MOVMovieCastCollectionViewCell.h"
#import "MOVPerson.h"

#import <SDWebImage/UIImageView+WebCache.h>
@implementation MOVMovieScrollView



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cast.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"castCell";
    MOVMovieCastCollectionViewCell *customCell = (MOVMovieCastCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    customCell.backgroundColor=[UIColor whiteColor];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    MOVPerson *pers;
    if([self.cast count])
    {
        pers = [self.cast objectAtIndex:indexPath.row];
        NSURL * urlLower = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", [pers profilePath]]];
        [customCell.img sd_setImageWithURL:urlLower];
        customCell.nameLabel.text=[pers name];
        return customCell;
    }
    else
        return customCell;
}



@end
