//
//  ImagePanelController.h
//  WindowList
//
//  Created by Genji on 2013/08/31.
//  Copyright (c) 2013 Genji App. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImagePanelController : NSWindowController

+ (id)sharedImagePanelController;

- (void)setImage:(NSImage *)image;

@end
