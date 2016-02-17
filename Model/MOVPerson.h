//
//  MOVPerson.h
//  movieApp
//
//  Created by Adis Cehajic on 10/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOVPerson : NSObject
@property (strong, nonatomic) NSNumber *castID;
@property (strong, nonatomic) NSString *character;
@property (strong, nonatomic) NSString *creditID;
@property (strong, nonatomic) NSNumber *personID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *order;
@property (strong, nonatomic) NSString *profilePath;
@property (strong, nonatomic) NSDate *birthDate;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *biography;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSDate *deathday;
@property (strong, nonatomic) NSString *homepage;
@property (strong, nonatomic) NSString *birthPlace;
@property (strong, nonatomic) NSString *filePath;
@end
