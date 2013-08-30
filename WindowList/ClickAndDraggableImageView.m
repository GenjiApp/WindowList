//
//  ClickAndDraggableImageView.m
//  WindowList
//
//  Created by Genji on 2013/08/31.
//  Copyright (c) 2013 Genji App. All rights reserved.
//

#import "ClickAndDraggableImageView.h"
#import "NSImage+Additions.h"

@implementation ClickAndDraggableImageView

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if(self) {
    // Initialization code here.
  }

  return self;
}

- (void)mouseUp:(NSEvent *)theEvent
{
  if(![self image]) return;

  SEL action = @selector(showOrHideImagePanel:);
  if([self.clickTarget respondsToSelector:action]) [self sendAction:action to:self.clickTarget];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
  if(![self image]) return;

  NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
  [pboard declareTypes:@[NSFilesPromisePboardType] owner:self];
  [pboard setPropertyList:@[@"png"] forType:NSFilesPromisePboardType];

  NSImage *dragImage = [[self image] thumbnailImageWithEdgeLength:[self bounds].size.width];
  NSPoint dragPosition = [self convertPoint:[theEvent locationInWindow] fromView:nil];
  dragPosition.x -= [dragImage size].width / 2.0;
  dragPosition.y -= [dragImage size].height / 2.0;

  [self dragImage:dragImage
               at:dragPosition
           offset:NSZeroSize
            event:theEvent
       pasteboard:pboard
           source:self
        slideBack:YES];
}

- (NSArray *)namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setLocale:[NSLocale currentLocale]];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH.mm.ss"];
  NSDate *date = [NSDate date];
  NSString *filename = [NSString stringWithFormat:@"WindowList %@.png",
                        [dateFormatter stringFromDate:date]];
  NSURL *destinationFileURL = [dropDestination URLByAppendingPathComponent:filename];
  NSData *imageData = [[self image] PNGRepresentation];
  [imageData writeToURL:destinationFileURL atomically:YES];

  return @[filename];
}

@end
