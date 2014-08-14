//
//  Feet.h
//  Footbook
//
//  Created by Nicolas Semenas on 13/08/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Feet : NSManagedObject

@property (nonatomic, retain) NSNumber * feetAmount;
@property (nonatomic, retain) NSNumber * hairiness;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * shoeSize;
@property (nonatomic, retain) NSNumber * liked;

@end
