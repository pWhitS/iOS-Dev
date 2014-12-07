
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface RootViewController : UIViewController {
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *instructionsButton;
@property (nonatomic, retain) IBOutlet UIButton *highscoresButton;
@property (nonatomic, retain) IBOutlet UIButton *pauseButton;

-(IBAction)buttonPressed:(UIButton *)sender;

@end
