//
//  GGKTakeAdvancedDelayedPhotosViewController.m
//  Mercy Camera
//
//  Created by Geoff Hom on 5/6/13.
//  Copyright (c) 2013 Geoff Hom. All rights reserved.
//

#import "GGKTakeAdvancedDelayedPhotosViewController.h"

#import "NSNumber+GGKAdditions.h"
#import "NSString+GGKAdditions.h"

const NSInteger GGKTakeAdvancedDelayedPhotosDefaultNumberOfPhotosInteger = 5;

const NSInteger GGKTakeAdvancedDelayedPhotosDefaultNumberOfTimeUnitsBetweenPhotosInteger = 7;

const NSInteger GGKTakeAdvancedDelayedPhotosDefaultNumberOfTimeUnitsToInitiallyWaitInteger = 10;

const GGKTimeUnit GGKTakeAdvancedDelayedPhotosDefaultTimeUnitBetweenPhotosTimeUnit = GGKTimeUnitSeconds;

const GGKTimeUnit GGKTakeAdvancedDelayedPhotosDefaultTimeUnitForInitialWaitTimeUnit = GGKTimeUnitSeconds;

NSString *GGKTakeAdvancedDelayedPhotosNumberOfPhotosKeyString = @"Take advanced delayed photos: number of photos.";

NSString *GGKTakeAdvancedDelayedPhotosNumberOfTimeUnitsBetweenPhotosKeyString = @"Take advanced delayed photos: number of time units between photos.";

NSString *GGKTakeAdvancedDelayedPhotosNumberOfTimeUnitsToInitiallyWaitKeyString = @"Take advanced delayed photos: number of time units to initially wait.";

NSString *GGKTakeAdvancedDelayedPhotosTimeUnitBetweenPhotosKeyString = @"Take advanced delayed photos: time unit to use between photos.";

NSString *GGKTakeAdvancedDelayedPhotosTimeUnitForInitialWaitKeyString = @"Take advanced delayed photos: time unit to use to initially wait.";

@interface GGKTakeAdvancedDelayedPhotosViewController ()


// Story: User taps button. Popover appears. User makes selection in popover. User sees updated button.
// The button the user tapped to display the popover.
@property (nonatomic, strong) UIButton *currentPopoverButton;

// For dismissing the current popover. Would name "popoverController," but UIViewController already has a private variable named that.
@property (nonatomic, strong) UIPopoverController *currentPopoverController;

// Override.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end

@implementation GGKTakeAdvancedDelayedPhotosViewController

- (void)captureManagerDidTakePhoto:(id)sender
{
    [super captureManagerDidTakePhoto:sender];
    
    NSInteger theNumberOfTimeUnitsBetweenPhotosInteger = [[NSUserDefaults standardUserDefaults] integerForKey:GGKTakeAdvancedDelayedPhotosNumberOfTimeUnitsBetweenPhotosKeyString];
    if (theNumberOfTimeUnitsBetweenPhotosInteger == 0 && self.numberOfPhotosRemainingToTake > 0) {
        
        [self takePhoto];
    }
}

- (void)handleInitialWaitDone
{
    self.numberOfPhotosRemainingToTake = [[NSUserDefaults standardUserDefaults] integerForKey:GGKTakeAdvancedDelayedPhotosNumberOfPhotosKeyString];
//    [self startTakingPhotos];
}

- (void)prepareForSegue:(UIStoryboardSegue *)theSegue sender:(id)theSender {
    
    if ([theSegue.identifier isEqualToString:@"ShowTimeUnitsSelector1"] || [theSegue.identifier isEqualToString:@"ShowTimeUnitsSelector2"]) {
        
        // Retain popover controller, to dismiss later.
        self.currentPopoverController = [(UIStoryboardPopoverSegue *)theSegue popoverController];
        
        // Note which button was tapped, to update later.
        self.currentPopoverButton = theSender;
        
        GGKTimeUnitsTableViewController *aTimeUnitsTableViewController = (GGKTimeUnitsTableViewController *)self.currentPopoverController.contentViewController;
        aTimeUnitsTableViewController.delegate = self;
        
        // Set current time unit.
        NSString *theCurrentTimeUnitString = [self.currentPopoverButton titleForState:UIControlStateNormal];
        aTimeUnitsTableViewController.currentTimeUnit = [GGKTimeUnits timeUnitForString:theCurrentTimeUnitString];
    }
}

