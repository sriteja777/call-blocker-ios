//
//  CallHandler.h
//  Call Blocker
//
//  Created by Sriteja Sugoor on 26/05/22.
//

#ifndef CallHandler_h
#define CallHandler_h

#import <Foundation/Foundation.h>
//#import "MobileControlHandler.h"



@interface CallHandler : NSObject
{
    //
}


static void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo);
static void signalHandler(int sigraised);

+ (void)start;
+ (void)stop;


@end


#endif /* CallHandler_h */
