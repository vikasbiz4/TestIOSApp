//
//  MyObject.m
//  TestProgramiOS
//
//  Created by biz4sol-mac-1 on 29/09/14.
//  Copyright (c) 2014 Biz4Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyObject.h"


@implementation MyObject
@synthesize name;
@synthesize count;
int x=1;
NSThread* myThread;


-(id)initWithName:(NSString *)fname{
    if (self =[super init]) {
        name=fname;
    }
    return self;
}

- (void) startThread: (NSString *) common {
    myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(run:)
                                                object: common];
    name=common;
    count=1;
    
    [myThread start];
}

-(void)display{
    NSLog(@"name=%@",name);
}

//-(void)run:(id)param{
//    
//    
//    while (count>0) {
//               NSLog(@"%@ = %d",param,count);
//             count++;
//        
//       
//        if([[NSThread currentThread] isCancelled]) {
//            /* do some clean up here */
//            [NSThread exit];
//        }
//    };
//}
-(void)stopThread{
    [myThread cancel];
}

@end
