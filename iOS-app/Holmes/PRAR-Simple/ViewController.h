//
//  ViewController.h
//  PRAR-Simple
//
//  Created by Geoffroy Lesage on 3/27/14.
//  Copyright (c) 2014 Promet Solutions Inc,. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRARManager.h"

@interface ViewController : UIViewController <PRARManagerDelegate>
{
    IBOutlet UIView *loadingV;
    double myLat;
    double myLng;
}

@end
