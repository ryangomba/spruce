//
//  NSDictionary+Safe.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@interface NSDictionary (Safe)

- (id)objectOrNilForKey:(NSString *)key;

@end
