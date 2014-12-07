
#import <UIKit/UIKit.h>

@interface HowToViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UIButton *menuButton;
@property (nonatomic, retain) IBOutlet UIButton *contactButton;

- (IBAction)buttonPressed:(UIButton *)sender;
- (void)sendEmail: (NSString *)sendTo;

@end
