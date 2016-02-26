//
//  MOVMovieCastTableViewCell.m
//  movieApp
//
//  Created by Adis Cehajic on 15/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVMovieCastTableViewCell.h"
#import "MOVMovieCastCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MOVMovieCastTableViewCell()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end
@implementation MOVMovieCastTableViewCell

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cast.count;
}


- (MOVMovieCastCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                        cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"CastCell";
    MOVMovieCastCollectionViewCell *customCell = (MOVMovieCastCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (customCell==nil)
    {
        customCell= [[MOVMovieCastCollectionViewCell alloc] initWithFrame:CGRectMake(0, 24.5, 175, 245)];
    }
    customCell.backgroundColor=[UIColor whiteColor];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    MOVPerson *per;
    if([self.cast count])
    {
        per = [self.cast objectAtIndex:indexPath.row];
        NSURL * urlLower = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", [per profilePath]]];
        
         [customCell.img sd_setImageWithURL:urlLower];
        //customCell.img.layer.backgroundColor=[[UIColor clearColor] CGColor];
        customCell.img.layer.cornerRadius=10;
        customCell.img.layer.borderWidth=0.0;
        customCell.img.layer.masksToBounds = YES;
        customCell.img.layer.borderColor=[[UIColor clearColor] CGColor];
        customCell.nameLabel.text=[per name];
        
        return customCell;
    }
    else
        return customCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   [self.delegate selectCast:self withItem:[self.cast objectAtIndex:indexPath.row]];
}

- (void) refreshCollection
{
    [self.collectionView reloadData];
}
@end
