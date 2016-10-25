//
//  JSONModel.h
//  HOAKit
//
//  Created by birneysky on 16/8/13.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEJSONModel : NSObject

- (instancetype) initWithDictionary:(NSDictionary*)jsonDic;

- (NSString*) toJsonString;

- (NSData*) toJsonData;

- (NSDictionary*) toDictionary;

- (NSString*) toFullJsonString;

- (NSData*) toFullJsonData;

- (NSDictionary*) toFullDictionary;

@end
