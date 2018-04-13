//
//  WSMenuViewController.m
//  wsSlideMenu
//
//  Created by WebsoftProfession on 6/26/17.
//  Copyright © 2017 WebsoftProfession. All rights reserved.
//

#import "WSMenuViewController.h"

@interface WSMenuViewController ()
{
    float drawerSize;
    CGPoint touchStartPoint;
    CGPoint touchEndPoint;
    CGPoint touchHoldPoint;
    BOOL isClosing;
    int currentMode;
    CGFloat viewStartDragPoint;
    int currentDragState;
}
@end

@implementation WSMenuViewController

+(instancetype)sharedInstance{
    static WSMenuViewController *sharedClient =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[WSMenuViewController alloc] init];
    });
    return sharedClient;
}

-(id)initWithLeftViewController:(UIViewController *)left home:(UIViewController *)homeVC right:(UIViewController *)rightVC{
    self = [super init];
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupInitialMenuSetup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [WSMenuViewController sharedInstance].isPanMode = YES;
    if (self.rightViewController && !self.isRightView) {
        self.isRightView = YES;
    }
}

-(void)setupInitialMenuSetup{
    
    self.homeViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.homeViewController.view.layer.shadowOpacity = 0.5;
    self.homeViewController.view.layer.shadowOffset = CGSizeZero;
    self.homeViewController.view.layer.shadowRadius = 10;
    
    if (self.leftViewController) {
        [self addChildViewController:self.leftViewController];
        [self.leftViewController.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.view addSubview:self.leftViewController.view];
        [self.leftViewController didMoveToParentViewController:self];
    }
    
    if (self.rightViewController) {
        [self addChildViewController:self.rightViewController];
        [self.rightViewController.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.view addSubview:self.rightViewController.view];
        [self.rightViewController didMoveToParentViewController:self];
    }
    
    [self addChildViewController:self.homeViewController];
    [self.homeViewController.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.homeViewController.view];
    [self.homeViewController didMoveToParentViewController:self];
    
    [WSMenuViewController sharedInstance].leftViewController = self.leftViewController;
    [WSMenuViewController sharedInstance].homeViewController = self.homeViewController;
    [WSMenuViewController sharedInstance].rightViewController = self.rightViewController;
    if (self.drawerWidth==0) {
        [WSMenuViewController sharedInstance].drawerWidth = [self getDrawerWidth];
    }
    else{
        [WSMenuViewController sharedInstance].drawerWidth = self.drawerWidth;
    }
    
    UIPanGestureRecognizer *panG= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [[WSMenuViewController sharedInstance].homeViewController.view addGestureRecognizer:panG];
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [[WSMenuViewController sharedInstance].homeViewController.view addGestureRecognizer:tapG];
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)pan{
    CGPoint touchPoint = [pan locationInView:pan.view];
    CGPoint vel = [pan velocityInView:pan.view];
    NSLog(@"Velocity : %@",NSStringFromCGPoint(vel));
    if (![WSMenuViewController sharedInstance].isPanMode) {
        return;
    }
    if (pan.state == UIGestureRecognizerStateBegan) {
        touchStartPoint = touchPoint;
        touchHoldPoint = touchPoint;
        viewStartDragPoint = pan.view.frame.origin.x;
    }
    else if(pan.state == UIGestureRecognizerStateChanged){
        touchEndPoint = touchPoint;
        float dX = touchEndPoint.x-touchStartPoint.x;
        float dY = touchEndPoint.y-touchStartPoint.y;
        if (dX>0 && viewStartDragPoint==0 && self.homeViewController.view.frame.origin.x>=0) {
            NSLog(@"Left Open Drag Mode");
            [WSMenuViewController sharedInstance].rightViewController.view.hidden = YES;
            currentDragState = LeftDragOpenState;
        }
        else if(dX<0 && viewStartDragPoint==0 && self.homeViewController.view.frame.origin.x<=0){
            NSLog(@"Right Open Drag Mode");
            [WSMenuViewController sharedInstance].rightViewController.view.hidden = NO;
            currentDragState = RightDragOpenState;
        }
        else if (dX<0 && viewStartDragPoint==self.drawerWidth){
            NSLog(@"Left Close Drag Mode");
            currentDragState = LeftDragCloseState;
            [WSMenuViewController sharedInstance].rightViewController.view.hidden = YES;
        }
        else if (dX>0 && viewStartDragPoint== -self.drawerWidth){
            NSLog(@"Right Close Drag Mode");
            currentDragState = RightDragCloseState;
            [WSMenuViewController sharedInstance].rightViewController.view.hidden = NO;
        }
        //        else if (dX<0 && viewStartDragPoint==(-self.drawerWidth)){
        //            currentDragState = RightDragCloseState;
        //        }
        [self dragMenuWithVelocity:CGPointMake(dX, dY) andTouchPoint:touchEndPoint];
    }
    else{
        
        if (currentDragState==LeftDragOpenState || currentDragState==LeftDragCloseState) {
            if (vel.x>350 && viewStartDragPoint>0) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([WSMenuViewController sharedInstance].drawerWidth, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                } completion:^(BOOL finished) {
                    for (UIView *view in [WSMenuViewController sharedInstance].homeViewController.view.subviews) {
                        view.userInteractionEnabled = false;
                    }
                }];
            }
            else if (vel.x<-350){
                [UIView animateWithDuration:0.2 animations:^{
                    [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                } completion:^(BOOL finished) {
                    for (UIView *view in [WSMenuViewController sharedInstance].homeViewController.view.subviews) {
                        view.userInteractionEnabled = true;
                    }
                }];
            }
            else{
                [self runDragAnimation];
            }
        }
        else{
            if (self.isRightView) {
                if (vel.x<-350) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake(-[WSMenuViewController sharedInstance].drawerWidth, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                    } completion:^(BOOL finished) {
                        for (UIView *view in [WSMenuViewController sharedInstance].homeViewController.view.subviews) {
                            view.userInteractionEnabled = false;
                        }
                    }];
                }
                else if (vel.x>350){
                    [UIView animateWithDuration:0.2 animations:^{
                        [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                    } completion:^(BOOL finished) {
                        for (UIView *view in [WSMenuViewController sharedInstance].homeViewController.view.subviews) {
                            view.userInteractionEnabled = true;
                        }
                    }];
                }
                else{
                    [self runDragAnimation];
                }
            }
        }
    }
}

