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
- (NSString*) getServerURL {

    if( _serverURL==nil || _serverURL.length<1) {
        ShuttleDataStore* dataStore=[ShuttleDataStore instance];
        self.serverURL=dataStore.clientSetting.serverIPPort;
    }
    
    if (_serverURL.length<1) _serverURL=[NSString stringWithFormat:@"192.168.0.12:8080"];
    
    return _serverURL;
}

- (bool) setServerURL: (NSString*) serverURL {
    _serverURL=serverURL;
    return true;
}

- (void) callRestPostAPIWithBlock: (RestQueryParamter*) queryParamter  class:(Class)mappedClass
 callback:(void(^) (NSArray*,bool) ) callbackFun
{
    
    
    NSString* serverIP= [self getServerURL];
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
                    
                    callbackFun(busLinesArray,NO);
                    
                }
                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    NSString* errorMsg=[NSString stringWithFormat:@"ErrorMsg=%@", error];
                    
                    NSArray* errArray= [NSArray arrayWithObjects:errorMsg, nil];
                    
                    callbackFun(errArray,YES);
                }];
    
    
}



//get API with block
- (void) callRestGetAPIWithBlock: (RestQueryParamter*) queryParamter  class:(Class)mappedClass  callback:(void(^) (NSArray*, bool) ) callbackFun {
    
    //NSLog(@"start query Shuttlebus location from server");
    
    
    NSString* serverIP= [self getServerURL];
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
            parameters:queryParamter.getMap
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   
                   NSLog(@"Get is sucessful");
                   
                   NSMutableArray *busLinesArray= [NSMutableArray arrayWithArray:mappingResult.array];
                   
                   
                   callbackFun (busLinesArray, NO);
                   
               }
               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@", error);
                   NSString* errorMsg=[NSString stringWithFormat:@"ErrorMsg=%@", error];
                   
                   //[callbackObj reportError:errorMsg];
                   NSArray* errArray=[NSArray arrayWithObjects:errorMsg, nil];
                   callbackFun (errArray,YES);
                   
                   if(operation.HTTPRequestOperation.response.statusCode==200){
                       //do your processing
                   }
               }];
    
    
}


//call RestAPI in async with delegate as callback

- (void) callRestGetAPIAndReturnObjAsArray: (RestQueryParamter*) queryParamter  class:(Class)mappedClass  callback:(id<AsynCallCompletionNotify>) callbackObj {
    
    //NSLog(@"start query Shuttlebus location from server");
    
    
    NSString* serverIP= [self getServerURL];
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

- (void) callRestPostAPIAndReturnObjAsArray: (RestQueryParamter*) queryParamter  class:(Class)mappedClass  callback:(id<AsynCallCompletionNotify>) callbackObj
{
    
    
    NSString* serverIP= [self getServerURL];
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




- (void) getReportedBusLineLocation: (NSString*) lineID  callback:(void(^) (NSArray*, bool) ) callbackFun {
 
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
                               @"userID": @"userID",
                               @"longitude": @"longitude",
                               @"latitude": @"latitude",
                               @"time": @"time",
                               @"altitude":@"altitude"
                               };
    
    queryParameter.getMap = @{
                              @"line":lineID
                              };
    [self callRestGetAPIWithBlock:queryParameter  class:[BusLocationInfo class] callback:callbackFun];
    
}

- (bool) updateMyLocationToServer:(NSString*)line location:(BusLocationInfo*) myLocation callback:(void(^) (NSArray*, bool) ) callbackFun{
    
    RestQueryParamter * queryParameter= [[RestQueryParamter alloc]init];
    queryParameter.uri=@"bus/webresources/";
    queryParameter.path=@"locations";
    
    queryParameter.fieldMap= @{
                                @"userID": @"userID",
                                @"longitude": @"longitude",
                                @"latitude": @"latitude",
                                @"time": @"time",
                                @"altitude":@"altitude"
                                };
    
    NSNumber* latitude= [NSNumber numberWithDouble:myLocation->latitude];
    NSNumber* longitude=[NSNumber numberWithDouble:myLocation->longitude];
    NSNumber* altitude=[NSNumber numberWithDouble:myLocation->altitude];
    
    queryParameter.postMap = @ {
        @"userID": myLocation->userID,
        @"latitude": latitude,
        @"longitude": longitude,
        @"time": myLocation->time,
        @"altitude":altitude,
        @"line":line
    };
    
    [self callRestPostAPIWithBlock:queryParameter  class:[BusLocationInfo class] callback:callbackFun];
    
    return true;
}


//support ShuttleAPI

- (void) getAllBusline:(void (^)(NSArray* objArray,bool isError)) callbackFun
{
    
    //[self callRestAPIAndReturnObjAsArray:@"bus/webresources/" mappedClass:[BusLine class] callback:callbackObj];
    RestQueryParamter * queryParameter= [[RestQueryParamter alloc]init];
    queryParameter.uri=@"bus/webresources/";
    queryParameter.path=@"buslines";
    queryParameter.fieldMap= @{
                               @"busLine": @"busLine",
                               @"seatCount": @"seatCount",
                               @"license":@"license",
                               @"driver":@"driver",
                               @"phone":@"phone"
                               };
    
    [self callRestGetAPIWithBlock:queryParameter  class:[BusInfo class] callback:callbackFun];

    
}



@end
