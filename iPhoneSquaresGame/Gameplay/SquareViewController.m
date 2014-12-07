#define kStateRunning 1
#define kStateGameDone 2

#define kGetSquareVelocity -5
#define kGetSquareVelocity2 6

#define kAvoidSquareVelocity 8
#define kAvoidSquareVelocity2 -6

#define kNumHighscores 5

#import "SquareViewController.h"
#import "HighscoreViewController.h"
#import "sqlite3.h"

@implementation SquareViewController

@synthesize gameState;

@synthesize getSquareVelocity;
@synthesize getSquareVelocity2;
@synthesize getSquareVelocity3;
@synthesize getSquareVelocity4;

@synthesize avoidSquareVelocity;
@synthesize avoidSquareVelocity2;
@synthesize avoidSquareVelocity3;
@synthesize avoidSquareVelocity4;

@synthesize getSquareArray;
@synthesize getVelocityArray;
@synthesize avoidSquareArray;
@synthesize avoidVelocityArray;

@synthesize highscoreField;

@synthesize menuButton;
@synthesize highscoresButton;

sqlite3 *db; //DATABASE OBJECT
bool start; //wait until user is ready

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Game parameters 
    gameState = kStateRunning;
    
    getSquareVelocity = CGPointMake(kGetSquareVelocity, 0);
    getSquareVelocity2 = CGPointMake(kGetSquareVelocity2, 0);
    getSquareVelocity3 = CGPointMake(kGetSquareVelocity, 0);
    getSquareVelocity4 = CGPointMake(kGetSquareVelocity2, 0);
    
    getSquareArray = [[NSMutableArray alloc] initWithObjects:getSquare, getSquare2, getSquare3, getSquare4, nil]; 
    getVelocityArray = [[NSMutableArray alloc] initWithObjects:[NSValue valueWithCGPoint:getSquareVelocity], 
                                                               [NSValue valueWithCGPoint:getSquareVelocity2],
                                                               [NSValue valueWithCGPoint:getSquareVelocity3],
                                                               [NSValue valueWithCGPoint:getSquareVelocity4], nil];
    
    avoidSquareVelocity = CGPointMake(kAvoidSquareVelocity, 0);
    avoidSquareVelocity2 = CGPointMake(kAvoidSquareVelocity2, 0);
    avoidSquareVelocity3 = CGPointMake(kAvoidSquareVelocity, 0);
    avoidSquareVelocity4 = CGPointMake(kAvoidSquareVelocity2, 0);
    
    avoidSquareArray = [[NSMutableArray alloc] initWithObjects:avoidSquare, avoidSquare2, avoidSquare3, avoidSquare4, nil];
    avoidVelocityArray = [[NSMutableArray alloc] initWithObjects:[NSValue valueWithCGPoint:avoidSquareVelocity],
                                                                 [NSValue valueWithCGPoint:avoidSquareVelocity2],
                                                                 [NSValue valueWithCGPoint:avoidSquareVelocity3], 
                                                                 [NSValue valueWithCGPoint:avoidSquareVelocity4], nil];
    
    start = true;
    gotSquare = NO;
    scoreLabelText.text = @"Score:";
    scoreLabelInt.text = @"0";
    gameNotifier.text = @"Tap To Begin!";
    menuButton.hidden = YES;
    highscoresButton.hidden = YES;
}

- (void)animateGame
{
    if (gameState == kStateRunning)
    {
        [self gameRunning];
    }
    else if (gameState == kStateGameDone)
    {
        for (UIView *view in [self.view subviews])
        {
            if (view != background && view != gameNotifier && view != menuButton && view != highscoresButton)
            {
                [view removeFromSuperview];
            }
        }
        [self userHitRedSquare:nil];
    }
}

