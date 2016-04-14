//
//  NSManagedObject+MagicalRequests.m
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObject+MagicalRequests.h"
#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalThreading.h"

@implementation NSManagedObject (MagicalRequests)


+ (NSFetchRequest *)MR_createFetchRequestInContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[self MR_entityDescriptionInContext:context]];
    
    return request;
}

+ (NSFetchRequest *) MR_createFetchRequest
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	return [self MR_createFetchRequestInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}


+ (NSFetchRequest *) MR_requestAll
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	return [self MR_createFetchRequestInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}

+ (NSFetchRequest *) MR_requestAllInContext:(NSManagedObjectContext *)context
{
	return [self MR_createFetchRequestInContext:context];
}

+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)searchTerm;
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self MR_requestAllWithPredicate:searchTerm inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}

+ (NSFetchRequest *) MR_requestAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
    
    return request;
}

+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)property isEqualTo:(id)value
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self MR_requestAllWhere:property isEqualTo:value inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}

+ (NSFetchRequest *) MR_requestAllWhere:(NSString *)property isEqualTo:(id)value inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", property, value]];
    
    return request;
}

+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)searchTerm
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self MR_requestFirstWithPredicate:searchTerm inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}

+ (NSFetchRequest *) MR_requestFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
    [request setFetchLimit:1];
    
    return request;
}

+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self MR_requestFirstByAttribute:attribute withValue:searchValue inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}

+ (NSFetchRequest *) MR_requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self MR_requestAllWhere:attribute isEqualTo:searchValue inContext:context]; 
    [request setFetchLimit:1];
    
    return request;
}

+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    return [self MR_requestAllSortedBy:sortTerm
                             ascending:ascending
                         withPredicate:nil
                             inContext:context];
}

+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	return [self MR_requestAllSortedBy:sortTerm
                             ascending:ascending
                             inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}

+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAllInContext:context];
	if (searchTerm)
    {
        [request setPredicate:searchTerm];
    }
	[request setFetchBatchSize:[self MR_defaultBatchSize]];
	
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSArray* sortKeys = [sortTerm componentsSeparatedByString:@","];
    for (__strong NSString* sortKey in sortKeys)
    {
        NSArray * sortComponents = [sortKey componentsSeparatedByString:@":"];
        if (sortComponents.count > 1)
          {
              NSNumber * customAscending = sortComponents.lastObject;
              ascending = customAscending.boolValue;
              sortKey = sortComponents[0];
          }
      
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        [sortDescriptors addObject:sortDescriptor];
    }
    
	[request setSortDescriptors:sortDescriptors];
    
	return request;
}

+ (NSFetchRequest *) MR_requestAllGroupBy:(NSString *)groupTerm {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self MR_requestAllGroupBy:groupTerm
                            inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}

+ (NSFetchRequest *) MR_requestAllGroupBy:(NSString *)groupTerm inContext:(NSManagedObjectContext *)context {
    return [self MR_requestAllGroupBy:groupTerm
                             sortedBy:nil
                            ascending:NO
                        withPredicate:nil
                            inContext:context];
}

+ (NSFetchRequest *) MR_requestAllGroupBy:(NSString *)groupTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self MR_requestAllGroupBy:groupTerm
                             sortedBy:sortTerm
                            ascending:ascending
                            inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}

+ (NSFetchRequest *) MR_requestAllGroupBy:(NSString *)groupTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context {
    return [self MR_requestAllGroupBy:groupTerm
                             sortedBy:sortTerm
                            ascending:ascending
                        withPredicate:nil
                            inContext:context];
}

+ (NSFetchRequest *) MR_requestAllGroupBy:(NSString *)groupTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self MR_requestAllGroupBy:groupTerm
                             sortedBy:sortTerm
                            ascending:ascending
                        withPredicate:searchTerm
                            inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop
}


+ (NSFetchRequest *) MR_requestAllGroupBy:(NSString *)groupTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [self MR_requestAllInContext:context];
    if (searchTerm)
    {
        [request setPredicate:searchTerm];
    }
    [request setFetchBatchSize:[self MR_defaultBatchSize]];

    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSArray* sortKeys = [sortTerm componentsSeparatedByString:@","];
    for (__strong NSString* sortKey in sortKeys)
    {
        NSArray * sortComponents = [sortKey componentsSeparatedByString:@":"];
        if (sortComponents.count > 1)
        {
            NSNumber * customAscending = sortComponents.lastObject;
            ascending = customAscending.boolValue;
            sortKey = sortComponents[0];
        }

        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        [sortDescriptors addObject:sortDescriptor];
    }

    [request setSortDescriptors:sortDescriptors];
    if (!groupTerm) return request;

    NSEntityDescription* entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];

    NSMutableArray *groupExceptions = [NSMutableArray new];
    NSMutableArray *groupName = [NSMutableArray new];

    NSArray* groupKeys = [groupTerm componentsSeparatedByString:@","];
    NSMutableArray *fetch = [NSMutableArray new];
    for (__strong NSString* groupKey in groupKeys) {
        [groupName addObject:[entity.attributesByName objectForKey:groupKey]];
        [groupExceptions addObject:[NSExpression expressionForKeyPath:groupKey]];

        [fetch addObject:[entity.attributesByName objectForKey:groupKey]];
    }

    NSExpression *countExpression = [NSExpression expressionForFunction:@"count:" arguments:@[groupExceptions[0]]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName: @"count"];
    [expressionDescription setExpression:countExpression];
    [expressionDescription setExpressionResultType:NSInteger32AttributeType];
    [fetch addObject:expressionDescription];

    [request setPropertiesToFetch:fetch];
    [request setPropertiesToGroupBy:groupName];
    [request setResultType:NSDictionaryResultType];

    return request;
}

+ (NSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm
                                                ascending:ascending
                                            withPredicate:searchTerm 
                                                inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
#pragma clang diagnostic pop

	return request;
}


@end
