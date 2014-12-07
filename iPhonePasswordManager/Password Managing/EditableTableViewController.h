
#import <Foundation/Foundation.h>

@interface EditableTableViewController : UITableViewController {

}

@property (nonatomic, retain) NSString *selectedType;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UITableView *editableTableView;

- (void)edit: (id)sender;

@end