- (void)gameRunning
{
    //--------Operations Loop for getSquares--------//
    for (int i=0; i < [getSquareArray count]; i++) 
    {
        UIImageView *tempSquare = [getSquareArray objectAtIndex:i]; //Make a temporary square to hold the index from getSquareArray
        NSValue *tempVal = [getVelocityArray objectAtIndex:i]; //Store the value then convert to CGPoint
        CGPoint tempPoint = [tempVal CGPointValue];
        
        tempSquare.center = CGPointMake(tempSquare.center.x + tempPoint.x, tempSquare.center.y); //Move squares
        
        //Check for wall collisions of getSquare
        if (CGRectIntersectsRect(tempSquare.frame, CGRectMake(-30, -30, 1, 380))) { //Intersects Left Side
            [self squareContactsWall:tempSquare withDirection:0]; 
        }
        else if (CGRectIntersectsRect(tempSquare.frame, CGRectMake(520, -30, 1, 380))) { //Intersects Right Side
            [self squareContactsWall:tempSquare withDirection:0]; 
        }   
        //Check userSquare for collision with Blue squares
        if (CGRectIntersectsRect(userSquare.frame, tempSquare.frame)) {
            if (gotSquare == NO) {
                userScore += (50 + (1 + arc4random() % 25)); //Generate points to be added
                scoreLabelInt.text = [NSString stringWithFormat:@"%ld", (long)userScore]; //Add score
                gotSquare = YES;
                
                [self userGotBlueSquare:tempSquare];
            }
        }
    }
    
    //--------Operations Loop for avoidSquares--------//
    for (int j=0; j < [avoidSquareArray count]; j++) {
        UIImageView *tempSquare = [avoidSquareArray objectAtIndex:j]; //Make a temporary square to hold the index from avoidSquareArray
        NSValue *tempVal = [avoidVelocityArray objectAtIndex:j]; //Store the value then convert to CGPoint
        CGPoint tempPoint = [tempVal CGPointValue];
        
        tempSquare.center = CGPointMake(tempSquare.center.x + tempPoint.x, tempSquare.center.y);
        
        //Check for wall collisions of avoidSquare
        if (CGRectIntersectsRect(tempSquare.frame, CGRectMake(-30, -30, 1, 380))) {
            [self squareContactsWall:tempSquare withDirection:0];
        }
        else if (CGRectIntersectsRect(tempSquare.frame, CGRectMake(520, -30, 1, 380))) {
            [self squareContactsWall:tempSquare withDirection:0];
        }
        
        //Check for collision with Red squares 
        if (CGRectIntersectsRect(userSquare.frame, tempSquare.frame)) {
            gameState = kStateGameDone;
        }
        if (CGRectIntersectsRect(userSquare.frame, tempSquare.frame)) {
            gameState = kStateGameDone;
        }
    }
}


//Method for when Squares contact walls 
- (void)squareContactsWall:(UIImageView *)square withDirection:(BOOL)squareDirection 
{
    //---Operations Loop For getSquares---//
    for (int i=0; i < [getSquareArray count]; i++) 
    {
        velocityDeterm = arc4random() % 2; //Generate new direction of square
        if (square == [getSquareArray objectAtIndex:i]) 
        {
            if (!velocityDeterm)  // if(equal to zero) || to the right
            {                 
                square.frame = CGRectMake(-25, (arc4random() % 320), 25, 25); //square regeneration
                //Reverse direction of velocity
                NSValue *tempVal = [getVelocityArray objectAtIndex:i];
                CGPoint tempPoint = [tempVal CGPointValue];
                tempPoint.x = -kGetSquareVelocity;
                
            }
            else // if(!equal to zero) || to the left
            {
                square.frame = CGRectMake(500, (arc4random() % 320), 25, 25); //square regeneration
                //Reverse direction of velocity
                NSValue *tempVal = [getVelocityArray objectAtIndex:i];
                CGPoint tempPoint = [tempVal CGPointValue];
                tempPoint.x = -kGetSquareVelocity;
                
            }
        }
    }
    
    //---Operations Loop For avoidSquares---//
    for (int j=0; j < [avoidSquareArray count]; j++)
    {
        velocityDeterm = arc4random() % 2; //Generate new direction of square
        if (square == [avoidSquareArray objectAtIndex:j])
        {
            if (!velocityDeterm) // if(equal to zero) || to the right
            {
                square.frame = CGRectMake(-25, (arc4random() % 320), 25, 25); //square regeneration
                //Reverse direction of velocity
                NSValue *tempVal = [getVelocityArray objectAtIndex:j];
                CGPoint tempPoint = [tempVal CGPointValue];
                tempPoint.x = -kAvoidSquareVelocity;
            }
            else // if(!equal to zero) || to the left 
            {
                square.frame = CGRectMake(500, (arc4random() % 320), 25, 25); //square regeneration
                //Reverse direction of velocity
                NSValue *tempVal = [getVelocityArray objectAtIndex:j];
                CGPoint tempPoint = [tempVal CGPointValue];
                tempPoint.x = -kAvoidSquareVelocity;
            }
        }
    }
}

//User square contacts other squares
- (void)userGotBlueSquare:(UIImageView *)blueSquare
{
    //Remove blue square that was contacted
    [blueSquare removeFromSuperview];
    blueSquare.frame = CGRectMake(-30, 1 + arc4random() % 320, blueSquare.frame.size.width, blueSquare.frame.size.height);
    
    //Increase size of userSquare
    userSquare.frame = CGRectMake(userSquare.frame.origin.x, userSquare.frame.origin.y, userSquare.frame.size.width + 1, userSquare.frame.size.height + 1); 
    
    gotSquare = NO;
    [self.view addSubview:blueSquare];
}

