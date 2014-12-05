//
//  ShareObject.m
//  Locator
//
//  Created by Pujun Wu on 14/11/2.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import "ShareObject.h"
#import "ClientSetting.h"

@implementation ResultObject

@synthesize status,errorMsg, dataType,returnObject;


@end

 

@implementation MyLocation

@synthesize coordinate=_coordinate,title=_title;


-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t{
    self = [super init];
    if(self){
        _coordinate = c;
        _title = t;
    }
    return self;
}

@end

//
@implementation UserClientSetting

@synthesize userName,lineID,freshInterval,reportTimeWindows,serverIPPort;


@end


//implementation of singleton global UserStore
static ShuttleDataStore *_instance=nil;

@implementation ShuttleDataStore

@synthesize managedObjectContext =_managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize locationManager=_locationManager;
@synthesize isRunningInBackground=_isRunningInBackground;

@synthesize busLines;

+ (id) instance{
    @synchronized(self) {
        if (_instance==nil) {
            _instance= [[self alloc] init];
        }
    }
    return _instance;
}


- (void) saveToLocal{
    ClientSetting *clientSetting = [NSEntityDescription insertNewObjectForEntityForName:@"ClientSetting" inManagedObjectContext:_managedObjectContext];
   
    clientSetting.serverIP=_clientSetting.serverIPPort;
    clientSetting.userName=_clientSetting.userName;
    clientSetting.interval= [NSNumber numberWithInteger:_clientSetting.freshInterval];
    clientSetting.shuttleLine=_clientSetting.lineID;
    
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

- (void) loadFromLocal {
 
    // Override point for customization after application launch.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ClientSetting" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSString *userName;
    NSString *serverIP;
    NSInteger freshInterval;
    NSString* lineID;
    
    NSArray *fetchObject = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        userName=[info valueForKey:@"userName"];
        serverIP=[info valueForKey:@"serverIP"];
        NSNumber *v=[info valueForKey:@"interval"];
        lineID=[info valueForKey:@"shuttleLine"];

        freshInterval= v.integerValue;
        NSLog(@"userName: %@",userName);
        NSLog(@"serverIP:%@",serverIP);
        NSLog(@"refresh interval:%d",freshInterval);
        NSLog(@"shuttleLine:%@",lineID);
    }
    
    ShuttleDataStore* dataStore=[ShuttleDataStore instance];
    dataStore.clientSetting.serverIPPort = serverIP;
    dataStore.clientSetting.userName= userName;
    dataStore.clientSetting.freshInterval=freshInterval;
    dataStore.clientSetting.lineID=lineID;
    
}

- (id) init {
    
    self= [ super init];
    
    self.clientSetting = [[UserClientSetting alloc] init];
    //self.clientSetting.serverIPPort= [ NSString stringWithFormat:<#(NSString *), ...#>]
    
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    return nil;
}

//copy返回单例本身
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


//support core data
//support core data
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext =self.managedObjectContext;
    if (managedObjectContext !=nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolvederror %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext !=nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel !=nil) {
        return _managedObjectModel;
    }
    //这里一定要注意，这里的iWeather就是你刚才建立的数据模型的名字，一定要一致。否则会报错。
    NSURL *modelURL = [[NSBundle mainBundle]URLForResource:@"usersetting" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator !=nil) {
        return _persistentStoreCoordinator;
    }
    //这里的iWeaher.sqlite，也应该与数据模型的名字保持一致。
    NSURL *storeURL = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"usersetting.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolvederror %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
- (NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
}


@end


