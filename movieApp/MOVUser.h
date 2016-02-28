//
//  MOVUser.h
//  movieApp
//
//  Created by Adis Cehajic on 24/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOVUser : NSObject
@property (strong, nonatomic) NSNumber *userID;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *requestToken;
@property (strong, nonatomic) NSString *sessionID;
@property (strong, nonatomic) NSString *name;
@end
