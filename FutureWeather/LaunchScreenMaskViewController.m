//
//  LaunchScreenMaskViewController.m
//  FutureWeather
//
//  Created by Prince on 6/2/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import "LaunchScreenMaskViewController.h"
#import "MainTabBarController.h"

@interface LaunchScreenMaskViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainAnimationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundAnimationImageView;

@end

@implementation LaunchScreenMaskViewController

@synthesize mainAnimationImageView, backgroundAnimationImageView;

MainTabBarController *mainView;

NSMutableArray *images;

- (void)viewDidLoad {
    [super viewDidLoad];
   // mainView = [[MainTabBarController alloc] init];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    UIStoryboard *storyboard = self.storyboard;
    mainView = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [self performSelector:@selector(gotToMainView) withObject:nil afterDelay:11.0];
}
-(void)viewWillAppear:(BOOL)animated{
    images = [[NSMutableArray alloc] init];
    for (int i=1; i<40; i++){
        NSString *imgName = [NSString stringWithFormat:@"frame-%i", i];
        UIImage *image = [UIImage imageNamed:imgName];
        [images addObject:image];
    }
    mainAnimationImageView.animationImages = images;
    backgroundAnimationImageView.animationImages = images;
    mainAnimationImageView.animationDuration = 2.25;
    mainAnimationImageView.animationRepeatCount = 0;
    backgroundAnimationImageView.animationDuration = 2.25;
    backgroundAnimationImageView.animationRepeatCount = 0;
    [backgroundAnimationImageView startAnimating];
    [mainAnimationImageView startAnimating];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotToMainView{
    [self presentViewController:mainView animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
