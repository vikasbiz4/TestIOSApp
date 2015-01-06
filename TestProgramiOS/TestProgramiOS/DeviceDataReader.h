//
//  DeviceDataReader.h
//  TestProgramiOS
//
//  Created by biz4sol-mac-1 on 30/09/14.
//  Copyright (c) 2014 Biz4Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceDataReader : NSObject

@property NSString *boxerName;
@property NSString *commandMode;

-(id)initWithBoxerName:(NSString *)boxerName : (NSString *) mode;
-(void)readDataFromFile;
- (void) startThread;
-(void)stopThread;
-(NSFileHandle *)getFileWriterObject;


@end
