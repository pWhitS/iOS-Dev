
#import "ContactDevsViewController.h"


@implementation ContactDevsViewController

@synthesize twitterButton, facebookButton, emailButton;

- (void)viewDidLoad
{
    self.navigationItem.title = @"Contact Us";
}

//----Button Events-----//
- (IBAction)buttonPressed: (id)sender
{
    if (sender == twitterButton)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/#!/PsychoactiveDev"]];
    }
    else if (sender == facebookButton)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/pages/Psychoactive-Developments/183931031663509"]];
    }
    else if (sender == emailButton)
    {
        [self sendTo:@"psychodevelopments@gmail.com"];
    }
}

- (void)sendTo: (NSString *)to {
	NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@",
							[to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

//------Memory-----//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    self.twitterButton = nil;
    self.facebookButton = nil;
    self.emailButton = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [twitterButton release];
    [facebookButton release];
    [emailButton release];
    [super dealloc];
}

@end
