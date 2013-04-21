//
//  ViewController.m
//  DrakingSampler
//
//  Created by Ariel Elkin on 21/04/2013.
//  Copyright (c) 2013 ariel. All rights reserved.
//

#import "ViewController.h"
#import "mo_audio.h"


#define SRATE 44100
#define FRAMESIZE 128
#define NUMCHANNELS 2

Float32 mySample[1000000] = {0};
bool sessionRec;
int mySessionCounter = 0;
int loopSize;

void audioCallback( Float32 * buffer, UInt32 framesize, void* userData)
{
//    AudioData * data = (AudioData*) userData;
    
    for(int i=0; i<framesize; i++)
    {
        SAMPLE in = buffer[2*i];
        
        
//        in = data->reverb->tick(in);
//
//        in = in + data->mySynth->tick();
        
        
        if(sessionRec){
            mySample[mySessionCounter] = in;
            mySessionCounter++;
        }
        else if(mySample[0]) {
            in = mySample[mySessionCounter];
            mySessionCounter++;
        }
        
        if(mySessionCounter > 0 && loopSize > 0) mySessionCounter = mySessionCounter%loopSize;
        
        
        SAMPLE out = in;
        

        
        buffer[2*i] = buffer[2*i+1] = out;
    }
}

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)buttonDown{
    
    sessionRec = true;
    
}
- (IBAction)buttonUp{
    
    sessionRec = false;
    loopSize = mySessionCounter;
    
}

- (IBAction)buttonErase:(id)sender {
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RecordPlayButton:(id)sender {
}
@end
