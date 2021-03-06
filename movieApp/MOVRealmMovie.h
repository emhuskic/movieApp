//
//  MOVRealmMovie.h
//  movieApp
//
//  Created by Adis Cehajic on 17/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import "MOVMovie.h"
#import <Realm/Realm.h>
#import "MOVRealmGenre.h"
@class MOVMovie;
/*
 @property BOOL value;	@property NSNumber<RLMBool> *value;
 Int	@property int value;	@property NSNumber<RLMInt> *value;
 Float	@property float value;	@property NSNumber<RLMFloat> *value;
 Double	@property double value;	@property NSNumber<RLMDouble> *value;
 String	@property NSString *value; †	@property NSString *value;
 Data	@property NSData *value; †	@property NSData *value;
 Date	@property NSDate *value; †	@property NSDate *value;
 Object	n/a: must be optional	@property Object *value;*/

RLM_ARRAY_TYPE(MOVRealmGenre)
@interface MOVRealmMovie : RLMObject
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