-(void)handleTapGesture:(UITapGestureRecognizer *)tap{
    isClosing = true;
    [self runDragAnimation];
}

-(void)toggleDSMenuViewController:(WSMenuViewController *)controller withMode:(DSMenuMode)mode{
    CGFloat drawerRatio=0;
    BOOL touchEnable;
    if (mode==LeftMode && self.leftViewController) {
        if ([self.wsSlideMenu.leftViewController respondsToSelector:@selector(viewWillAppear:)]) {
            [self.wsSlideMenu.leftViewController viewWillAppear:true];
        }
        if (controller.homeViewController.view.frame.origin.x==0) {
            [WSMenuViewController sharedInstance].rightViewController.view.hidden = YES;
            drawerRatio = self.drawerWidth;
            touchEnable = false;
            currentDragState = LeftDragCloseState;
        }
        else{
            drawerRatio = 0;
            touchEnable = true;
        }
    }
    else{
        if (self.rightViewController) {
            if ([self.wsSlideMenu.rightViewController respondsToSelector:@selector(viewWillAppear:)]) {
                [self.wsSlideMenu.rightViewController viewWillAppear:true];
            }
            if (controller.homeViewController.view.frame.origin.x==0) {
                [WSMenuViewController sharedInstance].rightViewController.view.hidden = NO;
                drawerRatio = (-1)*self.drawerWidth;
                touchEnable = false;
                currentDragState = RightDragCloseState;
            }
            else{
                drawerRatio = 0;
                touchEnable = true;
            }
        }
        else{
            touchEnable = true;
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        controller.homeViewController.view.frame = CGRectMake(drawerRatio, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        for (UIView *view in [WSMenuViewController sharedInstance].homeViewController.view.subviews) {
            view.userInteractionEnabled = touchEnable;
        }
    }];
}


-(CGFloat)getDrawerWidth{
    
    if (self.homeViewController.view.frame.size.width<self.homeViewController.view.frame.size.height) {
        self.drawerWidth = self.homeViewController.view.frame.size.width/2+50;
    }
    else{
        self.drawerWidth = self.homeViewController.view.frame.size.height/2+50;
    }
    return self.drawerWidth;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        
    }
    
    if (size.width<size.height) {
        drawerSize = size.width/2+50;
    }
    else{
        drawerSize = size.height/2+50;
    }
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
    }];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [[touches allObjects] lastObject];
//    CGPoint touchPoint = [touch locationInView:self.view];
//    NSLog(@"%@",NSStringFromCGPoint(touchPoint));
//    touchStartPoint = touchPoint;
//    touchHoldPoint = touchPoint;
//}
//
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [[touches allObjects] lastObject];
//    CGPoint touchPoint = [touch locationInView:self.view];
//    touchEndPoint = touchPoint;
//    [self dragMenuWithStartPoint:touchStartPoint endPoint:touchEndPoint];
//}
//
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [[touches allObjects] lastObject];
//    CGPoint touchPoint = [touch locationInView:self.view];
//    if (touchHoldPoint.x==touchPoint.x) {
//        isClosing= true;
//    }
//    [self runDragAnimation];
//}



