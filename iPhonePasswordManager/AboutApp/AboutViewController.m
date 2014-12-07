
#import "AboutViewController.h"


@implementation AboutViewController

@synthesize descriptionLabel;

- (void)viewDidLoad
{
    self.navigationItem.title = @"About This App";
    
    NSString *aboutFilePath = [[NSBundle mainBundle] pathForResource:@"About" ofType:@"txt"];
    NSString *aboutText = [NSString stringWithContentsOfFile:aboutFilePath encoding:NSASCIIStringEncoding error:nil];
    
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.text = aboutText;
    
    [super viewDidLoad];
}

//------Memory-----//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    self.descriptionLabel = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [descriptionLabel release];
    [super dealloc];
}

@end
