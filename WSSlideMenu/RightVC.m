//
//  RightVC.m
//  wsSlideMenu
//
//  Created by WebsoftProfession on 7/6/17.
//  Copyright © 2017 WebsoftProfession. All rights reserved.
//

#import "RightVC.h"

@interface RightVC ()
{
     NSMutableArray *dataArray;
}
@end

@implementation RightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] initWithObjects:@"Contact Us",@"About Us",@"Share", nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *img = [cell viewWithTag:100];
    UILabel *lblTitle = [cell viewWithTag:101];
    
    lblTitle.text = [dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UINavigationController *navController = (UINavigationController *)self.wsSlideMenu.homeViewController;
    if (indexPath.row==0) {
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        [navController setViewControllers:@[controller]];
    }
    else{
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ListVC"];
        [navController setViewControllers:@[controller]];
    }
    [self.wsSlideMenu toggleDSMenuViewController:self.wsSlideMenu withMode:RightMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
