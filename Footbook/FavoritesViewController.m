//
//  MasterViewController.m
//  Footbook
//
//  Created by Nicolas Semenas on 13/08/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import "FavoritesViewController.h"

#import "AddNewFavoriteViewController.h"
#import "Feet.h"

@interface FavoritesViewController () 

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation FavoritesViewController


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Feet"];
    
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"liked = %@",[NSNumber numberWithBool: YES]]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext  sectionNameKeyPath:@"name" cacheName:nil ];
    
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
 
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AddNewFavoriteViewController *dvc = segue.destinationViewController;
    dvc.managedObjectContext = self.managedObjectContext ;
}




#pragma mark - Table View


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Feet *this = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = this.name; //[this.feetAmount stringValue];
    return cell;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return [[self.fetchedResultsController.sections objectAtIndex:section]numberOfObjects];
    return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.fetchedResultsController.sections.count;
    return 0;
}


-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    [self.tableView reloadData];
}


@end
