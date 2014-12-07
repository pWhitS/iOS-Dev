#define scrollWidth 320
#define scrollHeight 550

#import "EditViewController.h"
#import "RootViewController.h"

@implementation EditViewController

@synthesize usernameField, passwordField, answerField, emailField;
@synthesize saveButton, cancelButton;
@synthesize selectedType;
@synthesize scrollView;

- (void)viewDidLoad
{   
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(scrollWidth, scrollHeight)];
    
    [super viewDidLoad];
}

- (IBAction)buttonPressed: (id)sender 
{
    if (sender == saveButton) //Create File In Accounts Directory With Account Information
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *accountsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Accounts"];
        NSString *newDirectoryPath = [accountsDirectory stringByAppendingPathComponent:selectedType];
        NSString *newFilePath = [newDirectoryPath stringByAppendingPathComponent:selectedType];
        newFilePath = [newFilePath stringByAppendingString:@".txt"];
        
        if (newFilePath) //Delete File at Path if file exists
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:newFilePath error:nil];
        }
        
        NSString *accountInformation = [usernameField text];
        accountInformation = [accountInformation stringByAppendingString:@"\n"];
        accountInformation = [accountInformation stringByAppendingString:[passwordField text]];
        accountInformation = [accountInformation stringByAppendingString:@"\n"];
        accountInformation = [accountInformation stringByAppendingString:[answerField text]];
        accountInformation = [accountInformation stringByAppendingString:@"\n"];
        accountInformation = [accountInformation stringByAppendingString:[emailField text]];
        
        [accountInformation writeToFile:newFilePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
    }
    
    //Return to EditableTableView
    [self dismissModalViewControllerAnimated:YES];
}

//-----Memory-----//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    self.usernameField = nil;
    self.passwordField = nil;
    self.answerField = nil;
    self.emailField = nil;
    self.saveButton = nil;
    self.cancelButton = nil;
    self.scrollView = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [usernameField release];
    [passwordField release];
    [answerField release];
    [emailField release];
    [saveButton release];
    [cancelButton release];
    [scrollView release];
    [super dealloc];
}

//-----Keyboard-------//
- (IBAction)quitKeyboard: (id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)tappedBackground: (id)sender
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [answerField resignFirstResponder];
    [emailField resignFirstResponder];
}

@end
