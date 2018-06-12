//
//  SCReachability.h
//  SCReachability
//  https://github.com/debugly/SCReachabilityDemo

//  Created by xuqianlong on 16/6/15.
//  Copyright © 2016年 Apple Inc. All rights reserved.

//SCReachability fully support IPv6.

//!!! copy some Reachability.

//!!! support iOS 7 or later system. 

//Reachability fully support IPv6.

//auto start observer!



#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CoreTelephonyDefines.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


typedef NS_ENUM(NSInteger,SCReachStatus) {
    SCNotReachable = 0,
    SCReachableViaWiFi,
    SCReachableViaWWAN
};

typedef NS_ENUM(NSUInteger, SCWWANStatus) {
    SCWWANNotReachable = SCNotReachable,
    ///不允许WWAN网络；默认允许
    SCNetWorkStatusWWANRefused = 3,
    ///使用WWAN；
    SCNetWorkStatusWWAN4G = 4,
    SCNetWorkStatusWWAN3G = 5,
    SCNetWorkStatusWWAN2G = 6,
};

typedef NS_ENUM(NSUInteger, SCNetWorkStatusMask) {
    SCNetWorkStatusMaskUnavailable   = 1 << SCNotReachable,
    SCNetWorkStatusMaskReachableWiFi = 1 << SCReachableViaWiFi,//这里直接使用这个枚举即可
    SCNetWorkStatusMaskWWANRefused   = 1 << SCNetWorkStatusWWANRefused,
    
    SCNetWorkStatusMaskReachableWWAN4G = 1 << SCNetWorkStatusWWAN4G,
    SCNetWorkStatusMaskReachableWWAN3G = 1 << SCNetWorkStatusWWAN3G,
    SCNetWorkStatusMaskReachableWWAN2G = 1 << SCNetWorkStatusWWAN2G,
    
    SCNetWorkStatusMaskReachableWWAN = (SCNetWorkStatusMaskReachableWWAN2G | SCNetWorkStatusMaskReachableWWAN3G | SCNetWorkStatusMaskReachableWWAN4G),
    SCNetWorkStatusMaskNotReachable  = (SCNetWorkStatusMaskUnavailable     | SCNetWorkStatusMaskWWANRefused),
    SCNetWorkStatusMaskReachable     = (SCNetWorkStatusMaskReachableWiFi   | SCNetWorkStatusMaskReachableWWAN),
};

NS_INLINE BOOL isWiFiWithMask(SCNetWorkStatusMask mask)
{
    return mask & SCNetWorkStatusMaskReachableWiFi;
}

NS_INLINE BOOL isWiFiWithStatus(SCReachStatus status)
{
    return status == SCReachableViaWiFi;
}

///网络状态变化，同 Reachability
FOUNDATION_EXTERN NSString *const kSCReachabilityReachStatusChanged;
///WWAN变化；WiFi网络也会变，跟当前网络有关；
FOUNDATION_EXTERN NSString *const kSCReachabilityWWANChanged;
///统一后的网络变化
FOUNDATION_EXTERN NSString *const kSCReachabilityMaskChanged;

@interface SCReachability : NSObject

/*!
 * unavailable! use reachabilityWith**;
 */
- (instancetype)init NS_UNAVAILABLE;
/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

///直接获取WiFi IP 地址
+ (NSString *)currentWiFiIPAddress;

///you can observer them；
///网络总体情况；
@property (nonatomic, assign, readonly) SCNetWorkStatusMask netWorkMask;
///reachable: Wifi-WWAN-NotReach
@property (nonatomic, assign, readonly) SCReachStatus reachStatus;
///WWAN: 2、3、4G
@property (nonatomic, assign, readonly) SCWWANStatus wwanType;

///default is yes,sub class can assign me;
@property (nonatomic, assign, getter=isAllowUseWWAN)BOOL allowUseWWAN;

@property (nonatomic , copy, readonly) NSString *carrierName;
@property (nonatomic , copy, readonly) NSString *mobileNetworkCode;

///会走cache，获取WiFi IP 地址
- (NSString *)currentWiFiIPAddress;

@end

///log network mask to debug;
NS_INLINE NSString * SCNetWorkStatusMask2String(SCNetWorkStatusMask mask){
    switch (mask) {
        case SCNetWorkStatusMaskUnavailable:
            return @"没有网络！";
        case SCNetWorkStatusMaskReachableWiFi:
            return @"WiFi";
        case SCNetWorkStatusMaskWWANRefused:
            return @"不允许使用WWAN";
        case SCNetWorkStatusMaskReachableWWAN4G:
            return @"4G";
        case SCNetWorkStatusMaskReachableWWAN3G:
            return @"3G";
        case SCNetWorkStatusMaskReachableWWAN2G:
            return @"2G";
        case SCNetWorkStatusMaskReachableWWAN:
            return @"WWAN";
        case SCNetWorkStatusMaskNotReachable:
            return @"没有网络或者不允许使用WWAN";
        case SCNetWorkStatusMaskReachable:
            return @"WiFi或者WWAN";
        default:
            return nil;
    }
}
