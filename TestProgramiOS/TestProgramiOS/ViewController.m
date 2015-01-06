//
//  ViewController.m
//  TestProgramiOS
//
//  Created by biz4sol-mac-1 on 29/09/14.
//  Copyright (c) 2014 Biz4Solutions. All rights reserved.
//

#import "ViewController.h"
#import "MyObject.h"
#import "DeviceDataReader.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize groupButtons,commandMode;
@synthesize sersorIdTExtfield;
@synthesize startButton,stopButton,outerView;

NSThread *myThread;
MyObject *myObject;
DeviceDataReader *deviceDataReader;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sersorIdTExtfield.delegate=self;
    [stopButton setEnabled:FALSE];
    
    
    
    
    int marginTop,marginLeft,width,containerViewWidth,scrollViewHeight,containerViewHeight;
    int commandLabelWidth,fontSize,radioButtonSize,commandLabelHeight;
    int checkboxSize,largeCommandLabelHeight,labelTopMargin,lowGhighGlabelHeight;
    if ([[UIDevice currentDevice]userInterfaceIdiom]) {
        marginTop=180;
        marginLeft=25;
        width=550;
        containerViewWidth=540;
        containerViewHeight=700;
        scrollViewHeight=700;
        commandLabelWidth=500;
        fontSize=26;
        radioButtonSize=35;
        commandLabelHeight=35;
        checkboxSize=28;
        largeCommandLabelHeight=35;
        labelTopMargin=10;
        lowGhighGlabelHeight=65;
    }else{
        marginTop=140;
        marginLeft=5;
        width=290;
        containerViewWidth=280;
        containerViewHeight=650;
        scrollViewHeight=300;
        commandLabelWidth=250;
         fontSize=16;
        radioButtonSize=25;
        commandLabelHeight=25;
        checkboxSize=18;
        largeCommandLabelHeight=45;
        labelTopMargin=0;
        lowGhighGlabelHeight=40;
    }
    
  

    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(marginLeft, marginTop, width, scrollViewHeight)];
//   scrollView.backgroundColor=[UIColor lightGrayColor];
    
    UIView *containerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, containerViewWidth, containerViewHeight)];
    scrollView.contentSize=CGSizeMake(containerView.frame.size.width, containerView.frame.size.height);
   
    [scrollView addSubview:containerView];
    [self.outerView addSubview:scrollView];
    
    
    UIButton *highLowGStreamOptionButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 8, radioButtonSize, radioButtonSize)];
    highLowGStreamOptionButton.tag=11;
    UILabel *selectOptionLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, 0, commandLabelWidth, lowGhighGlabelHeight )];
    selectOptionLabel.text=@"Set Low G(0x01) And High G(0x07) Streaming mode";
    selectOptionLabel.numberOfLines=2;
