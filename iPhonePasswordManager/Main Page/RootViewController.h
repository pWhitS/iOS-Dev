
#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <UIAlertViewDelegate> {

}

@property (nonatomic, retain) UITextField *newItemField;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) NSMutableArray *infoArray;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;

- (IBAction)addItem: (id)sender;
- (void)createAccountsArray;

@end
