//
//  NSImage+Additions.m
//  WindowList
//
//  Created by Genji on 2013/09/04.
//  Copyright (c) 2013 Genji App. All rights reserved.
//

#import "NSImage+Additions.h"

@implementation NSImage (Additions)

- (NSData *)PNGRepresentation
{
  NSData *imageData = [self TIFFRepresentation];
  NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
  return [imageRep representationUsingType:NSPNGFileType properties:nil];
}

- (NSImage *)thumbnailImageWithEdgeLength:(CGFloat)length
{
  NSImage *image = [self copy];
  NSSize size = [image size];
  if(length < size.width || length < size.height) {
    CGFloat longerEdge = MAX(size.width, size.height);
    CGFloat scale = length / longerEdge;
    NSSize thumbnailSize = NSMakeSize(size.width * scale,
                                      size.height * scale);
    [image setSize:thumbnailSize];
  }
  return image;
}

@end
