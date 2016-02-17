//
//  MOVMovieTableViewCell.m
//  
//
//  Created by Adis Cehajic on 05/02/16.
//
//

#import "MOVMovieTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
@implementation MOVMovieTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

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

- (MOVMovieCollectionViewCell *)collectionView:(UICollectionView *)collectionView
            cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"movieCell";
    MOVMovieCollectionViewCell *customCell = (MOVMovieCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (customCell==nil)
    {
        customCell= [[MOVMovieCollectionViewCell alloc] initWithFrame:CGRectMake(0, 24.5, 175, 245)];
    }
    customCell.backgroundColor=[UIColor whiteColor];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    MOVMovie *mov;
    if([self.movies count])
    {
        mov = [self.movies objectAtIndex:indexPath.row];
         NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[mov releaseDate]];
        customCell.yearLabel.text=[NSString stringWithFormat:@"%ld",(long)[components year]];
        customCell.titleLabel.text=[mov title];
        NSURL * urlLower = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", @"http://image.tmdb.org/t/p/", @"w92", mov.posterPath]];
       // NSData *dataLower = [NSData dataWithContentsOfURL:urlLower];
        //UIImage *imgLower= [[UIImage alloc] initWithData:dataLower];
       // customCell.img.image=imgLower;
        [customCell.img sd_setImageWithURL:urlLower];
        return customCell;
    }
    else
        return customCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   MOVMovieCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
   NSLog([[self.movies objectAtIndex: indexPath.row] title]);
        self.selectedMovie=[self.movies objectAtIndex: indexPath.row];
    [self.delegate selectMovie:self withItem:[self.movies objectAtIndex: indexPath.row]];
   // [super. performSegueWithIdentifier:@"cellShowDetail" sender:self];

 //   self.image = cell.img;
}


@end