-(void)dragMenuWithVelocity:(CGPoint)velocity andTouchPoint:(CGPoint)touchPoint{
    
    if (currentDragState==LeftDragOpenState || currentDragState==LeftDragCloseState) {
        if (velocity.x>0) {
            isClosing = false;
            [WSMenuViewController sharedInstance].rightViewController.view.hidden = YES;
        }
        else{
            isClosing = true;;
        }
        
        if (velocity.x>0 && ([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+velocity.x)<=[WSMenuViewController sharedInstance].drawerWidth) {
            
            [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+velocity.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
        else{
            if (([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+velocity.x)>0 && ([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+velocity.x)<=[WSMenuViewController sharedInstance].drawerWidth) {
                [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+velocity.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            }
        }
    }
    else{
        if (self.isRightView) {
            if (velocity.x>0) {
                isClosing = true;
            }
            else{
                isClosing = false;;
                [WSMenuViewController sharedInstance].rightViewController.view.hidden = NO;
            }
            if (velocity.x<0 && ([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+velocity.x)>= (-[WSMenuViewController sharedInstance].drawerWidth)) {
                
                [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+velocity.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            }
            else{
                if (([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+velocity.x)<0 && ([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+velocity.x)>=(-[WSMenuViewController sharedInstance].drawerWidth)) {
                    [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+velocity.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                }
            }
        }
    }
}
-(void)dragMenuWithStartPoint:(CGPoint)sp endPoint:(CGPoint)ep{
    
    CGFloat diffRatio = ep.x-sp.x;
    if (diffRatio>0) {
        isClosing = false;
    }
    else{
        isClosing = true;;
    }
    touchStartPoint = touchEndPoint;
    if (diffRatio>0 && ([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+diffRatio)<=[WSMenuViewController sharedInstance].drawerWidth) {
        
        [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+diffRatio, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    else{
        if (([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+diffRatio)>0 && ([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+diffRatio)<=[WSMenuViewController sharedInstance].drawerWidth) {
            [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x+diffRatio, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
    }
}

-(void)runDragAnimation{
    
    if (currentDragState==LeftDragOpenState || currentDragState==LeftDragCloseState) {
        if ([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x>[WSMenuViewController sharedInstance].drawerWidth/4) {
            if (!isClosing) {
                [UIView animateWithDuration:0.2 animations:^{
                    [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([WSMenuViewController sharedInstance].drawerWidth, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                } completion:^(BOOL finished) {
                    for (UIView *view in [WSMenuViewController sharedInstance].homeViewController.view.subviews) {
                        view.userInteractionEnabled = false;
                    }
                }];
            }
            else{
                [UIView animateWithDuration:0.2 animations:^{
                    [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                } completion:^(BOOL finished) {
                    for (UIView *view in [WSMenuViewController sharedInstance].homeViewController.view.subviews) {
                        view.userInteractionEnabled = true;
                    }
                }];
            }
        }
        else{
            
            [UIView animateWithDuration:0.2 animations:^{
                [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            } completion:^(BOOL finished) {
                for (UIView *view in [WSMenuViewController sharedInstance].homeViewController.view.subviews) {
                    view.userInteractionEnabled = true;
                }
            }];
        }
    }
    else{
        
        if ([WSMenuViewController sharedInstance].homeViewController.view.frame.origin.x<(-[WSMenuViewController sharedInstance].drawerWidth/4)) {
            if (!isClosing) {
                [UIView animateWithDuration:0.2 animations:^{
                    [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake((-[WSMenuViewController sharedInstance].drawerWidth), [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                } completion:^(BOOL finished) {
                    for (UIView *view in [WSMenuViewController sharedInstance].homeViewController.view.subviews) {
                        view.userInteractionEnabled = false;
                    }
                }];
            }
            else{
                [UIView animateWithDuration:0.2 animations:^{
                    [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                } completion:^(BOOL finished) {
                    for (UIView *view in [WSMenuViewController sharedInstance].homeViewController.view.subviews) {
                        view.userInteractionEnabled = true;
                    }
                }];
            }
        }
        else{
            
            [UIView animateWithDuration:0.2 animations:^{
                [WSMenuViewController sharedInstance].homeViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            } completion:^(BOOL finished) {
                for (UIView *view in [WSMenuViewController sharedInstance].homeViewController.view.subviews) {
                    view.userInteractionEnabled = true;
                }
            }];
        }
    }
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
