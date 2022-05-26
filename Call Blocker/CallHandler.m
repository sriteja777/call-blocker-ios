//
//  CallHandler.m
//  Call Blocker
//
//  Created by Sriteja Sugoor on 26/05/22.
//

#import <Foundation/Foundation.h>

#import "CallHandler.h"

static BOOL isGlobalCallBlock;

@implementation CallHandler


extern NSString* const kCTSMSMessageReceivedNotification;
extern NSString* const kCTSMSMessageReplaceReceivedNotification;
extern NSString* const kCTSIMSupportSIMStatusNotInserted;
extern NSString* const kCTSIMSupportSIMStatusReady;



typedef struct __CTCall CTCall;
extern NSString *CTCallCopyAddress(void*, CTCall *);
extern void CTCallDisconnect(CTCall*);

void* CTSMSMessageSend(id server,id msg);
typedef struct __CTSMSMessage CTSMSMessage;
NSString *CTSMSMessageCopyAddress(void *, CTSMSMessage *);
NSString *CTSMSMessageCopyText(void *, CTSMSMessage *);


int CTSMSMessageGetRecordIdentifier(void * msg);
NSString * CTSIMSupportGetSIMStatus();
NSString * CTSIMSupportCopyMobileSubscriberIdentity();

id  CTSMSMessageCreate(void* unknow/*always 0*/,NSString* number,NSString* text);
void * CTSMSMessageCreateReply(void* unknow/*always 0*/,void * forwardTo,NSString* text);


id CTTelephonyCenterGetDefault(void);
void CTTelephonyCenterAddObserver(id,id,CFNotificationCallback,NSString*,void*,int);
void CTTelephonyCenterRemoveObserver(id,id,NSString*,void*);
int CTSMSMessageGetUnreadCount(void);

#pragma mark - Call Block Methods

+ (void)start
{
    
    NSLog(@"startingg callhandler");

    @autoreleasepool
    {
        // Initialize listener by adding CT Center observer implicit
        id ct = CTTelephonyCenterGetDefault();
        CTTelephonyCenterAddObserver( ct, NULL, callback,NULL,NULL,
                                     CFNotificationSuspensionBehaviorHold);

        // Handle Interrupts
        sig_t oldHandler = signal(SIGINT, signalHandler);
        if (oldHandler == SIG_ERR)
        {
            printf("Could not establish new signal handler");
            exit(1);
        }

        // Run loop lets me catch notifications
        printf("Starting run loop and watching for notification.\n");
        CFRunLoopRun();

        // Shouldn't ever get here. Bzzzt
        printf("Unexpectedly back from CFRunLoopRun()!\n");

        [CallHandler stop];
//        [[MobileControlHandler sharedInstance] selfScheduledTimer];
    }
}
BOOL runLoopIsStopped;
+ (void)stop
{
    @autoreleasepool
    {
        CFRunLoopStop(CFRunLoopGetCurrent());
//
//        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//        NSDate *date = [NSDate distantFuture];
//        while (!runLoopIsStopped && [runLoop runMode:NSDefaultRunLoopMode beforeDate:date]);
        printf("Stopping run loop and removing watch for notification.\n");
    }

}

- (void)startCFRunLoopRun
{
    CFRunLoopRun();
}

