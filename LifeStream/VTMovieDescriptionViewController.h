//
//  VTMovieDescriptionViewController.h
//  LifeStream
//
//  Created by Vasily Timofeev on 08.05.2018.
//  Copyright © 2018 Vasily Timofeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTMovie.h"

@interface VTMovieDescriptionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *movieBigPosterImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitlelabel;
@property (weak, nonatomic) IBOutlet UILabel *movieDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) VTMovie *movie;

@end
