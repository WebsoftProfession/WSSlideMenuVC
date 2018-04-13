//
//  ListVC.m
//  wsSlideMenu
//
//  Created by WebsoftProfession on 6/26/17.
//  Copyright © 2017 WebsoftProfession. All rights reserved.
//

#import "ListVC.h"
#import "WSMenuViewController.h"

@interface ListVC ()

@end

@implementation ListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuButton];
    // Do any additional setup after loading the view.
//    self.wsSlideMenu.isPanMode = false;
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    double fontSize = (lblText.frame.size.width*6.5)/72;
    NSString *style = [NSString stringWithFormat:@"<meta charset=\"UTF-8\"><style> body { font-family: 'HelveticaNeue';font-size: %.0fpx;}</style>",fontSize];
//    @"<meta charset=\"UTF-8\"><style> body { font-family: 'HelveticaNeue';font-size: 3.4vw; height:100%;}</style>"
//    [NSString stringWithFormat:@"<meta charset=\"UTF-8\"><style> body { font-family: 'HelveticaNeue';font-size: %.0fpx;}</style>",fontSize]
    style = [NSString stringWithFormat:@"%@%@", style, @"<div><p style=\"\">Real-time deal updates,<br/>Digital authorization,<br/>Anytime, Anywhere</p></div>"];
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType };
    lblText.attributedText = [[NSAttributedString alloc] initWithData:[style dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:NULL error:NULL];
}

-(void)setupMenuButton{
    //set slide menu button to navigation bar
    UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0, 20, 20)];
    [menuButton setExclusiveTouch:YES];
    [menuButton setContentMode:UIViewContentModeScaleToFill];
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    UIBarButtonItem *backMenuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = backMenuBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuAction:(id)sender {
    [self.wsSlideMenu toggleDSMenuViewController:self.wsSlideMenu withMode:LeftMode];
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
