//
//  SPConstants.h
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#ifndef Spruce_SPConstants_h
#define Spruce_SPConstants_h

// Layout

#define kSPDeviceWidth 320.0f
#define kSPDefaultPadding 10.0f
#define kSPDefaultContentWidth 300.0f

// Fonts

#define kSPTitleUIFont      [UIFont fontWithName:@"Knockout-50Welterweight" size:22.0f]

#define kSPDefaultUIFont    [UIFont systemFontOfSize:15.0f]
#define kSPDefaultCTFont    CTFontCreateWithName((CFStringRef)@"HelveticaNeue", 15.0f, NULL)

#define kSPBoldUIFont       [UIFont boldSystemFontOfSize:15.0f]
#define kSPBoldCTFont       CTFontCreateWithName((CFStringRef)@"HelveticaNeue-Bold", 15.0f, NULL)

#define kSPLargeUIFont      [UIFont boldSystemFontOfSize:17.0f]
#define kSPLargeCTFont      CTFontCreateWithName((CFStringRef)@"HelveticaNeue-Bold", 17.0f, NULL)

// Colors

#define kSPBackgroundColor  HEX_COLOR(0xebebe9)
#define kSPDefaultTextColor HEX_COLOR(0x555555)
#define kSPLinkTextColor    HEX_COLOR(0x2386aa)
#define kSPLightTextColor   HEX_COLOR(0x999999)
#define kSPHighlightColor   [UIColor colorWithWhite:1.0f alpha:0.5f]
#define kSPLineColor        HEX_COLOR(0xaaaaaa)

#endif
