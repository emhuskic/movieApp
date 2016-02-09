//
//  MOVMovieCollectionViewCell.m
//  
//
//  Created by Adis Cehajic on 05/02/16.
//
//

#import "MOVMovieCollectionViewCell.h"

@implementation MOVMovieCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        //set the properties of your element
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
@end
