
#import "RootViewController.h"
#import "EditableTableViewController.h"
#import "EditViewController.h"

@implementation RootViewController

@synthesize infoArray;
@synthesize alert;
@synthesize newItemField;
@synthesize theTableView;

//-----LifeCycle------
- (void)viewDidLoad
{
    self.navigationItem.title = @"Keychain";
    
    //Reload infoArray
    [self createAccountsArray];
    
    //Add Buttons to Navigation Bar and Toolbar  
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    //Back Button 
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Main" style:UIBarButtonItemStylePlain target:self action:@selector(toRootView)];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
    
    [super viewDidLoad];
}

- (void)toRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//----Add Item To TableView----//
- (IBAction)addItem: (id)sender 
{
    alert = [[UIAlertView alloc] initWithTitle:@"Add Item Title" message:@"overwrite" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    
    newItemField = [[UITextField alloc] initWithFrame:CGRectMake(16, 48, 252, 25)];
    newItemField.borderStyle = UITextBorderStyleRoundedRect;
    newItemField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [newItemField becomeFirstResponder];
    
    [alert addSubview:newItemField];
    [alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{   
    if (buttonIndex == 1)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *accountsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Accounts"];
        NSString *newDirectoryPath = [accountsDirectory stringByAppendingPathComponent:[newItemField text]];

        [fileManager createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        [infoArray release];
        [self createAccountsArray];
        [self.tableView reloadData];
        
        //Present EditViewController
        EditViewController *evController = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController presentModalViewController:evController animated:YES];
        
        evController.selectedType = [newItemField text];
        [evController release];
        [newItemField release];
    }
    
    [alert release];
}

// Customize the number of sections in the table view.-------//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [infoArray count];
}

// Customize the appearance of table view cells.----------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    // Configure the cell.
    NSUInteger row = [indexPath row];
    NSString *rowString = [infoArray objectAtIndex:row];
    cell.textLabel.text = rowString;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
//-----------------------------------------------------------//

//----Deleting rows----//
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{  
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *accountsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Accounts"];
        NSString *newDirectoryPath = [accountsDirectory stringByAppendingPathComponent:[infoArray objectAtIndex:row]];
        
        [fileManager removeItemAtPath:newDirectoryPath error:nil];
        [infoArray removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }
    
}

//-----Push view Controller-------//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedType = [infoArray objectAtIndex:indexPath.row];
    EditableTableViewController *etvController = [[EditableTableViewController alloc] initWithNibName:@"EditableTableViewController" bundle:[NSBundle mainBundle]];
    etvController.selectedType = selectedType;
    
    [self.navigationController pushViewController:etvController animated:YES];
    [etvController release];
}


//Method for gathering an array of Accounts Directories------//
- (void)createAccountsArray 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *accountsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Accounts"];
    infoArray = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *fileArray = [[fileManager contentsOfDirectoryAtPath:accountsDirectory error:nil] retain];
	for (NSString *file in fileArray) 
    {
		NSString *path = [accountsDirectory stringByAppendingPathComponent:file];
		BOOL isDir = NO;
		[fileManager fileExistsAtPath:path isDirectory:(&isDir)];
		if (isDir) 
			[infoArray addObject:file]; 
	}
	[fileArray release];
}

//---Memory---//
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    self.theTableView = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [theTableView release];
    [infoArray release];
    [super dealloc];
}

@end
