//
//  HomeVC.m
//  wsSlideMenu
//
//  Created by WebsoftProfession on 6/26/17.
//  Copyright © 2017 WebsoftProfession. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuAction:(id)sender {
    NSLog(@"%@",self.wsSlideMenu);
    [self.wsSlideMenu toggleDSMenuViewController:self.wsSlideMenu withMode:LeftMode];
}

- (IBAction)menuActionCall:(id)sender {
    [self.wsSlideMenu toggleDSMenuViewController:self.wsSlideMenu withMode:RightMode];
}

- (IBAction)categoryAction:(id)sender {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ListVC"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)useAction:(id)sender {
}

- (IBAction)faqAction:(id)sender {
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
