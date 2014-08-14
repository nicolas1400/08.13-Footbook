//
//  DetailViewController.h
//  Footbook
//
//  Created by Nicolas Semenas on 13/08/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritesViewController.h"
#import "Feet.h"



@interface AddNewFavoriteViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Feet * feet;


@end
