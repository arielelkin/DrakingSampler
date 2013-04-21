//
//  ViewController.h
//  DrakingSampler
//
//  Created by Ariel Elkin on 21/04/2013.
//  Copyright (c) 2013 ariel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AudioToolbox/AudioToolbox.h>

#include "Stk.h"
#include "Mandolin.h"

using namespace stk;
struct AudioData{
	Mandolin *myMandolin;
};

@interface ViewController : UIViewController{
    struct AudioData audioData;
}

@end