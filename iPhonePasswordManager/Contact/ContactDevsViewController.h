
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ContactDevsViewController : UIViewController {

}

@property (nonatomic, retain) IBOutlet UIButton *twitterButton;
@property (nonatomic, retain) IBOutlet UIButton *facebookButton;
@property (nonatomic, retain) IBOutlet UIButton *emailButton;

- (IBAction)buttonPressed: (id)sender;
-(void) sendTo:(NSString *)to;

@end
