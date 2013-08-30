//
//  ImagePanelController.m
//  WindowList
//
//  Created by Genji on 2013/08/31.
//  Copyright (c) 2013 Genji App. All rights reserved.
//

#import "ImagePanelController.h"

@interface ImagePanelController ()

@property (weak) IBOutlet NSImageView *imageView;

@end

@implementation ImagePanelController

+ (id)sharedImagePanelController
{
  static ImagePanelController *sharedImagePanelController = nil;
  if(!sharedImagePanelController) {
    sharedImagePanelController = [[ImagePanelController alloc] init];
    [sharedImagePanelController window];
  }
  return sharedImagePanelController;
}

- (id)init
{
  self = [super initWithWindowNibName:@"ImagePanelController"];
  return self;
}

- (void)windowDidLoad
{
  [super windowDidLoad];
}


#pragma mark -
#pragma mark Public Method
- (void)setImage:(NSImage *)image
{
  [self.imageView setImage:image];
  [[self window] setContentSize:[image size]];
}

@end