static void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *notifyname=(__bridge NSString *)name;

    if ([notifyname isEqualToString:@"kCTCallStatusChangeNotification"])//电话
    {
        NSDictionary *info = (__bridge NSDictionary*)userInfo;
        NSString *state=[info[@"kCTCallStatus"] stringValue];

        if ([state isEqualToString:@"5"])//disconnect
            NSLog(@"Missed phone call: %@",state);

    }
    else if ([notifyname isEqualToString:@"kCTCallIdentificationChangeNotification"])
    {
        NSDictionary *info = (__bridge NSDictionary *)userInfo;
        CTCall *call = (__bridge CTCall *)info[@"kCTCall"];
        NSString *caller = CTCallCopyAddress(NULL, call);
        NSLog(@"Phone Number: %@",caller);

        // #0

//        NSString *defaultsKey = [[NSUserDefaults standardUserDefaults] objectForKey:[[MobileControlHandler sharedInstance] getCallBlockDefaultsKey]];
//
//        if ([defaultsKey isEqualToString:@"YES"])
//        {
            //disconnect this call
            NSLog(@"Disconnect all phone calls");
            CTCallDisconnect(call);
//        }

        // #1
        /*
        NSMutableArray *arrayOfAllPhones = [[MobileControlHandler sharedInstance] getAllContactsPhoneNumbers];
        for (int i = 0; i < arrayOfAllPhones.count; i++)
        {
            NSString *phoneNumber = [arrayOfAllPhones objectAtIndex:i];

            if ([caller isEqualToString:phoneNumber])
            {
                //disconnect this call
                NSLog(@"挂雷冰");
                CTCallDisconnect(call);
            }
        }
        */

        // #2
        /*
        if ([caller isEqualToString:@"1800-800-800"])
        {
            //disconnect this call
            NSLog(@"挂雷冰");
            CTCallDisconnect(call);
        }
        */

    }
    else if ([notifyname isEqualToString:@"kCTMessageReceivedNotification"])//收到短信
    {
        /*
         kCTMessageIdKey = "-2147483636";
         kCTMessageTypeKey = 1;
         */

//        NSDictionary *info = (NSDictionary *)userInfo;
//        CFNumberRef msgID = (CFNumberRef)info[@"kCTMessageIdKey"];
//        int result;
//        CFNumberGetValue((CFNumberRef)msgID, kCFNumberSInt32Type, &result);
//
//
//         Class CTMessageCenter = NSClassFromString(@"CTMessageCenter");
//         id mc = [CTMessageCenter sharedMessageCenter];
//         id incMsg = [mc incomingMessageWithId: result];
//
//         int msgType = (int)[incMsg messageType];
//
//         if (msgType == 1) //experimentally detected number
//         {
//         id phonenumber = [incMsg sender];
//
//         NSString *senderNumber = (NSString *)[phonenumber canonicalFormat];
//         id incMsgPart = [incMsg items][0];
//         NSData *smsData = [incMsgPart data];
//         NSString *smsText = [[NSString alloc] initWithData:smsData encoding:NSUTF8StringEncoding];
//
//         }

    }
    else if ([notifyname isEqualToString:@"kCTIndicatorsSignalStrengthNotification"])//信号
    {
        /*
         kCTIndicatorsGradedSignalStrength = 2;
         kCTIndicatorsRawSignalStrength = "-101";
         kCTIndicatorsSignalStrength = 19;
         */

    }
    else if ([notifyname isEqualToString:@"kCTRegistrationStatusChangedNotification"])//网络注册状态
    {
        /*
         kCTRegistrationInHomeCountry = 1;
         kCTRegistrationStatus = kCTRegistrationStatusRegisteredHome;
         */

    }
    else if ([notifyname isEqualToString:@"kCTRegistrationDataStatusChangedNotification"])
    {
        /*
         kCTRegistrationDataActive = 1;
         kCTRegistrationDataAttached = 1;
         kCTRegistrationDataConnectionServices =     (
         kCTDataConnectionServiceTypeInternet,
         kCTDataConnectionServiceTypeWirelessModemTraffic,
         kCTDataConnectionServiceTypeWirelessModemAuthentication
         );
         kCTRegistrationDataContextID = 0;
         kCTRegistrationDataIndicator = kCTRegistrationDataIndicator3G;
         kCTRegistrationDataStatus = kCTRegistrationDataStatusAttachedAndActive;
         kCTRegistrationDataStatusInternationalRoaming = 1;
         kCTRegistrationRadioAccessTechnology = kCTRegistrationRadioAccessTechnologyUTRAN;
         */
    }
    else if ([notifyname isEqualToString:@"kCTRegistrationCellChangedNotification"])
    {
        /*
         kCTRegistrationGsmCellId = 93204174;
         kCTRegistrationGsmLac = 55583;
         kCTRegistrationInHomeCountry = 1;
         kCTRegistrationRadioAccessTechnology = kCTRegistrationRadioAccessTechnologyUTRAN;
         */
    }
    else if ([notifyname isEqualToString:@"kCTIndicatorRadioTransmitNotification"])
    {
        /*
         kCTRadioTransmitDCHStatus = 1;
         */
    }
    //NSLog(@"First Name: %@, Details :%@", notifyname,cuserInfo);


}

static void signalHandler(int sigraised)
{
    NSLog(@"\nInterrupted.\n");
    exit(0);
}


@end

