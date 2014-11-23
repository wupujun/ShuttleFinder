//
//  RestRequestor.m
//  BusFinder
//
//  Created by Pujun Wu on 14/11/9.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import "RestRequestor.h"

@implementation RestQueryParamter

@synthesize path,uri,fieldMap;

@end

@implementation RestRequestor
@synthesize delegate;

-(id) init {
    
    self= [super init];
    delegate=nil;
    return self;
}

//local method
+ (NSString*) getServerAddress {
    
    ShuttleDataStore* dataStore=[ShuttleDataStore instance];
    NSString* serverIP=dataStore.clientSetting.serverIPPort;

    
    if (serverIP.length<1) serverIP=[NSString stringWithFormat:@"192.168.0.12:8080"];
    return serverIP;
}

+ (bool) setServerAddress: (NSString*) serverIP {
    
    return true;
}


//remote method
- (void) getBusLineList : (id<AsynCallCompletionNotify>) callbackObj {
    
    //[self callRestAPIAndReturnObjAsArray:@"bus/webresources/" mappedClass:[BusLine class] callback:callbackObj];
    RestQueryParamter * queryParameter= [[RestQueryParamter alloc]init];
    queryParameter.uri=@"bus/webresources/";
    queryParameter.path=@"buslines";
    queryParameter.fieldMap= @{
                               @"driverName": @"driverName",
                               @"lineName": @"lineName"
                               };
    
    [self callRestAPIAndReturnObjAsArray:queryParameter  class:[BusLine class] callback:callbackObj];

}

- (void) callRestAPIAndReturnObjAsArray: (RestQueryParamter*) queryParamter  class:(Class)mappedClass  callback:(id<AsynCallCompletionNotify>) callbackObj {
    
    //NSLog(@"start query Shuttlebus location from server");
    
    
    NSString* serverIP= [RestRequestor getServerAddress];
    NSString* busLineURL= [NSString stringWithFormat:@"http://%@/%@",serverIP, queryParamter.uri];
    
    
    RKObjectManager *manager =  [RKObjectManager managerWithBaseURL:[NSURL URLWithString:busLineURL]];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    [manager setAcceptHeaderWithMIMEType: @"*/*"];
    [manager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    
    RKObjectMapping* objMapping = [RKObjectMapping mappingForClass:mappedClass];
    [objMapping addAttributeMappingsFromDictionary: queryParamter.fieldMap];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@"returnObject"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObject:nil
                  path:queryParamter.path
            parameters:nil
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   
                   NSLog(@"Get is sucessful");
                   
                   NSMutableArray *busLinesArray= [NSMutableArray arrayWithArray:mappingResult.array];
                   
                   
                   [callbackObj getReturnedObjectArray:busLinesArray];
                   /* for (Location* postion in locArray)
                    {
                    NSLog(@"%@'s postion:  Longitude=%@,Latitude=%@ on %@", postion.userID, postion.longitude,postion.latitude, postion.time);
                    }*/
                   
               }
               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@", error);
                   NSString* errorMsg=[NSString stringWithFormat:@"ErrorMsg=%@", error];
                   
                   [callbackObj reportError:errorMsg];
                   
                   if(operation.HTTPRequestOperation.response.statusCode==200){
                       //do your processing
                   }
               }];
    

}

- (void) callPostAPIAndReturnObjAsArray: (RestQueryParamter*) queryParamter  class:(Class)mappedClass  callback:(id<AsynCallCompletionNotify>) callbackObj
{
    
    
    NSString* serverIP= [RestRequestor getServerAddress];
    NSString* busLineURL= [NSString stringWithFormat:@"http://%@/%@",serverIP, queryParamter.uri];
    
    
    RKObjectManager *manager =  [RKObjectManager managerWithBaseURL:[NSURL URLWithString:busLineURL]];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    [manager setAcceptHeaderWithMIMEType: @"*/*"];
    //[manager setRequestSerializationMIMEType:RKMIMETypeJSON];
    [manager setRequestSerializationMIMEType:RKMIMETypeFormURLEncoded];
    
    RKObjectMapping* objMapping = [RKObjectMapping mappingForClass:mappedClass];
    [objMapping addAttributeMappingsFromDictionary:nil];//queryParamter.fieldMap];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:objMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:@"returnObject"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    [manager addResponseDescriptor:responseDescriptor];
    
    
    [manager postObject: nil
            path:queryParamter.path
            parameters:queryParamter.postMap
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   
                   NSLog(@"post is sucessful");
                   
                   NSMutableArray *busLinesArray= [NSMutableArray arrayWithArray:mappingResult.array];
                   
                   [callbackObj getReturnedObjectArray:busLinesArray];
                   
               }
               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@", error);
                   NSString* errorMsg=[NSString stringWithFormat:@"ErrorMsg=%@", error];
                   
                   [callbackObj reportError:errorMsg];
                   
                   if(operation.HTTPRequestOperation.response.statusCode==200){
                       //do your processing
                   }
               }];

    
}


- (void) getReportedBusLineLocation: (NSString*) lineID  callback:(id<AsynCallCompletionNotify>) callbackObj {
 
    RestQueryParamter * queryParameter= [[RestQueryParamter alloc]init];
    queryParameter.uri=@"bus/webresources/";
    queryParameter.path=@"locations";

    
  /* 
   json Object returned:     latitude":"37.337600","longitude":"-122.035901","userID":"user1","time":"2014-11-16 01:44:33"
   
    class attributes:
    @property (strong,nonatomic) NSString* latitude;
    @property (strong,nonatomic) NSString* longitude;
    @property (strong,nonatomic) NSString* reportedUserID;
    @property (strong,nonatomic) NSString* reportedTime;
    @property (strong,nonatomic) NSString* locationName;
*/
    queryParameter.fieldMap= @{
                               @"latitude": @"latitude",
                               @"longitude": @"longitude",
                               @"reportedUserID": @"userID",
                               @"reportedTime":@"time"
                               };
    
    [self callRestAPIAndReturnObjAsArray:queryParameter  class:[Location class] callback:callbackObj];
    
}
- (bool) updateMyLocationToServer: (Location*) myLocation callback:(id<AsynCallCompletionNotify>) callbackObj{
    
    RestQueryParamter * queryParameter= [[RestQueryParamter alloc]init];
    queryParameter.uri=@"bus/webresources/";
    queryParameter.path=@"locations";
    
    queryParameter.fieldMap= @{
                                @"userID": @"userID",
                                @"longitude": @"longitude",
                                @"latitude": @"latitude",
                                @"time": @"time"
                                };
    
    queryParameter.postMap = @ {
        @"userID": myLocation.reportedUserID,
        @"Lat": myLocation.latitude,
        @"Long": myLocation.longitude
        //@"time": myLocation.reportedTime
    };
    
    [self callPostAPIAndReturnObjAsArray:queryParameter  class:[Location class] callback:callbackObj];
    
    return true;
}


@end
