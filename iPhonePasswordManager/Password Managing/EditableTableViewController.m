
#import "EditableTableViewController.h"
#import "EditViewController.h"
#import "RootViewController.h"

@implementation EditableTableViewController

@synthesize selectedType;
@synthesize dateLabel;
@synthesize editableTableView;

- (void)viewDidLoad
{
    self.navigationItem.title = selectedType;
    editableTableView.backgroundColor = [UIColor clearColor]; //set clear so background image will show
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
    
    [super viewDidLoad];
}

- (void)edit: (id)sender;
{
    EditViewController *evController = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:[NSBundle mainBundle]];
    
    [self presentModalViewController:evController animated:YES];
    evController.selectedType = selectedType;
    [evController release];
}

//----UITableViewController-----//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    
    static NSString *SectionsIdentifier = @"SectionIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionsIdentifier] autorelease];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *accountsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Accounts"];
    NSString *accountTextPath = [accountsDirectory stringByAppendingPathComponent:selectedType];
    accountTextPath = [accountTextPath stringByAppendingPathComponent:selectedType];
    accountTextPath = [accountTextPath stringByAppendingString:@".txt"];
    
    NSString *fileContents;
    NSArray *fileLines;
    if (accountTextPath)
    {
        fileContents = [NSString  stringWithContentsOfFile:accountTextPath encoding:NSASCIIStringEncoding error:nil];
        fileLines = [fileContents componentsSeparatedByString:@"\n"];
    }
    
    switch (section)
    {
        case 0:
            cell.textLabel.text = [fileLines objectAtIndex:0];
            break;
        case 1:
            cell.textLabel.text = [fileLines objectAtIndex:1];
            break;
        case 2:
            cell.textLabel.text = [fileLines objectAtIndex:2];
            break;
        case 3:
            cell.textLabel.text = [fileLines objectAtIndex:3];
            break;
        default:
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Username:";
            break;
        case 1:
            return @"Password:";
            break;
        case 2:
            return @"Security Answer:";
            break;
        case 3:
            return @"Account Email:";
            break;
        default:
            break;
    }
    return nil;
}

//----Memory-------//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    self.dateLabel = nil;
    self.editableTableView = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [dateLabel release];
    [selectedType release];
    [editableTableView release];
    [super dealloc];
}

@end