- (void)timeUnitsTableViewControllerDidSelectTimeUnit:(id)sender
{
    // Store the time unit for the proper setting.
    
    GGKTimeUnitsTableViewController *aTimeUnitsTableViewController = (GGKTimeUnitsTableViewController *)sender;
    GGKTimeUnit theCurrentTimeUnit = aTimeUnitsTableViewController.currentTimeUnit;
    NSInteger anOkayInteger = theCurrentTimeUnit;
    
    NSString *theKey;
    if (self.currentPopoverButton == self.timeUnitsToInitiallyWaitButton) {
        
        theKey = GGKTakeAdvancedDelayedPhotosTimeUnitForInitialWaitKeyString;
    } else if (self.currentPopoverButton == self.timeUnitsBetweenPhotosButton) {
        
        theKey = GGKTakeAdvancedDelayedPhotosTimeUnitBetweenPhotosKeyString;
    }
    
    // Set the new value, then update the entire UI.
    [[NSUserDefaults standardUserDefaults] setInteger:anOkayInteger forKey:theKey];
    [self updateSettings];
    
    [self.currentPopoverController dismissPopoverAnimated:YES];
}

- (void)updateLayoutForLandscape
{
    [super updateLayoutForLandscape];
}

- (void)updateLayoutForPortrait
{
    [super updateLayoutForPortrait];
    
//    // The left margin.
//    CGFloat aMarginX1Float = 20;
//    
//    // The vertical gap between the end of one section and the start of another.
//    CGFloat theSectionGapFloat = 40;
//    
//    // The vertical gap between the end of one text and the start of another.
//    CGFloat theTextGapFloat = 30;
//    
//    // The vertical gap between a header and the next label.
//    CGFloat theHeaderGapFloat = 8;
//    
//    // First text for greeting. Centered horizontally.
//    CGSize aSize = self.greeting1Label.frame.size;
//    self.greeting1Label.frame = CGRectMake(153, theSectionGapFloat, aSize.width, aSize.height);
//    
//    // More text for the greeting.
//    CGRect aPreviousViewFrame = self.greeting1Label.frame;
//    CGFloat aYFloat = aPreviousViewFrame.origin.y + aPreviousViewFrame.size.height + theTextGapFloat;
//    aSize = self.greeting2Label.frame.size;
//    self.greeting2Label.frame = CGRectMake(aMarginX1Float, aYFloat, aSize.width, aSize.height);
//    
//    // More text for the greeting.
//    aPreviousViewFrame = self.greeting2Label.frame;
//    aYFloat = aPreviousViewFrame.origin.y + aPreviousViewFrame.size.height + theTextGapFloat;
//    aSize = self.greeting3Label.frame.size;
//    self.greeting3Label.frame = CGRectMake(aMarginX1Float, aYFloat, aSize.width, aSize.height);
//    
//    // Header: "Rate us"
//    aPreviousViewFrame = self.greeting3Label.frame;
//    aYFloat = aPreviousViewFrame.origin.y + aPreviousViewFrame.size.height + theSectionGapFloat;
//    aSize = self.rateUsHeaderLabel.frame.size;
//    self.rateUsHeaderLabel.frame = CGRectMake(aMarginX1Float, aYFloat, aSize.width, aSize.height);
//    
//    // Text for "Rate us"
//    aPreviousViewFrame = self.rateUsHeaderLabel.frame;
//    aYFloat = aPreviousViewFrame.origin.y + aPreviousViewFrame.size.height + theHeaderGapFloat;
//    aSize = self.rateUsTextLabel.frame.size;
//    self.rateUsTextLabel.frame = CGRectMake(aMarginX1Float, aYFloat, aSize.width, aSize.height);
//    
//    // Button for "Rate us"
//    // The button should be at the end of the text. The button height is greater than the text, so we'll align the button top with the text top.
//    aPreviousViewFrame = self.rateUsTextLabel.frame;
//    aYFloat = aPreviousViewFrame.origin.y;
//    aSize = self.rateUsButton.frame.size;
//    self.rateUsButton.frame = CGRectMake(414, aYFloat, aSize.width, aSize.height);
//    
//    // Header: "Donate"
//    aPreviousViewFrame = self.rateUsTextLabel.frame;
//    aYFloat = aPreviousViewFrame.origin.y + aPreviousViewFrame.size.height + theSectionGapFloat;
//    aSize = self.donateHeaderLabel.frame.size;
//    self.donateHeaderLabel.frame = CGRectMake(aMarginX1Float, aYFloat, aSize.width, aSize.height);
//    
//    // First text for "Donate"
//    aPreviousViewFrame = self.donateHeaderLabel.frame;
//    aYFloat = aPreviousViewFrame.origin.y + aPreviousViewFrame.size.height + theHeaderGapFloat;
//    aSize = self.donateTextLabel.frame.size;
//    self.donateTextLabel.frame = CGRectMake(aMarginX1Float, aYFloat, aSize.width, aSize.height);
//    
//    // More text for "Donate"
//    aPreviousViewFrame = self.donateTextLabel.frame;
//    aYFloat = aPreviousViewFrame.origin.y + aPreviousViewFrame.size.height + theTextGapFloat;
//    aSize = self.giveADollarLabel.frame.size;
//    self.giveADollarLabel.frame = CGRectMake(aMarginX1Float, aYFloat, aSize.width, aSize.height);
//    
//    // Button for "Donate"
//    // The button should be at the end of the text. The button height is greater than the text, so we'll align the button top with the text top.
//    aPreviousViewFrame = self.giveADollarLabel.frame;
//    aYFloat = aPreviousViewFrame.origin.y;
//    aSize = self.giveADollarButton.frame.size;
//    self.giveADollarButton.frame = CGRectMake(469, aYFloat, aSize.width, aSize.height);
//    
//    // Stars for "Donate"
//    aPreviousViewFrame = self.giveADollarLabel.frame;
//    aYFloat = aPreviousViewFrame.origin.y + aPreviousViewFrame.size.height + theTextGapFloat;
//    aSize = self.starsLabel.frame.size;
//    self.starsLabel.frame = CGRectMake(aMarginX1Float, aYFloat, aSize.width, aSize.height);
//    
//    // Header: "Give feedback"
//    aPreviousViewFrame = self.starsLabel.frame;
//    aYFloat = aPreviousViewFrame.origin.y + aPreviousViewFrame.size.height + theSectionGapFloat;
//    aSize = self.giveFeedbackHeaderLabel.frame.size;
//    self.giveFeedbackHeaderLabel.frame = CGRectMake(aMarginX1Float, aYFloat, aSize.width, aSize.height);
//    
//    // Text for "Give feedback"
//    aPreviousViewFrame = self.giveFeedbackHeaderLabel.frame;
//    aYFloat = aPreviousViewFrame.origin.y + aPreviousViewFrame.size.height + theHeaderGapFloat;
//    aSize = self.giveFeedbackTextLabel.frame.size;
//    self.giveFeedbackTextLabel.frame = CGRectMake(aMarginX1Float, aYFloat, aSize.width, aSize.height);
//    
//    // Button for "Give feedback"
//    // Button bottom is aligned with text bottom.
//    aSize = self.emailTheCreatorsButton.frame.size;
//    aPreviousViewFrame = self.giveFeedbackTextLabel.frame;
//    aYFloat = aPreviousViewFrame.origin.y + aPreviousViewFrame.size.height - aSize.height;
//    self.emailTheCreatorsButton.frame = CGRectMake(446, aYFloat, aSize.width, aSize.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set keys for user defaults.
    self.numberOfTimeUnitsToInitiallyWaitKeyString = GGKTakeAdvancedDelayedPhotosNumberOfTimeUnitsToInitiallyWaitKeyString;
    self.timeUnitForInitialWaitKeyString = GGKTakeAdvancedDelayedPhotosTimeUnitForInitialWaitKeyString;
    self.numberOfPhotosToTakeKeyString = GGKTakeAdvancedDelayedPhotosNumberOfPhotosKeyString;
    self.numberOfTimeUnitsBetweenPhotosKeyString = GGKTakeAdvancedDelayedPhotosNumberOfTimeUnitsBetweenPhotosKeyString;
    self.timeUnitBetweenPhotosKeyString = GGKTakeAdvancedDelayedPhotosTimeUnitBetweenPhotosKeyString;
    
    [self updateSettings];
}

@end