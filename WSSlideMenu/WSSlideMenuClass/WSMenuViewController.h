//
//  WSMenuViewController.h
//  wsSlideMenu
//
//  Created by WebsoftProfession on 6/26/17.
//  Copyright © 2017 WebsoftProfession. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+WSMenuViewControllerExtend.h"

typedef enum{
    LeftMode=0,
    RightMode
}DSMenuMode;

typedef enum{
    LeftDragOpenState=0,
    LeftDragCloseState,
    RightDragOpenState,
    RightDragCloseState
}DSMenuDragState;

@interface WSMenuViewController : UIViewController
{
    __strong IBOutlet UIStoryboardSegue *leftVC;
    __strong IBOutlet UIStoryboardSegue *rightVC;
    __strong IBOutlet UIStoryboardSegue *homeVC;
}
+(instancetype)sharedInstance;
-(void)toggleDSMenuViewController:(WSMenuViewController *)controller withMode:(DSMenuMode)mode;
@property (nonatomic,strong) UIViewController *leftViewController;
@property (nonatomic,strong) UIViewController *homeViewController;
@property (nonatomic,strong) UIViewController *rightViewController;
@property (assign) CGFloat drawerWidth;
@property (nonatomic,assign) BOOL isPanMode;
@property (assign) BOOL isRightView;

@end
