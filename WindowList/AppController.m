//
//  AppController.m
//  WindowList
//
//  Created by Genji on 2013/09/01.
//  Copyright (c) 2013 Genji App. All rights reserved.
//

#import "AppController.h"
#import "ImagePanelController.h"

typedef NS_ENUM(NSInteger, RefreshMode) {
  kRefreshModeAuto = 0,
  kRefreshModeManual,
};

@implementation AppController
{
  CGWindowListOption _listOption;
  CGWindowImageOption _imageOption;
  NSTimer *_timer;
}

- (id)init
{
  self = [super init];
  return self;
}

- (void)dealloc
{
  [self deactivateTimer];
  [self removeObserver:self forKeyPath:@"refreshRate"];
  [self.arrayController removeObserver:self forKeyPath:@"selectedObjects"];
}

- (void)awakeFromNib
{
  self.refreshRate = 2;
  _listOption = kCGWindowListOptionAll;
  if([self.includeOffscreenWindowsOptionCheckBox state] == NSOffState) {
    _listOption |= kCGWindowListOptionOnScreenOnly;
  }
  if([self.includeDesktopElementsOptionCheckBox state] == NSOffState) {
    _listOption |= kCGWindowListExcludeDesktopElements;
  }
  if([self.refreshModeRadioButtonMatrix selectedRow] == kRefreshModeAuto) {
    [self activateTimer];
  }

  _imageOption = kCGWindowImageDefault;
  if([self.ignoreFramingCheckBox state] == NSOnState) {
    _imageOption |= kCGWindowImageBoundsIgnoreFraming;
  }
  if([self.shouldBeOpaqueCheckBox state] == NSOnState) {
    _imageOption |= kCGWindowImageShouldBeOpaque;
  }
  if([self.onlyShadowsCheckBox state] == NSOnState) {
    _imageOption |= kCGWindowImageOnlyShadows;
  }

  [self addObserver:self
         forKeyPath:@"refreshRate"
            options:NSKeyValueObservingOptionNew
            context:NULL];
  [self.arrayController addObserver:self
                         forKeyPath:@"selectedObjects"
                            options:NSKeyValueObservingOptionNew
                            context:NULL];

  [self performSelector:@selector(updateWindowList) withObject:nil afterDelay:1.0];
}

#pragma mark -
#pragma mark Private Method
- (void)updateWindowList
{
  NSArray *selectedObjects = [self.arrayController selectedObjects];

  CFArrayRef windowList = CGWindowListCopyWindowInfo(_listOption, kCGNullWindowID);
  self.windowList = (__bridge NSArray *)windowList;
  CFRelease(windowList);
  [self.arrayController setContent:self.windowList];

  NSMutableIndexSet *selection = [NSMutableIndexSet indexSet];
  for(NSDictionary *selectedWindowInfo in selectedObjects) {
    CGWindowID selectedWindowID = [[selectedWindowInfo objectForKey:(NSString *)kCGWindowNumber] unsignedIntValue];
    for(NSDictionary *windowInfo in self.windowList) {
      CGWindowID windowID = [[windowInfo objectForKey:(NSString *)kCGWindowNumber] unsignedIntValue];
      if(windowID == selectedWindowID) {
        [selection addIndex:[self.windowList indexOfObject:windowInfo]];
        break;
      }
    }
  }
  [self.arrayController setSelectionIndexes:selection];
}

- (void)activateTimer
{
  [self deactivateTimer];
  _timer = [NSTimer scheduledTimerWithTimeInterval:self.refreshRate
                                            target:self
                                          selector:@selector(updateWindowList)
                                          userInfo:nil
                                           repeats:YES];
}
- (void)deactivateTimer
{
  if(_timer) {
    [_timer invalidate];
    _timer = nil;
  }
}

