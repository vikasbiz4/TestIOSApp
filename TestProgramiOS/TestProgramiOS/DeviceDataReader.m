//
//  DeviceDataReader.m
//  TestProgramiOS
//
//  Created by biz4sol-mac-1 on 30/09/14.
//  Copyright (c) 2014 Biz4Solutions. All rights reserved.
//

#import "DeviceDataReader.h"

@implementation DeviceDataReader
@synthesize boxerName,commandMode;
NSThread* myThread;

-(id)initWithBoxerName:(NSString *)name : (NSString *)mode{
    if (self=[super init]) {
        boxerName=name;
        commandMode=mode;
        
    }
    return self;
}

- (void) startThread{
    myThread = [[NSThread alloc] initWithTarget:self
                                       selector:@selector(readDataFromFile)
                                         object: nil];
    [myThread start];
}
-(void)stopThread{
    [myThread cancel];
}

-(NSFileHandle *)getFileWriterObject{
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MMM_dd_HH_mm_ss_SS"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fileName=[NSString stringWithFormat:@"%@_%@.csv",commandMode,currentDate];
    NSString *filePath=[docPath stringByAppendingPathComponent:fileName];
    
    NSFileHandle *filehandle;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager]
         createFileAtPath:filePath contents:nil attributes:nil];
         NSLog(@"file is created--%@",filePath);
        filehandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        [filehandle seekToEndOfFile];
        if ([commandMode isEqual:@"SetLowGStreamMode0x01"] || [commandMode  isEqual:@"SetHighGStreamMode0x07"]|| [commandMode  isEqual:@"SetLowGAndHighGStreamMode"]) {
            [filehandle writeData:[@"StartByte,MessageID,MessageLength(lsb),MessageLength(msb),Time0,Time1,Time2,Time3,Time,AX(lsb),AX(msb), AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb),AX(lsb),AX(msb),AY(lsb),AY(msb),AZ(lsb),AZ(msb)\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }else if([commandMode isEqual:@"GetVersion0x00"]){
            [filehandle writeData:[@"StartByte,MessageID,MessageLength(lsb),MessageLength(msb),MajorVersion,MinorVersion\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }else if ([commandMode isEqual:@"GetLowGStreamMode0x02"]||[commandMode isEqual:@"GetHighGStreamMode0x08"]){
            [filehandle writeData:[@"StartByte,MessageID,MessageLength(lsb),MessageLength(msb),Mode\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }else if ([commandMode isEqual:@"GetTemperature0x0D"]){
            [filehandle writeData:[@"StartByte,MessageID,MessageLength(lsb),MessageLength(msb),Temperature(LSB),Temperature(MSB)\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }else if ([commandMode isEqual:@"GetLowGStreamBegThreshold0x04"] || [commandMode isEqual:@"GetLowGStreamEndThreshold0x06"] || [commandMode isEqual:@"GetHighGStreamBegThreshold0x0A"] || [ commandMode isEqual:@"GetHighGStreamEndThreshold0x0C"]){
            [filehandle writeData:[@"StartByte,MessageID,MessageLength(lsb),MessageLength(msb),Threshold(LSB),Threshold(MSB)\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        
        
    }else{
        filehandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    }
    return filehandle;

}
  

-(void)readDataFromFile{
    NSString *boxerFileName = [[NSBundle mainBundle] pathForResource:commandMode ofType:@"csv"];
    NSString *file = [NSString stringWithContentsOfFile:boxerFileName encoding:NSUTF8StringEncoding error:nil];
   
    if (!file) {
        NSLog(@"File is not present.");
        return;
    }
    
    NSArray *deviceDataArray = [[NSArray alloc] init];
    NSString *packetString;
    deviceDataArray = [file componentsSeparatedByString:@"\n"];
    int i=1;
    packetString=deviceDataArray[0];
    NSLog(@"packetString=%d",[deviceDataArray count]);
    NSFileHandle *fileWriterHandle=[self getFileWriterObject];
    while (true) {
        
        if (i<[deviceDataArray count]) {
            
            packetString=deviceDataArray[i];
        
            NSArray *packetArray=[[NSArray alloc]init];
            packetArray = [packetString componentsSeparatedByString:@","];
         
            for(NSString *byte in packetArray) {
            
                [fileWriterHandle writeData:[[NSString stringWithFormat:@"%@,",byte] dataUsingEncoding:NSUTF8StringEncoding]];
                
            
            }
            [fileWriterHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
            i++;
        }
        else{
            NSLog(@"Data reading finished");
            [fileWriterHandle closeFile];
            break;
        }
        if([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
    }
    
}

@end
