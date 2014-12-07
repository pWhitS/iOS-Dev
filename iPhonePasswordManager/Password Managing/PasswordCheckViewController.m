
#import "PasswordCheckViewController.h"
#import "RootViewController.h"

@implementation PasswordCheckViewController

@synthesize warningLabel, passwordLabel, changeLabel;
@synthesize passwordField;
@synthesize unlockButton;

@synthesize warningLabel2;
@synthesize reNewPasswordField, reNewPasswordLabel;
@synthesize changeButton;
@synthesize oldPasswordField, oldPasswordLabel;


- (void)viewDidLoad
{
    self.navigationItem.title = @"Enter Password";
    warningLabel.text = @"";
    warningLabel2.text = @"";
    
    //---Hide change password labels---//
    reNewPasswordLabel.hidden = YES;
    reNewPasswordField.hidden = YES;
    reNewPasswordField.hidden = YES;
    changeButton.hidden = YES;
    oldPasswordField.hidden = YES;
    oldPasswordLabel.hidden = YES;
}

//-----Button and Segmented Control Events-----//
- (IBAction)segmentedControl: (id)sender
{
    if ([sender selectedSegmentIndex] == 0) //Unlock keychain
    {
        passwordLabel.text = @"Password:";
        passwordField.placeholder = @"enter your password";
        changeLabel.text = @"Change Your Password?";
        
        warningLabel.hidden = NO;
        unlockButton.hidden = NO;
        reNewPasswordLabel.hidden = YES;
        reNewPasswordField.hidden = YES;
        changeButton.hidden = YES;
        oldPasswordField.hidden = YES;
        oldPasswordLabel.hidden = YES;
    } 
    else //Change password
    {
        passwordLabel.text = @"New Password:";
        passwordField.placeholder = @"type new password";
        changeLabel.text = @"Unlock Keychain?";
        
        warningLabel.hidden = YES;
        unlockButton.hidden = YES;
        reNewPasswordLabel.hidden = NO;
        reNewPasswordField.hidden = NO;
        changeButton.hidden = NO;
        oldPasswordField.hidden = NO;
        oldPasswordLabel.hidden = NO;
    }
}

- (IBAction)buttonPressed: (id)sender 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *passwordPath = [documentsDirectory stringByAppendingPathComponent:@"password"];
    passwordPath = [passwordPath stringByAppendingString:@".txt"];
    
    NSString *enteredPassword = [passwordField text];
    NSString *realPassword = [NSString stringWithContentsOfFile:passwordPath encoding:NSASCIIStringEncoding error:nil];
    
    warningLabel.textColor = [UIColor redColor];
    warningLabel.shadowColor = [UIColor whiteColor];
    warningLabel2.textColor = [UIColor redColor];
    warningLabel2.shadowColor = [UIColor whiteColor];
    if (sender == unlockButton)
    {
        if ([enteredPassword isEqualToString:realPassword]) //unlock successfull
        {
            RootViewController *rvController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:[NSBundle mainBundle]];
            
            [self.navigationController pushViewController:rvController animated:YES];
            [rvController release];
        }
        else
        {
            warningLabel.text = @"Incorrect Password!";
        }
    }
    else if (sender == changeButton)
    {
        NSString *oldPassword = [oldPasswordField text];
        if ([oldPassword isEqualToString:realPassword]) //check if old password is password on file
        {
            NSString *reTypedPassword = [reNewPasswordField text];
            if ([enteredPassword isEqualToString:reTypedPassword]) //check if both entered passwords are the same
            {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtPath:passwordPath error:nil]; //delete password file
                
                //write new password file with new password
                [enteredPassword writeToFile:passwordPath atomically:YES encoding:NSASCIIStringEncoding error:nil];
                
                //Rewrite Keychain File----//
                NSString *accountsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Accounts"];
                NSString *newDirectoryPath = [accountsDirectory stringByAppendingPathComponent:@"myKeychain"];
                [[NSFileManager defaultManager] createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
                NSString *newFilePath = [newDirectoryPath stringByAppendingPathComponent:@"myKeychain"];
                newFilePath = [newFilePath stringByAppendingString:@".txt"];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:newFilePath] == YES)
                {
                    [fileManager removeItemAtPath:newFilePath error:nil]; //Delete old myKeychain file
                    
                    //Write New File
                    NSString *accountInformation = @"myKeychain"; 
                    accountInformation = [accountInformation stringByAppendingString:@"\n"];
                    accountInformation = [accountInformation stringByAppendingString:[passwordField text]];
                    accountInformation = [accountInformation stringByAppendingString:@"\n"];
                    accountInformation = [accountInformation stringByAppendingString:@"\n"];
                    
                    [accountInformation writeToFile:newFilePath atomically:YES encoding:NSASCIIStringEncoding error:nil]; 
                }
                
                //Push to RootViewController
                RootViewController *rvController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:[NSBundle mainBundle]]; //push to root view
                [self.navigationController pushViewController:rvController animated:YES];
                [rvController release];
            }
            else //New passwords do not match
            {
                warningLabel2.text = @"Passwords Do Not Match!";
            }
        }
        else //Old password is not correct
        {
            warningLabel2.text = @"Old Password is Incorrect";
        }
    }
}


//-----Memory----//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    self.warningLabel = nil;
    self.warningLabel2 = nil;
    self.passwordLabel = nil;
    self.changeLabel = nil;
    self.passwordField = nil;
    self.unlockButton = nil;
    self.reNewPasswordLabel = nil;
    self.reNewPasswordField = nil;
    self.changeButton = nil;
    self.oldPasswordLabel = nil;
    self.oldPasswordField = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [warningLabel release];
    [warningLabel2 release];
    [passwordLabel release];
    [changeLabel release];
    [passwordField release];
    [unlockButton release];
    [reNewPasswordLabel release];
    [reNewPasswordField release];
    [changeButton release];
    [oldPasswordLabel release];
    [oldPasswordField release];
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
    [reNewPasswordField resignFirstResponder];
    [oldPasswordField resignFirstResponder];
}

@end
