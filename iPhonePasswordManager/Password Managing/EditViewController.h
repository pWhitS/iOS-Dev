
#import <UIKit/UIKit.h>


@interface EditViewController : UIViewController {

}

@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextField *answerField;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSString *selectedType;

- (IBAction)buttonPressed: (id)sender;
- (IBAction)quitKeyboard: (id)sender;
- (IBAction)tappedBackground: (id)sender;

@end
