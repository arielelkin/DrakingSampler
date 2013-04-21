//
//  ViewController.m
//  DrakingSampler
//
//  Created by Ariel Elkin on 21/04/2013.
//  Copyright (c) 2013 ariel. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "mo_audio.h"
#import "UIImage+animatedGIF.h"

#define SRATE 44100
#define FRAMESIZE 128
#define NUMCHANNELS 2

Float32 mySample[1000000] = {0};
bool sessionRec = false;
int mySessionCounter = 0;
int loopSize = 0;

void audioCallback( Float32 * buffer, UInt32 framesize, void* userData)
{
    AudioData * data = (AudioData*) userData;
    
    for(int i=0; i<framesize; i++)
    {
        
        SAMPLE out = buffer[2*i];
        
        
//        out = data->reverb->tick(out);
//
//        out = out + data->mySynth->tick();
        
        
        if(sessionRec){
            mySample[mySessionCounter] = out;
            mySessionCounter++;
        }
        
        else if (mySample[234] > 0) {
            
            
            out = data->reverb->tick( mySample[mySessionCounter] ) * data->sine->tick();

            
            mySessionCounter++;
        }
        
        
        if(mySessionCounter > 0 && loopSize > 0) mySessionCounter = mySessionCounter%loopSize;
        
        
        buffer[2*i] = buffer[2*i+1] = out;
    }
}

@interface ViewController ()

@property CMMotionManager *motionManager;

@end

@implementation ViewController

- (IBAction)buttonDown{
    
    sessionRec = true;
    loopSize = 0;
    mySessionCounter = 0;
}
- (IBAction)buttonUp{
    
    sessionRec = false;
    loopSize = mySessionCounter;
    
    static int currentImage;
    currentImage = (currentImage + 1)%3;
    
    NSString *imageName = [NSString stringWithFormat:@"%d", currentImage];
    NSLog(@"imagename: %@", imageName);
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:@"gif"];
    
    self.visual.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    
    
}

- (IBAction)buttonErase{
    
    for (int i = 0; i < loopSize; i++)
    {
        mySample [i] = 0;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupAudio];
    [self setupAccel];
    [self setupVisuals];
}

-(void)setupVisuals{
    
}

-(void)setupAudio{
    // init audio
    NSLog(@"Initializing Audio");
    
    // init the MoAudio layer
    bool result = MoAudio::init(SRATE, FRAMESIZE, NUMCHANNELS);
    
    if (!result) {
        NSLog(@"cannot initialize real-time audio!");
        return;
    }
    
    // start the audio layer, registering a callback method
    result = MoAudio::start( audioCallback, &audioData);
    
    if (!result) {
        NSLog(@"cannot start real-time audio!");
        return;
    }
    
    audioData.sine = new SineWave();
    audioData.sine->setFrequency(10);
    
    audioData.reverb = new PRCRev();
    audioData.reverb->setT60(0.8);

}

-(void)setupAccel{
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.01; // 100Hz
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 if(!error){
                                                     
//                                                     NSLog(@"x: %.1f || y: %.1f || z: %.1f", accelerometerData.acceleration.x , accelerometerData.acceleration.y, accelerometerData.acceleration.z);
                                                     
                                                     audioData.sine->setFrequency(fabs(accelerometerData.acceleration.x) * 30);
                                                     
                                                     audioData.reverb->setT60(fabs(accelerometerData.acceleration.y));
                                                     
                                                 }
                                                 else {
                                                     NSLog(@"accelerometer error!");
                                                 }
                                             }
     ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RecordPlayButton:(id)sender {
}
@end
