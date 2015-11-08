//
//  ViewController.m
//  PRAR-Simple
//
//  Created by Geoffroy Lesage on 3/27/14.
//  Copyright (c) 2014 Promet Solutions Inc,. All rights reserved.
//

#import "ViewController.h"

#include <stdlib.h>


#define NUMBER_OF_POINTS    20


@interface ViewController ()

@property (nonatomic, strong) PRARManager *prARManager;

@end


@implementation ViewController


- (void)alert:(NSString*)title withDetails:(NSString*)details {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:details
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the manager so it wakes up (can do this anywhere you want
    self.prARManager = [[PRARManager alloc] initWithSize:self.view.frame.size delegate:self showRadar:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    // Initialize your current location as 0,0 (since it works with our randomly generated locations)
    CLLocationCoordinate2D locationCoordinates = CLLocationCoordinate2DMake(0, 0);
    

    [self getLocations];
//    [self.prARManager startARWithData:[self getDummyData] forLocation:locationCoordinates];

}

-(void) getLocations {
    CLLocationManager *locationManager;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    double myLat = 33.424303; //locationManager.location.coordinate.latitude;
    double myLng = -111.929040; //locationManager.location.coordinate.longitude;
    
    //create the url to call
    NSString *APIstring = [NSString stringWithFormat:@"https://zipcode-rece.c9users.io:8080/api/retsly/listings?lat=%f&lon=%f", myLat, myLng];
    NSLog(APIstring);
    NSURL *infoURL = [[NSURL alloc] initWithString:APIstring];
    NSURLRequest *infoRequest = [[NSURLRequest alloc] initWithURL:infoURL];
    [NSURLConnection sendAsynchronousRequest:infoRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //handle sercer response
        NSError *error= [[NSError alloc] init];
        if (connectionError!=nil) {
            NSLog(@"connection error");
        } else {
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSDictionary *results = object;
            
            [self parseLocationReturn:results];
        }
    }];
    

}

-(void) parseLocationReturn:(NSDictionary *)data {
    
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:NUMBER_OF_POINTS];
    
    NSArray* locations = [data objectForKey:@"bundle"];
    
    //replace all objects with our new set of objects
    //[[PARController sharedARController] clearObjects];
    NSLog(@"LOCATIONS COUNT: %lu",(unsigned long)[locations count]);
    for(int i = 0; i < [locations count]; i ++) {
        NSDictionary* thisLocation = [locations objectAtIndex:i];
        NSString* title = [thisLocation objectForKey:@"baths"];
        NSString* subtitle = [thisLocation objectForKey:@"address"];
        NSArray* coordinates = [thisLocation objectForKey:@"coordinates"];
        double lat = [[coordinates objectAtIndex:1] doubleValue];
        double lng = [[coordinates objectAtIndex:0] doubleValue];
        
        //        [[PARController sharedARController] addObject:[[poiLabelClass alloc] initWithTitle:title
        //                                                                            theDescription:subtitle
        //                                                                                atLocation:[[CLLocation alloc] initWithLatitude:lat longitude:lng]
        //                                                       ]];
        NSDictionary *point = @{
                                @"id" : @(i),
                                @"title" : [NSString stringWithFormat:@"Place Num %d", i],
                                @"lon" : @(lng),
                                @"lat" : @(lat)
                                };
        [points addObject:point];
        NSLog(@"added a location");
    }
    CLLocationCoordinate2D locationCoordinates = CLLocationCoordinate2DMake(33.424303, -111.929040);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.prARManager startARWithData:[NSArray arrayWithArray:points] forLocation:locationCoordinates];
    });

}





#pragma mark - Dummy AR Data

// Creates data for `NUMBER_OF_POINTS` AR Objects
-(NSArray*)getDummyData
{
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:NUMBER_OF_POINTS];
    
    srand48(time(0));
    for (int i=0; i<NUMBER_OF_POINTS; i++)
    {
//        CLLocationCoordinate2D pointCoordinates = [self getRandomLocation];
//        NSDictionary *point = [self createPointWithId:i at:pointCoordinates];
        
        
        
//        [points addObject:point];
    }
    
    return [NSArray arrayWithArray:points];
}

// Returns a random location
-(CLLocationCoordinate2D)getRandomLocation
{
    double latRand = drand48() * 90.0;
    double lonRand = drand48() * 180.0;
    double latSign = drand48();
    double lonSign = drand48();
    
    CLLocationCoordinate2D locCoordinates = CLLocationCoordinate2DMake(latSign > 0.5 ? latRand : -latRand,
                                                                       lonSign > 0.5 ? lonRand*2 : -lonRand*2);
    return locCoordinates;
}

// Creates the Data for an AR Object at a given location
-(NSDictionary*)createPointWithId:(int)the_id at:(CLLocationCoordinate2D)locCoordinates
{
    NSDictionary *point = @{
                            @"id" : @(the_id),
                            @"title" : [NSString stringWithFormat:@"Place Num %d", the_id],
                            @"lon" : @(locCoordinates.longitude),
                            @"lat" : @(locCoordinates.latitude)
                           };
    return point;
}


#pragma mark - PRARManager Delegate

-(void)prarDidSetupAR:(UIView *)arView withCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer andRadarView:(UIView *)radar
{
    NSLog(@"Finished displaying ARObjects");
    
    [self.view.layer addSublayer:cameraLayer];
    [self.view addSubview:arView];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:AR_VIEW_TAG]];
    
    [self.view addSubview:radar];
    
    [loadingV setHidden:YES];
}

-(void)prarUpdateFrame:(CGRect)arViewFrame
{
    [[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
}

-(void)prarGotProblem:(NSString *)problemTitle withDetails:(NSString *)problemDetails
{
    [loadingV setHidden:YES];
    [self alert:problemTitle withDetails:problemDetails];
}

@end
