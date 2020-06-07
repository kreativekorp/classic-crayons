//
//  ClassicCrayons.m
//  ClassicCrayons
//
//  Created by Rebecca Bettencourt on 6/6/20.
//  Copyright (c) 2020 Kreative Software. All rights reserved.
//

#import "ClassicCrayons.h"

@implementation ClassicCrayons

- (id)initWithPickerMask:(NSUInteger)mask colorPanel:(NSColorPanel *)owningColorPanel {
    return [super initWithPickerMask:mask colorPanel:owningColorPanel];
}

- (void)dealloc {
    [_pickerView release];
    [_pickerImage release];
    [_colorImage release];
    [_colorImageRep release];
    [_colorArray release];
    [super dealloc];
}

- (BOOL)supportsMode:(NSColorPanelMode)mode {
    return (mode == NSRGBModeColorPanel) ? YES : NO;
}

- (NSColorPanelMode)currentMode {
    return NSRGBModeColorPanel;
}

- (NSView *)provideNewView:(BOOL)initialRequest {
    if (initialRequest) {
        // Load pickerView.
        if (![NSBundle loadNibNamed:@"ClassicCrayons" owner:self]) {
            NSLog(@"ERROR: couldn't load ClassicCrayons nib");
        }
        
        // Load pickerImage.
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *vpath = [bundle pathForResource:@"ClassicCrayons-View" ofType:@"png"];
        NSImage *view = [[NSImage alloc]initWithContentsOfFile:vpath];
        _pickerImage = [view retain];
        
        [_pickerView setImage:_pickerImage];
        [_pickerView setTarget:self];
        [_pickerView setAction:@selector(colorClicked:)];
        
        // Load colorImage.
        NSString *ipath = [bundle pathForResource:@"ClassicCrayons-Colors" ofType:@"png"];
        NSImage *image = [[NSImage alloc]initWithContentsOfFile:ipath];
        _colorImage = [image retain];
        _colorImageRep = [[[NSBitmapImageRep alloc]initWithData:[image TIFFRepresentation]] retain];
        
        // Load colorArray.
        NSString *apath = [bundle pathForResource:@"ClassicCrayons-Colors" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:apath];
        _colorArray = [[dict objectForKey:@"colors"] retain];
    }
    return _pickerView;
}

- (void)colorClicked:(id)sender {
    NSPoint p = [_pickerView location];
    NSSize size = [_colorImage size];
    if (p.x > 0 && p.y > 0 && p.x < size.width && p.y < size.height) {
        NSInteger x = p.x;
        NSInteger y = size.height - p.y;
        NSColor *color = [_colorImageRep colorAtX:x y:y];
        CGFloat r, g, b, a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        if (r < 1.0f || g > 0.0f || b < 1.0f) {
            [[self colorPanel] setColor:color];
        }
    }
}

- (void)setColor:(NSColor *)newColor {
    // Get the new color's components.
    CGFloat nr, ng, nb, na;
    [[newColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace] getRed:&nr green:&ng blue:&nb alpha:&na];
    // Find the closest color in the crayon box.
    CGFloat dist = 10.0f;
    NSString * name = NSLocalizedString(@"Unknown", @"Color name when plist is missing");
    for (NSDictionary *color in _colorArray) {
        CGFloat cr = [[color objectForKey:@"r"] floatValue] / 65535.0f;
        CGFloat cg = [[color objectForKey:@"g"] floatValue] / 65535.0f;
        CGFloat cb = [[color objectForKey:@"b"] floatValue] / 65535.0f;
        CGFloat cd = (cr-nr)*(cr-nr) + (cg-ng)*(cg-ng) + (cb-nb)*(cb-nb);
        if (cd < dist) {
            dist = cd;
            name = [color objectForKey:@"name"];
        }
    }
    // Set the color name in the picker UI.
    if (dist > 0.0001f) {
        name = [NSString stringWithFormat:NSLocalizedString(@"%@-ish", @"Color name for approximate color matches"), name];
    }
    [_pickerView setText:name];
}

- (NSString *)buttonToolTip {
    return NSLocalizedString(@"Classic Crayons", @"Tooltip for the color picker button");
}

- (NSImage *)provideNewButtonImage {
    return [NSImage imageNamed:@"NSColorPickerCrayon"];
}

- (NSSize)minContentSize {
    return NSMakeSize(238.0f, 244.0f);
}

@end
