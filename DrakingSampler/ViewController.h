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
#include "PRCRev.h"
#include "SineWave.h"

using namespace stk;
struct AudioData{
    PRCRev *reverb;
    SineWave *sine;
};



@interface ViewController : UIViewController{
    struct AudioData audioData;
}
- (IBAction)buttonDown;
- (IBAction)buttonUp;
- (IBAction)buttonErase;

@end
