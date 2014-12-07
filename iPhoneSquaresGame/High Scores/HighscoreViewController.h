
#import <UIKit/UIKit.h>


@interface HighscoreViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate> {
    IBOutlet UIButton *menuButton;
    IBOutlet UIButton *resetButton;
    
    NSString *highscorePath;
}

@property (nonatomic, retain) IBOutlet UITextView *highscoresView;

-(IBAction)buttonPressed:(UIButton *)sender;
-(void)readHighscoresFromDatabase;

@end
