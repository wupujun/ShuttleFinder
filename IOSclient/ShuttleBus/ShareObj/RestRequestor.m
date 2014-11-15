//
//  RestRequestor.m
//  BusFinder
//
//  Created by Pujun Wu on 14/11/9.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import "RestRequestor.h"

@implementation RestRequestor
@synthesize delegate;

-(id) init {
    
    self= [super init];
    delegate=nil;
    return self;
}

//local method
+ (NSString*) getServerAddress {
    NSString* serverIP= [NSString stringWithFormat:@"192.168.0.12:8080"];
    return serverIP;
}

+ (bool) setServerAddress: (NSString*) serverIP {
    
    return true;
}


//remote method
- (void) getBusLineList : (id<AsynCallCompletionNotify>) callbackObj {
    
    [self callRestAPIAndReturnObjAsArray:@"bus/webresources/" mappedClass:[BusLine class] callback:callbackObj];

}

- (void) callRestAPIAndReturnObjAsArray: (NSString*) restURI : (Class) mappedClass : (id<AsynCallCompletionNotify>) callback {
    NSLog(@"start query Shuttlebus location from server");
    
    //delegate=callbakcObj;
    
    NSString* serverIP= [RestRequestor getServerAddress];
    //NSString* busLineURL= [NSString stringWithFormat:@"http://%@/bus/webresources/",serverIP];
    NSString* busLineURL= [NSString stringWithFormat:@"http://%@/%@",serverIP, restURI];
    
    
    RKObjectManager *manager =  [RKObjectManager managerWithBaseURL:[NSURL URLWithString:busLineURL]];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    [manager setAcceptHeaderWithMIMEType: @"*/*"];
    [manager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    
    RKObjectMapping* objMapping = [RKObjectMapping mappingForClass:mappedClass];
    [objMapping addAttributeMappingsFromDictionary:@{
                                                         @"driverName": @"driverName",
                                                         @"lineName": @"lineName"
                                                         }];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@"returnObject"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObject:nil
                  path:@"buslines"
            parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   
                   NSLog(@"Get is sucessful");
                   
                   NSMutableArray *busLinesArray= [NSMutableArray arrayWithArray:mappingResult.array];
                   
                   
                   [callback setObjectArray:busLinesArray];
                   /* for (Location* postion in locArray)
                    {
                    NSLog(@"%@'s postion:  Longitude=%@,Latitude=%@ on %@", postion.userID, postion.longitude,postion.latitude, postion.time);
                    }*/
                   
               }
               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@", error);
                   if(operation.HTTPRequestOperation.response.statusCode==200){
                       //do your processing
                   }
               }];
    

}


+ (Location*) getReportedBusLineLocation: (NSString*) lineID {
    
    return nil;
}
+ (bool) updateMyLocationToServer: (Location*) myLocation {
    
    return true;
}


@end
