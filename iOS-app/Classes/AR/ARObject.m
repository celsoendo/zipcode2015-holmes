//
//  ARObject.m
//  PrometAR
//
// Created by Geoffroy Lesage on 4/24/13.
// Copyright (c) 2013 Promet Solutions Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ARObject.h"
#import "Holmes-Swift.h"


@interface ARObject ()
extern NSString* test;

@end


@implementation ARObject

@synthesize arTitle, distance, imageName;

- (id)initWithId:(int)newId
           title:(NSString*)newTitle
     coordinates:(CLLocationCoordinate2D)newCoordinates
andCurrentLocation:(CLLocationCoordinate2D)currLoc
andUID:(NSString *)uID
{
    self = [super init];
    if (self) {
        arId = newId;
        _uID = uID;
        arTitle = [[NSString alloc] initWithString:newTitle];
        
        lat = newCoordinates.latitude;
        lon = newCoordinates.longitude;
        
        distance = @([self calculateDistanceFrom:currLoc]);
        
        [self.view setTag:newId];
    }
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    return self;
}

-(double)calculateDistanceFrom:(CLLocationCoordinate2D)user_loc_coord
{
    CLLocationCoordinate2D object_loc_coord = CLLocationCoordinate2DMake(lat, lon);
    
    CLLocation *object_location = [[CLLocation alloc] initWithLatitude:object_loc_coord.latitude
                                                              longitude:object_loc_coord.longitude];
    CLLocation *user_location = [[CLLocation alloc] initWithLatitude:user_loc_coord.latitude
                                                            longitude:user_loc_coord.longitude];
    
    return [object_location distanceFromLocation:user_location];
}
-(NSString*)getDistanceLabelText
{
    if (distance.doubleValue > POINT_ONE_MILE_METERS)
         return [NSString stringWithFormat:@"%.2f mi", distance.doubleValue*METERS_TO_MILES];
    else return [NSString stringWithFormat:@"%.0f ft", distance.doubleValue*METERS_TO_FEET];
}

- (NSDictionary*)getARObjectData
{
    NSArray *keys = @[@"id",@"title", @"latitude", @"longitude", @"distance"];
    
    NSArray *values = @[@(arId),
                       arTitle,
                       @(lat),
                       @(lon),
                       distance];
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [titleL setText:arTitle];
    [pillImage setImage:[UIImage imageNamed:imageName]];
    
    [distanceL setText:[self getDistanceLabelText]];
}


#pragma mark -- OO Methods

- (NSString *)description {
    return [NSString stringWithFormat:@"ARObject %d - %@ - lat: %f - lon: %f - distance: %@",
            arId, arTitle, lat, lon, distance];
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {

    test = _uID;
    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *initViewController = [storyBoard instantiateInitialViewController];
//    [self.view.window setRootViewController:initViewController];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HousingInformationViewController *initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HouseInfo"];
    [self.view.window.rootViewController presentViewController:initViewController animated:true completion:nil];
    
//    UIStoryboard *storyBoard = self.storyboard;
//    HousingInformationViewController *houseVC = [storyBoard instantiateViewControllerWithIdentifier:@"HouseInfo"];
//    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: houseVC];
//    // Do whatever setup you want to here for your title bar, etc
//    [nav presentViewController:houseVC animated:true completion:nil];
    [[self navigationController] popToRootViewControllerAnimated:true];
    
    
//    [[self navigationController] performSegueWithIdentifier:@"HouseInformationSegue" sender:[self navigationController]];
}

@end
