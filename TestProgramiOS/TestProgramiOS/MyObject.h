//
//  MyObject.h
//  TestProgramiOS
//
//  Created by biz4sol-mac-1 on 29/09/14.
//  Copyright (c) 2014 Biz4Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyObject : NSObject

@property NSString *name;
@property NSInteger count;
-(id)initWithName:(NSString *)fname;
-(void) startThread: (NSString *) common;
-(void) run: (NSString *) common;
-(void) stopThread;
-(void) display;

@end
