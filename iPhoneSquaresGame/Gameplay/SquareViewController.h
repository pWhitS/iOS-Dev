
#import <UIKit/UIKit.h>

@interface SquareViewController : UIViewController <UIAlertViewDelegate> {
    IBOutlet UIImageView *userSquare;
    
    IBOutlet UIImageView *avoidSquare;
    IBOutlet UIImageView *avoidSquare2;
    IBOutlet UIImageView *avoidSquare3;
    IBOutlet UIImageView *avoidSquare4;
    
    IBOutlet UIImageView *getSquare;
    IBOutlet UIImageView *getSquare2;
    IBOutlet UIImageView *getSquare3;
    IBOutlet UIImageView *getSquare4;
    
    NSMutableArray *getSquareArray;
    NSMutableArray *getVelocityArray;    
    
    NSMutableArray *avoidSquareArray;
    NSMutableArray *avoidVelocityArray;
    
    IBOutlet UIImageView *background;
    
    IBOutlet UILabel *gameNotifier;
    IBOutlet UILabel *scoreLabelText;
    IBOutlet UILabel *scoreLabelInt;
    
    NSString *highscorePath;
    NSInteger userScore;
    NSTimer *gameTimer;
    UIAlertView *alert;
    
    BOOL velocityDeterm;
    BOOL gotSquare;
}

@property (nonatomic) NSInteger gameState;

@property (nonatomic) CGPoint getSquareVelocity;
@property (nonatomic) CGPoint getSquareVelocity2;
@property (nonatomic) CGPoint getSquareVelocity3;
@property (nonatomic) CGPoint getSquareVelocity4;

@property (nonatomic) CGPoint avoidSquareVelocity;
@property (nonatomic) CGPoint avoidSquareVelocity2;
@property (nonatomic) CGPoint avoidSquareVelocity3;
@property (nonatomic) CGPoint avoidSquareVelocity4;

@property (nonatomic, retain) NSMutableArray *getSquareArray;
@property (nonatomic, retain) NSMutableArray *getVelocityArray;
@property (nonatomic, retain) NSMutableArray *avoidSquareArray;
@property (nonatomic, retain) NSMutableArray *avoidVelocityArray;

@property (nonatomic, retain) UITextField *highscoreField;

@property (nonatomic, retain) IBOutlet UIButton *menuButton;
@property (nonatomic, retain) IBOutlet UIButton *highscoresButton;
-(IBAction)endButtonPressed:(UIButton *)sender;

- (void)animateGame;
- (void)gameRunning;

- (void)userGotBlueSquare:(UIImageView *)blueSquare;
- (void)userHitRedSquare:(UIImageView *)redSquare;
- (void)squareContactsWall:(UIImageView *)square withDirection:(BOOL)squareDirection;
- (void)useDatabase;

@end
