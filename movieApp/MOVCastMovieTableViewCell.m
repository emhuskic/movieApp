//
//  MOVCastMovieTableViewCell.m
//  movieApp
//
//  Created by Adis Cehajic on 16/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVCastMovieTableViewCell.h"
#import "MOVCastMovieCollectionViewCell.h"

@implementation MOVCastMovieTableViewCell

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (MOVCastMovieCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                        cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"CastMovieCell";
    MOVCastMovieCollectionViewCell *customCell = (MOVCastMovieCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (customCell==nil)
    {
        customCell= [[MOVCastMovieCollectionViewCell alloc] initWithFrame:CGRectMake(0, 24.5, 175, 245)];
    }
    customCell.backgroundColor=[UIColor whiteColor];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    MOVMovie *mov;
    if([self.movies count])
    {
        mov = [self.movies objectAtIndex:indexPath.row];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[mov releaseDate]];
        //customCell.yearLabel.text=[NSString stringWithFormat:@"%ld",(long)[components year]];
        customCell.titleLabel.text=[mov title];
        NSURL * urlLower = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", mov.posterPath]];
        // NSData *dataLower = [NSData dataWithContentsOfURL:urlLower];
        //UIImage *imgLower= [[UIImage alloc] initWithData:dataLower];
        // customCell.img.image=imgLower;
        [customCell.img sd_setImageWithURL:urlLower placeholderImage:[UIImage imageNamed:@"imgplaceholder.png"]];
        customCell.img.layer.cornerRadius=10;
        customCell.img.layer.borderWidth=0.0;
        customCell.img.layer.masksToBounds = YES;
        customCell.img.layer.borderColor=[[UIColor clearColor] CGColor];
        return customCell;
    }
    else
        return customCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate selectCastMovie:self withItem:[self.movies objectAtIndex:indexPath.row]];
}



- (void) refreshCollection
{
    [self.collectionView reloadData];
}
@end
