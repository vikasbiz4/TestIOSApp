//
//  DemoViewController.h
//  TestProgramiOS
//
//  Created by biz4sol-mac-1 on 21/10/14.
//  Copyright (c) 2014 Biz4Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *outerView;

- (IBAction)startButton:(id)sender;

@property (nonatomic, strong)NSMutableArray* groupButtons;
@property(nonatomic,strong)NSString *commandMode;

@end
