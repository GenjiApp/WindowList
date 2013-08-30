//
//  AppController.h
//  WindowList
//
//  Created by Genji on 2013/09/01.
//  Copyright (c) 2013 Genji App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject

@property (weak) IBOutlet NSButton *includeOffscreenWindowsOptionCheckBox;
@property (weak) IBOutlet NSButton *includeDesktopElementsOptionCheckBox;
@property (weak) IBOutlet NSMatrix *refreshModeRadioButtonMatrix;
@property (weak) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSButton *ignoreFramingCheckBox;
@property (weak) IBOutlet NSButton *shouldBeOpaqueCheckBox;
@property (weak) IBOutlet NSButton *onlyShadowsCheckBox;

@property (nonatomic, strong) NSArray *windowList;
@property (nonatomic) NSInteger refreshRate;

- (IBAction)toggleIncludeOffscreenWindowsOption:(id)sender;
- (IBAction)toggleIncludeDesktopElementsOption:(id)sender;
- (IBAction)toggleRefreshMode:(id)sender;
- (IBAction)refreshWindowList:(id)sender;
- (IBAction)toggleIgnoreFramingOption:(id)sender;
- (IBAction)toggleShouldBeOpaqueOption:(id)sender;
- (IBAction)toggleOnlyShadowsOption:(id)sender;
- (IBAction)showOrHideImagePanel:(id)sender;

@end
