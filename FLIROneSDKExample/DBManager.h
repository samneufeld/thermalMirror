//
//  DBManager.h
//  FLIROneSDKExample
//
//  Created by Sam Neufeld on 11/7/17.
//  Copyright © 2017 novacoast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
@end
