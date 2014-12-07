
#import "HighscoreViewController.h"
#import "sqlite3.h"

@implementation HighscoreViewController

@synthesize highscoresView;

sqlite3 *db; //DATABASE OBJECT

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    highscorePath = [documentsDirectory stringByAppendingPathComponent:@"highscores"];
    highscorePath = [highscorePath stringByAppendingString:@".db"];
    
    //READ IN HIGHSCORES AND OUTPUT TO SCREEN
    [self readHighscoresFromDatabase];
}

//----------Database-------------//
-(void)readHighscoresFromDatabase
{
    NSString *outputString = [[NSString alloc] init];
    NSString *name;
    NSString *score;
    NSString *countStr;
    int count = 0;
    outputString = [outputString stringByAppendingString:@"Displaying Top 5 \n\n"];
    
    if (sqlite3_open([highscorePath UTF8String], &db) == SQLITE_OK) //OPEN THE DATABASE
    {
        const char *sqlQuery = "SELECT * FROM highscores ORDER BY score DESC";
        sqlite3_stmt *compQuery;
        if (sqlite3_prepare_v2(db, sqlQuery, -1, &compQuery, NULL) == SQLITE_OK) //PREPARES QUERY
        {
            while (sqlite3_step(compQuery) == SQLITE_ROW) //QUERY DATABASE
            {
                if (count < 5) {
                    //READ DATA FROM RESULTS
                    name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compQuery, 0)];
                    score = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compQuery, 1)];
                    count++;
                    countStr = [NSString stringWithFormat:@"%d", count];
                    countStr = [countStr stringByAppendingString:@")"];
                
                    outputString = [outputString stringByAppendingString:countStr];
                    outputString = [outputString stringByAppendingString:@" "];
                    outputString = [outputString stringByAppendingString:name];
                    outputString = [outputString stringByAppendingString:@": "];
                    outputString = [outputString stringByAppendingString:score];
                    outputString = [outputString stringByAppendingString:@"\n"];
                }
            }
            
            //Delete extra highscores
            if (count > 3)
            {
                NSString *sql = [NSString stringWithFormat:@"DELETE FROM highscores WHERE score < %d", [score intValue]];
                const char *delQuery = [sql UTF8String];
                sqlite3_stmt *finalQuery;
                if (sqlite3_prepare_v2(db, delQuery, -1, &finalQuery, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(finalQuery) == SQLITE_DONE) //DELETE from database
                        NSLog(@"test");
                }

            }
        }
    }
    sqlite3_close(db);
    //OUTPUT RESULTS TO SCREEN
    highscoresView.text = outputString;
    [highscoresView setFont:[UIFont fontWithName:@"Verdana" size:18]];
    [highscoresView setTextColor:[UIColor blueColor]];
}

//--------Button Events--------//
-(IBAction)buttonPressed:(UIButton *)sender 
{
    if (sender == menuButton)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (sender == resetButton)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Reset All Highscores?"
                                                                 delegate:self 
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Reset" 
                                                        otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
}

//----ActionSheet Button Events-----//
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
        const char *sqlQuery = "DELETE FROM highscores";
        sqlite3_stmt *compQuery;
        if (sqlite3_prepare_v2(db, sqlQuery, -1, &compQuery, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(compQuery) == SQLITE_DONE)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Highscores Reset"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"Okay"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//-----Memory-----//
-(void)viewDidUnload 
{
    highscoresView = nil;
    [super viewDidUnload];
}

-(void)dealloc
{
    [highscoresView release];
    [super dealloc];
}

//---Set Rotation to Landscaper
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

@end
