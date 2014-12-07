
#import "HowToViewController.h"

@implementation HowToViewController

@synthesize menuButton;
@synthesize contactButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(480, 445);
    self.view = scrollView;
}

- (IBAction)buttonPressed:(UIButton *)sender 
{
    if (sender == menuButton) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (sender == contactButton) {
        [self sendEmail:@"psychodevelopments@gmail.com"];
    }
}

- (void)sendEmail: (NSString *)sendTo {
    NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@",[sendTo stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}

- (void)dealloc
{
    [super dealloc];
    [scrollView release];
    [menuButton release];
    [contactButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    scrollView = nil;
    menuButton = nil;
    contactButton = nil;
}

@end