- (void)userHitRedSquare:(UIImageView *)redSquare
{
    [gameTimer invalidate];
    gameTimer = nil;
    start = true;
    
    NSString *endGameText = @"Game Over!";
    endGameText = [endGameText stringByAppendingString:@"\n"];
    endGameText = [endGameText stringByAppendingString:@"Score: "];
    endGameText = [endGameText stringByAppendingFormat:@"%@", [scoreLabelInt text]];
    
    gameNotifier.hidden = false;
    gameNotifier.numberOfLines = 0;
    gameNotifier.text = endGameText;
    
    menuButton.hidden = NO;
    highscoresButton.hidden = NO;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    highscorePath = [documentsDirectory stringByAppendingPathComponent:@"highscores"];
    highscorePath = [highscorePath stringByAppendingString:@".db"];

    [self useDatabase];
}

//--------Database Interaction-----------//
- (void)useDatabase
{
    NSString *score;
    
    //READ IN 5TH OR LAST HIGHSCORE
    int count = 0;
    if (sqlite3_open([highscorePath UTF8String], &db) == SQLITE_OK) //OPEN THE DATABASE
    {
        const char *sqlQuery = "SELECT score FROM highscores ORDER BY score DESC";
        sqlite3_stmt *compQuery;
        if (sqlite3_prepare_v2(db, sqlQuery, -1, &compQuery, NULL) == SQLITE_OK) //QUERY DATABASE
        {
            while (sqlite3_step(compQuery) == SQLITE_ROW) 
            {
                if (count < kNumHighscores) { //kNumHighscores is 5
                    score = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compQuery, 0)];
                    count++;
                }
            }

            if (count < kNumHighscores) { //5
                score = [NSString stringWithUTF8String:"0"];
            }
            if (userScore > [score intValue])
            {
                alert = [[UIAlertView alloc] initWithTitle:@"New Highscore!" 
                                                   message:@"Enter Your Name" 
                                                  delegate:self 
                                         cancelButtonTitle:@"Cancel" 
                                         otherButtonTitles:@"Save", nil];
                
                UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(12, 30, 260, 25)];
                [nameField setBackgroundColor:[UIColor whiteColor]];
                [nameField setBorderStyle:UITextBorderStyleRoundedRect];
                [nameField setPlaceholder:@"Name"];
                [nameField becomeFirstResponder];
                [alert addSubview:nameField];
                
                highscoreField = nameField;
                
                [alert show]; //SHOWS ALERT AND BUTTONS
            }
        }
    }
}

//-----AlertView Actions-----//
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{   
    if (buttonIndex == 1) //Save Button
    {
        NSString *name = highscoreField.text; //NAME OF PLAYER
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO highscores (uname, score) VALUES (\'%@\', %ld)", name, (long)userScore];
        const char *sqlQuery = [sql UTF8String];
        sqlite3_stmt *compQuery;
        
        if (sqlite3_prepare_v2(db, sqlQuery, -1, &compQuery, NULL) == SQLITE_OK) //PREPARE STATEMENT
        {
            if (sqlite3_step(compQuery) == SQLITE_DONE)  //QUERY DATABASE
                NSLog(@"YES!");
        }
        sqlite3_close(db);
        
        HighscoreViewController *hvController = [[HighscoreViewController alloc] initWithNibName:@"HighscoreViewController"
                                                                                          bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:hvController animated:YES];
        
        hvController = nil;
        [hvController release];
    }
    [highscoreField release];
}

//---End of game button events---//
-(IBAction)endButtonPressed:(UIButton *)sender
{
    if (sender == menuButton)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (sender == highscoresButton)
    {
        HighscoreViewController *hvController = [[HighscoreViewController alloc] initWithNibName:@"HighscoreViewController"
                                                                                          bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:hvController animated:YES];
    }
}

//-----Memory------//
- (void)viewDidUnload
{
    userSquare = nil;
    getSquare = nil;
    getSquare2 = nil;
    getSquare3 = nil;
    getSquare4 = nil;
    avoidSquare = nil;
    avoidSquare2 = nil;
    avoidSquare3 = nil;
    avoidSquare4 = nil;
    menuButton = nil;
    highscoresButton = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [userSquare release];
    [getSquare release];
    [getSquare2 release];
    [getSquare3 release];
    [getSquare4 release];
    [getSquareArray release];
    [getVelocityArray release];
    [avoidSquare release];
    [avoidSquare2 release];
    [avoidSquare3 release];
    [avoidSquare4 release];
    [avoidSquareArray release];
    [avoidVelocityArray release];
    [menuButton release];
    [highscoresButton release];
    [alert release];
    [super dealloc];
}

//-----Touch Events----//
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location = CGPointMake(location.x, (location.y - 40));
    
    if (CGRectContainsPoint(userSquare.frame, location))
    {
        userSquare.center = location;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (start) {
        gameNotifier.text = @"";
        gameNotifier.hidden = true;
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30 
                                                     target:self 
                                                   selector:@selector(animateGame) 
                                                   userInfo:nil 
                                                    repeats:YES];
    }
    start = false;
}

//---Set Rotation to Landscape---//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}
    
@end
