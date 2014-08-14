//
//  DetailViewController.m
//  Footbook
//
//  Created by Nicolas Semenas on 13/08/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import "AddNewFavoriteViewController.h"
#import "AppDelegate.h"


@interface AddNewFavoriteViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AddNewFavoriteViewController



-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([self isCoreDataEmpty]) {
        [self loadCoreDataFromJSON];
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Feet"];
    
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext  sectionNameKeyPath:@"name" cacheName:nil ];
    
    self.fetchedResultsController.delegate = self;
    
    [self.fetchedResultsController performFetch:nil];
}



#pragma mark - Helper Methods

-(BOOL) isCoreDataEmpty{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Feet"];
    
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext  sectionNameKeyPath:@"name" cacheName:@"Footbook" ];
    
    
    //[self.fetchedResultsController performFetch:nil];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    if (results.count == 0) {
        NSLog(@"Core data is empty");
        return YES;
    }
    NSLog(@"Core data is NOT empty, counts:%i",results.count);
    return NO;
    
}

-(void) loadCoreDataFromJSON{
    
    NSURL *url = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/4/friends.json"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSArray * result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        for (NSString *this in result)
        {
            Feet *foot = [NSEntityDescription insertNewObjectForEntityForName:@"Feet"  inManagedObjectContext:self.managedObjectContext];
            foot.name = this;
            foot.feetAmount = [NSNumber numberWithInt: arc4random() %100];
            foot.shoeSize = [NSNumber numberWithInt: arc4random() %11];
            foot.hairiness = [NSNumber numberWithInt: arc4random() %11];
            foot.liked = [NSNumber numberWithInt:0];
        }
        
        NSLog(@"Filling CoreData with data");
        
        [self.managedObjectContext save:nil];
    }
     ];
}




#pragma mark - Table View

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Feet"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[c] %@", cellText];


    [request setPredicate:predicate];
    
    NSArray *result=[self.managedObjectContext executeFetchRequest:request error:nil];
    
    if ([result count] > 0){
        Feet *this = [result objectAtIndex:0];
        this.liked = [NSNumber numberWithInt:1];
        [self.managedObjectContext save:nil];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Feet *this = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = this.name; //[this.feetAmount stringValue];
    return cell;
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.fetchedResultsController.sections objectAtIndex:section]numberOfObjects];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.fetchedResultsController.sections.count;
}


-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    [self.tableView reloadData];
}



@end
