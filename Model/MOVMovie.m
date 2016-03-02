//
//  MOVMovie.m
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVMovie.h"

@interface MOVMovie()
@end

@implementation MOVMovie

- (id) init
{
    self=[super init];
    self.isFavorite=NO;
    return self;
}

- (id) initWithRLMObject:(MOVRealmMovie *)RLMmov
{
    self=[super init];
    self.posterPath=RLMmov.posterPath;
    self.title=RLMmov.title;
    self.genres=[[NSMutableArray alloc] init];
    for (int i=0; i<[[RLMmov genres] count]; i++)
    {
        [self.genres addObject:[[[RLMmov genres] objectAtIndex:i] genreID]];
    }
    self.originalLanguage=RLMmov.originalLanguage;
    self.originalTitle=RLMmov.originalTitle;
    self.popularity=RLMmov.popularity;
    self.voteCount=RLMmov.voteCount;
    self.releaseDate=RLMmov.releaseDate;
    self.backdropPath=RLMmov.backdropPath;
    self.belongsToCollection=RLMmov.belongsToCollection;
    self.revenue=RLMmov.revenue;
    self.overview=RLMmov.overview;
    self.movID=RLMmov.movID;
    self.imdbID=RLMmov.imdbID;
    self.isFavorite=RLMmov.isFavorite;
    self.voteAverage=RLMmov.voteAverage;
    self.userRating=RLMmov.userRating;
    return self;
}

@end
