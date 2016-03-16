//
//  MOVRealmVisitedMovie.m
//  movieApp
//
//  Created by Adis Cehajic on 16/03/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVRealmVisitedMovie.h"
#import "MOVMovie.h"

@implementation MOVRealmVisitedMovie
- (id) initWithMOVObject:(MOVMovie *)mov
{
    self=[super init];
    self.posterPath=mov.posterPath;
    self.title=mov.title;
    // self.genres=[[RLMArray alloc] initWithObjectClassName:@"MOVRealmGenre"];
    //[self.genres addObjects:mov.genres];
    for (int i=0; i<[[mov genres] count]; i++)
    {
        [self.genres addObject:[[MOVRealmGenre alloc] initWithMOVGenre:[[mov genres] objectAtIndex:i] ]];
        
    }
    self.originalLanguage=mov.originalLanguage;
    self.originalTitle=mov.originalTitle;
    self.popularity=mov.popularity;
    self.voteCount=mov.voteCount;
    self.releaseDate=mov.releaseDate;
    self.backdropPath=mov.backdropPath;
    self.belongsToCollection=mov.belongsToCollection;
    self.revenue=mov.revenue;
    self.overview=mov.overview;
    self.movID=mov.movID;
    self.imdbID=mov.imdbID;
    self.isFavorite=mov.isFavorite;
    self.voteAverage=mov.voteAverage;
    self.userRating=mov.userRating;
    self.lastVisited=mov.lastVisited;
    return self;
}
@end
