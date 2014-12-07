
#import <UIKit/UIKit.h>

@interface StartWinViewController : UIViewController {

}

@property (nonatomic, retain) IBOutlet UIButton *keychain;
@property (nonatomic, retain) IBOutlet UIButton *aboutApp;
@property (nonatomic, retain) IBOutlet UIButton *contactDevs;
@property (nonatomic, retain) IBOutlet UIButton *setPassword;

- (IBAction)buttonPressed: (id)sender;

@end
