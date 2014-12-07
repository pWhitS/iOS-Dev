
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface SetPasswordViewController : UIViewController <UIActionSheetDelegate>{

}

@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextField *rePasswordField;
@property (nonatomic, retain) IBOutlet UILabel *warningLabel;

- (IBAction)buttonPressed: (id)sender;
- (IBAction)quitKeyboard: (id)sender;
- (IBAction)tappedBackground: (id)sender;
- (IBAction)resetButton;

@end
