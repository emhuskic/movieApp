//
//  MOVRealmVisitedMovie.h
//  movieApp
//
//  Created by Adis Cehajic on 16/03/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <Realm/Realm.h>
#import "MOVRealmGenre.h"
RLM_ARRAY_TYPE(MOVRealmGenre)
@class MOVMovie;
@interface MOVRealmVisitedMovie : RLMObject
//
//  MOVRealmMovie.h
//  movieApp
//
//  Created by Adis Cehajic on 17/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//
@property  NSNumber<RLMBool>* adult;
@property  NSNumber<RLMInt> *movID;
@property  NSString *backdropPath;
@property  NSString *belongsToCollection;
@property RLMArray<MOVRealmGenre*><MOVRealmGenre> *genres;
@property  NSString *homepage;
@property  NSString *originalLanguage;
@property  NSString *overview;
@property  NSString *imdbID;
@property  NSString *originalTitle;
@property  NSString *posterPath;
//@property  NSArray *productionCompanies;
@property  NSString *popularity;
//@property  NSArray *productionCountries;
@property  NSDate *releaseDate;
@property  NSString *revenue;
//@property  NSArray *spokenLanguages;
@property  NSString *status;
@property  NSString *tagline;
@property  NSString *title;
@property  NSNumber<RLMDouble> *voteCount;
@property  NSNumber<RLMDouble> *voteAverage;
@property  BOOL video;
@property BOOL isFavorite;
@property NSNumber<RLMDouble> *userRating;
@property NSDate *lastVisited;
- (id) initWithMOVObject:(MOVMovie *)mov;
@end
