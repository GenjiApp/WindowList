//
//  NSImage+Additions.h
//  WindowList
//
//  Created by Genji on 2013/09/04.
//  Copyright (c) 2013 Genji App. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Additions)

- (NSData *)PNGRepresentation;
- (NSImage *)thumbnailImageWithEdgeLength:(CGFloat)length;

@end
