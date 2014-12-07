
#import "StartWinViewController.h"
#import "PasswordCheckViewController.h"
#import "RootViewController.h"
#import "AboutViewController.h"
#import "ContactDevsViewController.h"
#import "SetPasswordViewController.h"

@implementation StartWinViewController

@synthesize keychain;
@synthesize aboutApp;
@synthesize contactDevs;
@synthesize setPassword;

- (void)viewDidLoad
{
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *accountsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Accounts"];
    BOOL isDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:accountsDirectory isDirectory:&isDir])
    {
        [fileManager createDirectoryAtPath:accountsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (IBAction)buttonPressed: (id)sender 
{
    if (sender == keychain)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *passwordPath = [documentsDirectory stringByAppendingPathComponent:@"password"];
        passwordPath = [passwordPath stringByAppendingString:@".txt"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:passwordPath] == YES) //check if file exists
        {
            PasswordCheckViewController *pcvController = [[PasswordCheckViewController alloc] initWithNibName:@"PasswordCheckViewController" bundle:[NSBundle mainBundle]];
            
            [self.navigationController pushViewController:pcvController animated:YES];
            [pcvController release];
        }
        else
        {
            RootViewController *rvController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:[NSBundle mainBundle]];
            
            [self.navigationController pushViewController:rvController animated:YES];
            [rvController release];
        }
        
        //Back Button for next views Title Bar
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Main" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        [backButton release];
    }
    else if (sender == aboutApp)
    {
        AboutViewController *avController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
        
        [self.navigationController pushViewController:avController animated:YES];
        [avController release];
    }
    else if (sender == contactDevs)
    {
        ContactDevsViewController *cdvController = [[ContactDevsViewController alloc] initWithNibName:@"ContactDevsViewController" bundle:[NSBundle mainBundle]];
        
        [self.navigationController pushViewController:cdvController animated:YES];
        [cdvController release];
    }
    else if (sender == setPassword)
    {
        SetPasswordViewController *spvController = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:[NSBundle mainBundle]];
        
        [self.navigationController presentModalViewController:spvController animated:YES];
        [spvController release];
    }
}

//------Memory------//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    self.keychain = nil;
    self.aboutApp = nil;
    self.contactDevs = nil;
    self.setPassword = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [keychain release];
    [aboutApp release];
    [contactDevs release];
    [setPassword release];
    [super dealloc];
}

@end
