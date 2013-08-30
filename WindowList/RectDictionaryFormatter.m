//
//  RectDictionaryFormatter.m
//  WindowList
//
//  Created by Genji on 2013/08/30.
//  Copyright (c) 2013 Genji App. All rights reserved.
//

#import "RectDictionaryFormatter.h"

@implementation RectDictionaryFormatter

- (NSString *)stringForObjectValue:(id)obj
{
  if(![obj isKindOfClass:[NSDictionary class]]) return nil;

  CGRect rect;
  CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)obj, &rect);
  return NSStringFromRect(rect);
}

@end