//    selectOptionLabel.backgroundColor=[UIColor yellowColor];
    selectOptionLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:highLowGStreamOptionButton];
    [containerView addSubview:selectOptionLabel];
    
    UIButton *setLowGStreamButton=[[UIButton alloc]initWithFrame:CGRectMake(25, selectOptionLabel.frame.origin.y+lowGhighGlabelHeight+8, checkboxSize, checkboxSize)];
    [setLowGStreamButton setBackgroundImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
    [setLowGStreamButton addTarget:self action:@selector(onCheckboxClick:) forControlEvents:UIControlEventTouchUpInside];
    setLowGStreamButton.tag=1;
    
    UILabel *setLowGStreamLabel=[[UILabel alloc]initWithFrame:CGRectMake(checkboxSize+35, selectOptionLabel.frame.origin.y+lowGhighGlabelHeight+5, commandLabelWidth, 25)];
    setLowGStreamLabel.text=@"Set Low G Stream mode(0x01)";
    setLowGStreamLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:setLowGStreamButton];
    [containerView addSubview:setLowGStreamLabel];
    
    UIButton *setHighGStreamButton=[[UIButton alloc]initWithFrame:CGRectMake(25, setLowGStreamLabel.frame.origin.y+commandLabelHeight+8, checkboxSize, checkboxSize)];
    [setHighGStreamButton setBackgroundImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
    [setHighGStreamButton addTarget:self action:@selector(onCheckboxClick:) forControlEvents:UIControlEventTouchUpInside];
    setHighGStreamButton.tag=2;
    UILabel *setHighGStreamLabel=[[UILabel alloc]initWithFrame:CGRectMake(checkboxSize+35, setLowGStreamLabel.frame.origin.y+commandLabelHeight+5, commandLabelWidth, 25)];
    setHighGStreamLabel.text=@"Set High G Stream mode(0x07)";
    setHighGStreamLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:setHighGStreamButton];
    [containerView addSubview:setHighGStreamLabel];
    
    UIButton *versionButton=[[UIButton alloc]initWithFrame:CGRectMake(10, setHighGStreamLabel.frame.origin.y+commandLabelHeight+5, radioButtonSize, radioButtonSize)];
    versionButton.tag=12;
    UILabel *versionLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, setHighGStreamLabel.frame.origin.y+commandLabelHeight+5, commandLabelWidth, commandLabelHeight)];
    versionLabel.text=@"Get Version(0x00)";
    versionLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:versionButton];
    [containerView addSubview:versionLabel];
    
    UIButton *getLowGStreamButton=[[UIButton alloc]initWithFrame:CGRectMake(10, versionLabel.frame.origin.y+commandLabelHeight+5, radioButtonSize, radioButtonSize)];
    getLowGStreamButton.tag=13;
    UILabel *getLowGStreamLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, versionLabel.frame.origin.y+commandLabelHeight+5, commandLabelWidth, commandLabelHeight)];
    getLowGStreamLabel.text=@"Get Low G Stream mode(0x02)";
    getLowGStreamLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:getLowGStreamButton];
    [containerView addSubview:getLowGStreamLabel];
    
    UIButton *setLowGStreamBegThresholdButton=[[UIButton alloc]initWithFrame:CGRectMake(10, getLowGStreamLabel.frame.origin.y+commandLabelHeight+10, radioButtonSize, radioButtonSize)];
    setLowGStreamBegThresholdButton.tag=14;
    UILabel *setLowGStreamBegThresholdLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, getLowGStreamLabel.frame.origin.y+commandLabelHeight+labelTopMargin, commandLabelWidth, largeCommandLabelHeight)];
    setLowGStreamBegThresholdLabel.text=@"Set Low G Stream Beg Threshold (0x03)";
    setLowGStreamBegThresholdLabel.numberOfLines=2;
    setLowGStreamBegThresholdLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:setLowGStreamBegThresholdButton];
    [containerView addSubview:setLowGStreamBegThresholdLabel];
    
    int y=setLowGStreamBegThresholdLabel.frame.origin.y+largeCommandLabelHeight;
    UIButton *getLowGStreamBegThresholdButton=[[UIButton alloc]initWithFrame:CGRectMake(10, y+10, radioButtonSize, radioButtonSize)];
    getLowGStreamBegThresholdButton.tag=15;
    UILabel *getLowGStreamBegThresholdLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, y+labelTopMargin, commandLabelWidth, largeCommandLabelHeight)];
    getLowGStreamBegThresholdLabel.text=@"Get Low G Stream Beg Threshold (0x04)";
    getLowGStreamBegThresholdLabel.numberOfLines=2;
    getLowGStreamBegThresholdLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:getLowGStreamBegThresholdButton];
    [containerView addSubview:getLowGStreamBegThresholdLabel];
    
    y=getLowGStreamBegThresholdLabel.frame.origin.y+largeCommandLabelHeight;
    UIButton *setLowGStreamEndThresholdButton=[[UIButton alloc]initWithFrame:CGRectMake(10, y+10, radioButtonSize, radioButtonSize)];
    setLowGStreamEndThresholdButton.tag=16;
    UILabel *setLowGStreamEndThresholdLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, y+labelTopMargin, commandLabelWidth, largeCommandLabelHeight)];
    setLowGStreamEndThresholdLabel.text=@"Set Low G Stream End Threshold (0x05)";
    setLowGStreamEndThresholdLabel.numberOfLines=2;
    setLowGStreamEndThresholdLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:setLowGStreamEndThresholdButton];
    [containerView addSubview:setLowGStreamEndThresholdLabel];
    
    y=setLowGStreamEndThresholdLabel.frame.origin.y+largeCommandLabelHeight;
    UIButton *getLowGStreamEndThresholdButton=[[UIButton alloc]initWithFrame:CGRectMake(10, y+10, radioButtonSize, radioButtonSize)];
    getLowGStreamEndThresholdButton.tag=17;
    UILabel *getLowGStreamEndThresholdLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, y+labelTopMargin, commandLabelWidth, largeCommandLabelHeight)];
    getLowGStreamEndThresholdLabel.text=@"Get Low G Stream End Threshold (0x06)";
    getLowGStreamEndThresholdLabel.numberOfLines=2;
    getLowGStreamEndThresholdLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:getLowGStreamEndThresholdButton];
    [containerView addSubview:getLowGStreamEndThresholdLabel];
    
    y=getLowGStreamEndThresholdLabel.frame.origin.y+largeCommandLabelHeight;
    UIButton *getHighGStreamButton=[[UIButton alloc]initWithFrame:CGRectMake(10, y+labelTopMargin, radioButtonSize, radioButtonSize)];
    getHighGStreamButton.tag=18;
    UILabel *getHighGStreamLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, y+labelTopMargin, commandLabelWidth, commandLabelHeight)];
    getHighGStreamLabel.text=@"Get High G Stream mode(0x08)";
    getHighGStreamLabel.numberOfLines=2;
    getHighGStreamLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:getHighGStreamButton];
    [containerView addSubview:getHighGStreamLabel];
    
    y=getHighGStreamLabel.frame.origin.y+commandLabelHeight;
    UIButton *setHighGStreamBegThresholdButton=[[UIButton alloc]initWithFrame:CGRectMake(10, y+10, radioButtonSize, radioButtonSize)];
    setHighGStreamBegThresholdButton.tag=19;
    UILabel *setHighGStreamBegThresholdLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, y+labelTopMargin, commandLabelWidth, largeCommandLabelHeight)];
    setHighGStreamBegThresholdLabel.text=@"Set High G Stream Beg Threshold (0x09)";
    setHighGStreamBegThresholdLabel.numberOfLines=2;
    setHighGStreamBegThresholdLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:setHighGStreamBegThresholdButton];
    [containerView addSubview:setHighGStreamBegThresholdLabel];
    
    y=setHighGStreamBegThresholdLabel.frame.origin.y+largeCommandLabelHeight;
    UIButton *getHighGStreamBegThresholdButton=[[UIButton alloc]initWithFrame:CGRectMake(10, y+10, radioButtonSize, radioButtonSize)];
    getHighGStreamBegThresholdButton.tag=20;
    UILabel *getHighGStreamBegThresholdLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, y+labelTopMargin, commandLabelWidth, largeCommandLabelHeight)];
    getHighGStreamBegThresholdLabel.text=@"Get High G Stream Beg Threshold (0x0A)";
    getHighGStreamBegThresholdLabel.numberOfLines=2;
    getHighGStreamBegThresholdLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:getHighGStreamBegThresholdButton];
    [containerView addSubview:getHighGStreamBegThresholdLabel];
    
    y=getHighGStreamBegThresholdLabel.frame.origin.y+largeCommandLabelHeight;
    UIButton *setHighGStreamEndThresholdButton=[[UIButton alloc]initWithFrame:CGRectMake(10, y+10, radioButtonSize, radioButtonSize)];
    setHighGStreamEndThresholdButton.tag=21;
    UILabel *setHighGStreamEndThresholdLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, y+labelTopMargin, commandLabelWidth, largeCommandLabelHeight)];
    setHighGStreamEndThresholdLabel.text=@"Set High G Stream End Threshold(0x0B)";
    setHighGStreamEndThresholdLabel.numberOfLines=2;
    setHighGStreamEndThresholdLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:setHighGStreamEndThresholdButton];
    [containerView addSubview:setHighGStreamEndThresholdLabel];
    
    y=setHighGStreamEndThresholdLabel.frame.origin.y+largeCommandLabelHeight;
    UIButton *getHighGStreamEndThresholdButton=[[UIButton alloc]initWithFrame:CGRectMake(10, y+10, radioButtonSize, radioButtonSize)];
    getHighGStreamEndThresholdButton.tag=22;
    UILabel *getHighGStreamEndThresholdLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, y+labelTopMargin, commandLabelWidth, largeCommandLabelHeight)];
    getHighGStreamEndThresholdLabel.text=@"Get High G Stream End Threshold(0x0C)";
    getHighGStreamEndThresholdLabel.numberOfLines=2;
    getHighGStreamEndThresholdLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:getHighGStreamEndThresholdButton];
    [containerView addSubview:getHighGStreamEndThresholdLabel];
    
    y=getHighGStreamEndThresholdLabel.frame.origin.y+largeCommandLabelHeight;
    UIButton *getTemperatureButton=[[UIButton alloc]initWithFrame:CGRectMake(10, y+labelTopMargin, radioButtonSize, radioButtonSize)];
    getTemperatureButton.tag=23;
    UILabel *getTemperatureLabel=[[UILabel alloc]initWithFrame:CGRectMake(radioButtonSize+15, y+labelTopMargin, commandLabelWidth, commandLabelHeight)];
    getTemperatureLabel.text=@"Get Temperature(0x0D)";
    getTemperatureLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    [containerView addSubview:getTemperatureButton];
    [containerView addSubview:getTemperatureLabel];

    
    
    
    groupButtons=[[NSMutableArray alloc]init];
    [groupButtons addObject:highLowGStreamOptionButton];
    [groupButtons addObject:versionButton];
    [groupButtons addObject:getLowGStreamButton];
    [groupButtons addObject:setLowGStreamBegThresholdButton];
    [groupButtons addObject:getLowGStreamBegThresholdButton];
    [groupButtons addObject:setLowGStreamEndThresholdButton];
    [groupButtons addObject:getLowGStreamEndThresholdButton];
    [groupButtons addObject:getHighGStreamButton];
    [groupButtons addObject:setHighGStreamBegThresholdButton];
    [groupButtons addObject:getHighGStreamBegThresholdButton];
    [groupButtons addObject:setHighGStreamEndThresholdButton];
    [groupButtons addObject:getHighGStreamEndThresholdButton];
    [groupButtons addObject:getTemperatureButton];
    
    for(int i=0;i<[self.groupButtons count];i++){
        [[self.groupButtons objectAtIndex:i] setBackgroundImage:[UIImage
                                                                 imageNamed:@"radio_uncheck.png"]
                                                       forState:UIControlStateNormal];
        [[self.groupButtons objectAtIndex:i] addTarget:self action:@selector(onRadioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    
    


}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)start:(id)sender {
    
     UIButton *button=(UIButton *)sender;
    UIButton *lowGButton=(UIButton *)[self.view viewWithTag:1];
    UIButton *highGButton=(UIButton *)[self.view viewWithTag:2];
    if ([button tag]==101) {
        
    
    if (commandMode) {
        
        deviceDataReader=[[DeviceDataReader alloc]initWithBoxerName:@"TestBoxer":commandMode];
        [deviceDataReader startThread];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Response" message:@"Date reading start from CSV file" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [button setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        button.tag=102;
        for(int i=0;i<[self.groupButtons count];i++){
            [[self.groupButtons objectAtIndex:i] setEnabled:FALSE];
        }
        [lowGButton setEnabled:FALSE];
        [highGButton setEnabled:FALSE];

    }else{
        UIButton *lowGHighGRadioButton=(UIButton *)[self.view viewWithTag:11];
        NSString *message=@"";
        if(lowGHighGRadioButton.isSelected){
            message=@"Please select checkbox of High G / Low G streaming";
        }else{
            message=@"Please select a command mode";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Response" message:message delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    }else{
        [deviceDataReader stopThread];
        [button setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        button.tag=101;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Response" message:@"File saved successfully" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        for(int i=0;i<[self.groupButtons count];i++){
            [[self.groupButtons objectAtIndex:i] setEnabled:TRUE];
        }
        [lowGButton setEnabled:TRUE];
        [highGButton setEnabled:TRUE];
    }
    
    
    
   
}

- (IBAction)stop:(id)sender {
    
   //    [sender setEnabled:FALSE];
//    [startButton setEnabled:TRUE];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Response" message:@"CSV file is created" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    for(int i=0;i<[self.groupButtons count];i++){
//        [[self.groupButtons objectAtIndex:i] setEnabled:TRUE];
//    }
}

- (IBAction)onRadioButtonClick:(id)sender {
    for(int i=0;i<[self.groupButtons count];i++){
        [[self.groupButtons objectAtIndex:i] setBackgroundImage:[UIImage
                                                       imageNamed:@"radio_uncheck.png"]
                                             forState:UIControlStateNormal];
        [[self.groupButtons objectAtIndex:i] setSelected:FALSE];
    }
    UIButton *radioButton=(UIButton *)sender;
    [radioButton setBackgroundImage:[UIImage imageNamed:@"radio_check.png"] forState:UIControlStateNormal];
    radioButton.selected=TRUE;
    
    [self setcommandMessage:[radioButton tag]];
    
    UIButton *lowGstreamModeButton= (UIButton *)[self.view viewWithTag:1];
    UIButton *highGstreamModeButton= (UIButton *)[self.view viewWithTag:2];
    [lowGstreamModeButton setBackgroundImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
    lowGstreamModeButton.selected=FALSE;
    [highGstreamModeButton setBackgroundImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
    highGstreamModeButton.selected=FALSE;

    
    
}


- (IBAction)onCheckboxClick:(id)sender {
    
   
    UIButton *streamModeButton= (UIButton *)[self.view viewWithTag:11];
    
    if (streamModeButton.isSelected) {

       UIButton *checkboxButton=(UIButton *)sender;
        if (checkboxButton.isSelected) {
            [checkboxButton setBackgroundImage:[UIImage imageNamed:@"unchecked_checkbox.png"] forState:UIControlStateNormal];
            checkboxButton.selected=FALSE;
            commandMode=NULL;
        }else{
            [checkboxButton setBackgroundImage:[UIImage imageNamed:@"checked_checkbox.png"] forState:UIControlStateNormal];
            checkboxButton.selected=TRUE;
        }
        
        UIButton *lowGStreamButton=(UIButton *)[self.view viewWithTag:1];
        UIButton *highGStreamButton=(UIButton *)[self.view viewWithTag:2];
        if (lowGStreamButton.isSelected) {
            commandMode=@"SetLowGStreamMode0x01";
        }else if (highGStreamButton.isSelected){
            
            commandMode=@"SetHighGStreamMode0x07";
        }
        if (lowGStreamButton.isSelected && highGStreamButton.isSelected) {
            commandMode=@"SetLowGAndHighGStreamMode";
        }
        
        
    }
    
}

-(void)setcommandMessage:(int) command{
    switch (command) {
        case 11:
            commandMode=NULL;
            break;
        case 12:
            commandMode=@"GetVersion0x00";
            break;
        case 13:
            commandMode=@"GetLowGStreamMode0x02";
            break;
        case 14:
            commandMode=@"SetLowGStreamBegThreshold0x03";
            break;
        case 15:
            commandMode=@"GetLowGStreamBegThreshold0x04";
            break;
        case 16:
            commandMode=@"SetLowGStreamEndThreshold0x05";
            break;
        case 17:
            commandMode=@"GetLowGStreamEndThreshold0x06";
            break;
        case 18:
            commandMode=@"GetHighGStreamMode0x08";
            break;
        case 19:
            commandMode=@"SetHighGStreamBegThreshold0x09";
            break;
        case 20:
            commandMode=@"GetHighGStreamBegThreshold0x0A";
            break;
        case 21:
            commandMode=@"SetHighGStreamEndThreshold0x0B";
            break;
        case 22:
            commandMode=@"GetHighGStreamEndThreshold0x0C";
            break;
        case 23:
            commandMode=@"GetTemperature0x0D";
            break;
            
        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
