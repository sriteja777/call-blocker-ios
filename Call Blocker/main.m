//
//  main.m
//  Call Blocker
//
//  Created by Sriteja Sugoor on 25/05/22.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include <CoreFoundation/CoreFoundation.h>
#import "CallHandler.h"










int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    NSLog(@"sdsdf sdsdfsdfsf");
//    CallHandler *callHandler = [[CallHandler alloc]init] ;
//    [CallHandler start];

    
//    int ct = CTTelephonyCenterGetDefault();
//    CTTelephonyCenterAddObserver(ct,   // center
//                                 NULL, // observer
//                                 telephonyEventCallback,  // callback
//                                 NULL,                    // event name (or all)
//                                 NULL,                    // object
//                                 CFNotificationSuspensionBehaviorDeliverImmediately);

    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
