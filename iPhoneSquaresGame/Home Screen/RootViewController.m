
#import "RootViewController.h"
#import "SquareViewController.h"
#import "HighscoreViewController.h"
#import "HowToViewController.h"
#import "sqlite3.h"

@implementation RootViewController

@synthesize playButton, instructionsButton, highscoresButton;
@synthesize pauseButton;

bool isPlaying = true;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create the highscores Database
    sqlite3 *db;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *highscorePath = [documentsDirectory stringByAppendingPathComponent:@"highscores"];
    highscorePath = [highscorePath stringByAppendingString:@".db"];
    
    if (sqlite3_open([highscorePath UTF8String], &db) == SQLITE_OK) 
    {
        const char *sqlQuery = "CREATE TABLE highscores (uname text, score int)";
        sqlite3_stmt *compQuery;
        if (sqlite3_prepare_v2(db, sqlQuery, -1, &compQuery, NULL) == SQLITE_OK) //CREATE the database
        {
            sqlite3_step(compQuery);
        }
    }
    sqlite3_close(db);
    
    //--INITIALIZE MUSIC--//
    NSURL *audioURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/electronic.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    audioPlayer.numberOfLoops = -1;
    if (audioPlayer == nil) {
        NSLog(@"ERROR, not sure");
    }
    else {
        [audioPlayer play];
    }
}

//----Button Events-----//
-(IBAction)buttonPressed:(UIButton *)sender
{
    if (sender == playButton)
    {
        SquareViewController *svController = [[SquareViewController alloc] initWithNibName:@"SquareViewController"
                                                                                    bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:svController animated:YES];
        
        svController = nil;
        [svController release];
    }
    else if (sender == instructionsButton)
    {
        HowToViewController *htvController = [[HowToViewController alloc] initWithNibName:@"HowToViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:htvController animated:YES];
        
        htvController = nil;
        [htvController release];
    }
    else if (sender == highscoresButton)
    {
        HighscoreViewController *hvController = [[HighscoreViewController alloc] initWithNibName:@"HighscoreViewController"
                                                                                          bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:hvController animated:YES];
        
        hvController = nil;
        [hvController release];
    }
    else if (sender == pauseButton)
    {
        UIImage *img; //For changing the buttons image
        
        if (isPlaying) {
            [audioPlayer pause];
            isPlaying = false;
            
            img = [UIImage imageNamed:@"muteOn.png"];
            [pauseButton setImage:img forState:UIControlStateNormal];
            [img release];
        }
        else {
            [audioPlayer play];
            isPlaying = true;
            
            img = [UIImage imageNamed:@"muteOff.png"];
            [pauseButton setImage:img forState:UIControlStateNormal];
            [img release];
        }
    }
}

//------Memory-------//
- (void)viewDidUnload
{
    playButton = nil;
    instructionsButton = nil;
    highscoresButton = nil;
    pauseButton = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [playButton release];
    [instructionsButton release];
    [highscoresButton release];
    [pauseButton release];
    [super dealloc];
}


//------Orientation-------//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

@end