- (void)updateImageView
{
  NSArray *selectedObjects = [self.arrayController selectedObjects];
  NSUInteger count = [selectedObjects count];
  if(count) {
    CFMutableArrayRef windowIDs = CFArrayCreateMutable(NULL, count, NULL);
    for(CFIndex ii = 0; ii < count; ii++) {
      NSDictionary *windowInfo = [selectedObjects objectAtIndex:ii];
      CGWindowID windowID = [[windowInfo objectForKey:(NSString *)kCGWindowNumber] unsignedIntValue];
      CFArraySetValueAtIndex(windowIDs, ii, (void *)windowID);
    }

    CGImageRef cgImage = CGWindowListCreateImageFromArray(CGRectNull,
                                                          windowIDs,
                                                          _imageOption);
    CFRelease(windowIDs);
    NSSize size = NSMakeSize(CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
    NSImage *image = [[NSImage alloc] initWithCGImage:cgImage size:size];
    [self.imageView setImage:image];
    [[ImagePanelController sharedImagePanelController] setImage:image];
    CGImageRelease(cgImage);
  }
  else {
    [self.imageView setImage:nil];
    ImagePanelController *sharedImagePanelController = [ImagePanelController sharedImagePanelController];
    [sharedImagePanelController setImage:nil];
    [[sharedImagePanelController window] performClose:nil];
  }
}


#pragma mark -
#pragma mark Key-Value Observing Method
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  if([keyPath isEqualToString:@"refreshRate"]) {
    if([self.refreshModeRadioButtonMatrix selectedRow] == kRefreshModeAuto) [self activateTimer];
  }
  else if([keyPath isEqualToString:@"selectedObjects"]) {
    [self updateImageView];
  }
}


#pragma mark -
#pragma mark Key-Value Validation Method
- (BOOL)validateRefreshRate:(id *)ioValue error:(NSError **)ioError
{
  if([*ioValue integerValue] < 1) {
    NSNumber *placeHolderNumber = [NSNumber numberWithInteger:1];
    *ioValue = placeHolderNumber;
  }
  return YES;
}


#pragma mark -
#pragma mark Action Methods
- (IBAction)toggleIncludeOffscreenWindowsOption:(id)sender
{
  if([sender state] == NSOnState) _listOption &= ~kCGWindowListOptionOnScreenOnly;
  else _listOption |= kCGWindowListOptionOnScreenOnly;

  [self updateWindowList];
}

- (IBAction)toggleIncludeDesktopElementsOption:(id)sender
{
  if([sender state] == NSOnState) _listOption &= ~kCGWindowListExcludeDesktopElements;
  else _listOption |= kCGWindowListExcludeDesktopElements;

  [self updateWindowList];
}

- (IBAction)toggleRefreshMode:(id)sender
{
  RefreshMode mode = [sender selectedRow];
  switch(mode) {
    case kRefreshModeAuto  : [self activateTimer];   break;
    case kRefreshModeManual: [self deactivateTimer]; break;
  }
}

- (IBAction)refreshWindowList:(id)sender
{
  [self updateWindowList];
}

- (IBAction)toggleIgnoreFramingOption:(id)sender
{
  if([sender state] == NSOnState) _imageOption |= kCGWindowImageBoundsIgnoreFraming;
  else _imageOption &= ~kCGWindowImageBoundsIgnoreFraming;

  [self updateWindowList];
}

- (IBAction)toggleShouldBeOpaqueOption:(id)sender
{
  if([sender state] == NSOnState) _imageOption |= kCGWindowImageShouldBeOpaque;
  else _imageOption &= ~kCGWindowImageShouldBeOpaque;

  [self updateWindowList];
}

- (IBAction)toggleOnlyShadowsOption:(id)sender
{
  if([sender state] == NSOnState) _imageOption |= kCGWindowImageOnlyShadows;
  else _imageOption &= ~kCGWindowImageOnlyShadows;

  [self updateWindowList];
}

- (IBAction)showOrHideImagePanel:(id)sender
{
  ImagePanelController *sharedImagePanelController = [ImagePanelController sharedImagePanelController];
  if([[sharedImagePanelController window] isVisible]) {
    [[sharedImagePanelController window] performClose:nil];
  }
  else if([[self.arrayController selectionIndexes] count]) {
    [sharedImagePanelController showWindow:sender];
  }
}

@end
