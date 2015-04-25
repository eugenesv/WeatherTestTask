//
//  ProjectGlobals.m
//
//  Created by konstantin on 17/05/2012.
//  Copyright (c) 2012 KTTSoft. All rights reserved.
//

#import "ProjectGlobals.h"
#import "Constants.h"

BOOL PRJ_Is_iPad;
BOOL PRJ_Is_iPhone;

NSString *PRJ_SessionID;

NSString *PRJ_temperatureUnit;

CGFloat PRJ_SystemVersion;

static int initialized = 0;

void InitProjectGlobals(void) {
    
    if (initialized)
        return;
    
    initialized = 1;
    
    PRJ_SystemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    
    PRJ_Is_iPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    PRJ_Is_iPhone = !PRJ_Is_iPad;
}

#pragma mark - Errors alerts

void ShowTitleErrorAlert(NSString *title, NSError *error) {
    
    if (error == nil)
        return;
    
    NSMutableString *errStr = [NSMutableString stringWithString: NSLocalizedString(@"Error", nil)];
    
    if (error.code)
        [errStr appendFormat:@": %ld", (long)error.code];
    
    // If the user info dictionary doesn’t contain a value for NSLocalizedDescriptionKey
    // error.localizedDescription is constructed from domain and code by default
    [errStr appendFormat:@"\n%@", error.localizedDescription];
    
    if (error.localizedFailureReason)
        [errStr appendFormat:@"\n%@", error.localizedFailureReason];
    
    if (error.localizedRecoverySuggestion)
        [errStr appendFormat:@"\n%@", error.localizedRecoverySuggestion];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:errStr delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    
    [alert show];
}

void ShowErrorAlert(NSError *error) {
    ShowTitleErrorAlert(@"", error);
}

void ShowTitleAlert(NSString *title, NSString *message) {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:LOCALIZED(@"OK") otherButtonTitles:nil];
    [alert show];
}

void ShowAlert(NSString *message) {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:LOCALIZED(@"OK") otherButtonTitles:nil];
    [alert show];
}

