//
//  ProjectGlobals.h
//
//  Created by konstantin on 17/05/2012.
//  Copyright (c) 2012 KTTSoft. All rights reserved.
//

#ifndef LOCALIZED
    #define LOCALIZED(arg) NSLocalizedString(arg, nil)
#endif

extern BOOL PRJ_Is_iPad;
extern BOOL PRJ_Is_iPhone;

extern CGFloat PRJ_SystemVersion;
extern NSString *PRJ_temperatureUnit;

void InitProjectGlobals(void);

void ShowTitleErrorAlert(NSString *title, NSError *error);
void ShowErrorAlert(NSError *error);

void ShowTitleAlert(NSString *title, NSString *message);
void ShowAlert(NSString *message);


