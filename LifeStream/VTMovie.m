//
//  VTMovie.m
//  LifeStream
//
//  Created by Vasily Timofeev on 08.05.2018.
//  Copyright © 2018 Vasily Timofeev. All rights reserved.
//

#import "VTMovie.h"
#import "VTAPIConstants.h"

@implementation VTMovie

- (instancetype)initFromResponse: (NSDictionary *) response {
    self = [super init];
    if (self) {
        self.movieTitle = [response objectForKey:SERVER_RESPONSE_MOVIE_TITLE_FIELD_NAME];
        self.movieDescription = [response objectForKey:SERVER_RESPONSE_MOVIE_OVERVIEW_FIELD_NAME];
        
        NSString *moviePosterPath = [response objectForKey:SERVER_RESPONSE_MOVIE_POSTER_PATH_FIELD_NAME];
        self.movieSmallPosterPath = [NSString stringWithFormat:GET_SERVER_REQUEST_MOVIE_SMALL_POSTER, moviePosterPath];
        self.movieBigPosterPath = [NSString stringWithFormat:GET_SERVER_REQUEST_MOVIE_BIG_POSTER, moviePosterPath];
        
        self.isEmptyMovie = NO;
    }
    return self;
}

@end
