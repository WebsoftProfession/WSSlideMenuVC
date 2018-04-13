//
//  LeftVC.h
//  wsSlideMenu
//
//  Created by WebsoftProfession on 6/26/17.
//  Copyright © 2017 WebsoftProfession. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSMenuViewController.h"

@interface LeftVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UIButton *btnImage;
}
@end
