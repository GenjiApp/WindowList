//
//  ClickAndDraggableImageView.h
//  WindowList
//
//  Created by Genji on 2013/08/31.
//  Copyright (c) 2013 Genji App. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ClickAndDraggableImageView : NSImageView <NSDraggingSource>

@property (nonatomic, weak) IBOutlet id clickTarget;

@end
