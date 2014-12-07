
#import "SetPasswordViewController.h"


@implementation SetPasswordViewController

@synthesize saveButton, cancelButton;
@synthesize passwordField, rePasswordField;
@synthesize warningLabel;


//-----Button Events------//
- (IBAction)buttonPressed: (id)sender
{
    if (sender == saveButton)
    {
        warningLabel.numberOfLines = 0; //change warning label attributes
        warningLabel.textColor = [UIColor redColor];
        warningLabel.shadowColor = [UIColor whiteColor];
        
        //Find Password file path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *passwordPath = [documentsDirectory stringByAppendingPathComponent:@"password"];
        passwordPath = [passwordPath stringByAppendingString:@".txt"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:passwordPath] == NO) //check if password file exists
        {
            NSString *password = [passwordField text];
            NSString *rePassword = [rePasswordField text];
            if ([rePassword isEqualToString:password])
            {
                [password writeToFile:passwordPath atomically:YES encoding:NSASCIIStringEncoding error:nil];
                [self dismissModalViewControllerAnimated:YES];
                
                //Create myKeychain Directory
                NSString *accountsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Accounts"];
                NSString *newDirectoryPath = [accountsDirectory stringByAppendingPathComponent:@"myKeychain"];
                [[NSFileManager defaultManager] createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
                
                //Create myKeychain File
                NSString *accountInformation = @"myKeychain";
                accountInformation = [accountInformation stringByAppendingString:@"\n"];
                accountInformation = [accountInformation stringByAppendingString:[passwordField text]];
                accountInformation = [accountInformation stringByAppendingString:@"\n"];
                accountInformation = [accountInformation stringByAppendingString:@"\n"];;
                
                //Write myKeychain file to Path
                NSString *newFilePath = [newDirectoryPath stringByAppendingPathComponent:@"myKeychain"];
                newFilePath = [newFilePath stringByAppendingString:@".txt"];
                [accountInformation writeToFile:newFilePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
            }
            else //Passwords are not equal
            {
                warningLabel.text = @"Passwords Did Not Match, Please Try Again";
            }
        }
        else //if password file already exists
        {
            warningLabel.text = @"Password already created... Go to keychain to change password.";
        }
    }
    else if (sender == cancelButton)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)resetButton
{
    //Find documents and password paths
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *passwordPath = [documentsDirectory stringByAppendingPathComponent:@"password"];
    passwordPath = [passwordPath stringByAppendingString:@".txt"];

    if ([[NSFileManager defaultManager] fileExistsAtPath:passwordPath] == YES) //check if file exists
    {
        //Create actionsheet
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"This will permanently delete your keychain password and accounts. Are you sure you want to continue?"                 
                                                                delegate:self 
                                                        cancelButtonTitle:@"Cancel" 
                                                   destructiveButtonTitle:@"Reset"
                                                        otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Password Set" 
                                                        message:nil
                                                       delegate:nil 
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

//----ActionSheet Button Events-----//
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) 
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //Find Documents Directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *accountsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Accounts"]; //Find accounts directory
        
        //Find Password file path
        NSString *passwordPath = [documentsDirectory stringByAppendingPathComponent:@"password"];
        passwordPath = [passwordPath stringByAppendingString:@".txt"];
        
        [fileManager removeItemAtPath:accountsDirectory error:nil];
        [fileManager removeItemAtPath:passwordPath error:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Reset" 
                                                        message:@"Keychain accounts removed" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Okay" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

//------Memory-----//
- (void)viewDidUnload
{
    self.passwordField = nil;
    self.rePasswordField = nil;
    self.saveButton = nil;
    self.cancelButton = nil;
    self.warningLabel = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [passwordField release];
    [rePasswordField release];
    [saveButton release];
    [cancelButton release];
    [warningLabel release];
    [super dealloc];
}

//----Keyboard Methods-----//
- (IBAction)quitKeyboard: (id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)tappedBackground: (id)sender
{
    [passwordField resignFirstResponder];
    [rePasswordField resignFirstResponder];
}

@end
