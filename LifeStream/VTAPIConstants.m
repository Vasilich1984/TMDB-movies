//
//  VTAPIConstants.m
//  LifeStream
//
//  Created by Vasily Timofeev on 08.05.2018.
//  Copyright © 2018 Vasily Timofeev. All rights reserved.
//

#import "VTAPIConstants.h"

//requests
NSString *const GET_SERVER_REQUEST_MOVIES_DISCOVER = @"https://api.themoviedb.org/3/discover/movie";
NSString *const GET_SERVER_REQUEST_MOVIE_SMALL_POSTER = @"https://image.tmdb.org/t/p/w154%@";
NSString *const GET_SERVER_REQUEST_MOVIE_BIG_POSTER = @"https://image.tmdb.org/t/p/w500%@";


//fields request
NSString *const SERVER_REQUEST_API_KEY_FIELD_NAME = @"api_key";
NSString *const SERVER_REQUEST_LANGUAGE_FIELD_NAME = @"language";
NSString *const SERVER_REQUEST_SORT_BY_FIELD_NAME = @"sort_by";
NSString *const SERVER_REQUEST_PAGE_FIELD_NAME = @"page";

NSString *const SERVER_REQUEST_API_KEY_FIELD_VALUE = @"29d41ba3944eac9c980f0c79d84863ce";
NSString *const SERVER_REQUEST_LANGUAGE_FIELD_VALUE = @"en-US";
NSString *const SERVER_REQUEST_SORT_BY_FIELD_VALUE = @"revenue.desc";

//fields response
NSString *const SERVER_RESPONSE_RESULTS_FIELD_NAME = @"results";
NSString *const SERVER_RESPONSE_TOTAL_PAGES_FIELD_NAME = @"total_pages";
NSString *const SERVER_RESPONSE_MOVIE_TITLE_FIELD_NAME = @"title";
NSString *const SERVER_RESPONSE_MOVIE_OVERVIEW_FIELD_NAME = @"overview";
NSString *const SERVER_RESPONSE_MOVIE_POSTER_PATH_FIELD_NAME = @"poster_path";

