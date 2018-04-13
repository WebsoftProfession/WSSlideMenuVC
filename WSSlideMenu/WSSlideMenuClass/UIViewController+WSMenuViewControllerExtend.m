//
//  UIViewController+DSMenuViewControllerExtend.m
//  wsSlideMenu
//
//  Created by WebsoftProfession on 6/26/17.
//  Copyright © 2017 WebsoftProfession. All rights reserved.
//

#import "UIViewController+WSMenuViewControllerExtend.h"
#import "WSMenuViewController.h"

@implementation UIViewController (DSMenuViewControllerExtend)
@dynamic wsSlideMenu;
- (WSMenuViewController *)wsSlideMenu {
    return [WSMenuViewController sharedInstance];
}

@end
