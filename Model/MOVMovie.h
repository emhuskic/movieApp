//
//  MOVMovie.h
//  movieApp
//
//  Created by Adis Cehajic on 02/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOVGenre.h"
#import "MOVProductionCompany.h"

@interface MOVMovie : NSObject

//@property (nonatomic) NSUInteger *id;
@property (nonatomic) BOOL adult;
@property (nonatomic, strong) NSString *backdropPath;
@property (nonatomic, strong) NSString *belongsToCollection;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSString *homepage;
@property (nonatomic, strong) NSString *originalLanguage;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *imdbID;
@property (nonatomic, strong) NSString *originalTitle;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSArray *productionCompanies;
@property (nonatomic, strong) NSString *popularity;
@property (nonatomic, strong) NSArray *productionCountries;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *revenue;
@property (nonatomic, strong) NSArray *spokenLanguages;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) BOOL video;

//@property (nonatomic) NSUInteger *voteCount;
@property (nonatomic, strong) NSNumber *voteAverage;
@end
