//
//  SCReachability+Shared.h
//  SCReachability
//
//  Created by 许乾隆 on 2017/2/14.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import "SCReachability.h"

#define __SCNetNotReachable (SCNotReachable == [SCReachability sharedReachability].reachStatus)
#define __SCNetReachable (! __SCNetNotReachable)
#define __SCNetWWANReached (SCReachableViaWWAN == [[SCReachability sharedReachability]reachStatus])
#define __SCNetWIFIReached (SCReachableViaWiFi == [[SCReachability sharedReachability]reachStatus])

@interface SCReachability (Shared)

///单利
+ (instancetype)sharedReachability;

@end

