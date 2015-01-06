//
//  ViewController.h
//  TestProgramiOS
//
//  Created by biz4sol-mac-1 on 29/09/14.
//  Copyright (c) 2014 Biz4Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

- (IBAction)start:(id)sender;

- (IBAction)stop:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *sersorIdTExtfield;

@property (nonatomic, strong)NSMutableArray* groupButtons;
@property(nonatomic,strong)NSString *commandMode;

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet UIView *outerView;

@end

