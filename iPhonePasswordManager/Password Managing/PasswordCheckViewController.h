
#import <UIKit/UIKit.h>

@interface PasswordCheckViewController : UIViewController {
   
}

@property (nonatomic, retain) IBOutlet UILabel *warningLabel;
@property (nonatomic, retain) IBOutlet UILabel *passwordLabel;
@property (nonatomic, retain) IBOutlet UILabel *changeLabel;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UIButton *unlockButton;

@property (nonatomic, retain) IBOutlet UILabel *warningLabel2;
@property (nonatomic, retain) IBOutlet UILabel *reNewPasswordLabel;
@property (nonatomic, retain) IBOutlet UITextField *reNewPasswordField;
@property (nonatomic, retain) IBOutlet UIButton *changeButton;
@property (nonatomic, retain) IBOutlet UILabel *oldPasswordLabel;
@property (nonatomic, retain) IBOutlet UITextField *oldPasswordField;

- (IBAction)buttonPressed: (id)sender;
- (IBAction)segmentedControl: (id)sender;
- (IBAction)quitKeyboard: (id)sender;
- (IBAction)tappedBackground: (id)sender;

@end
