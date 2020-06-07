//
//  ClassicCrayons.h
//  ClassicCrayons
//
//  Created by Rebecca Bettencourt on 6/6/20.
//  Copyright (c) 2020 Kreative Software. All rights reserved.
//

#import "CrayonView.h"

@interface ClassicCrayons : NSColorPicker<NSColorPickingCustom> {
    IBOutlet CrayonView *_pickerView;
    NSImage *_pickerImage;
    NSImage *_colorImage;
    NSBitmapImageRep *_colorImageRep;
    NSArray *_colorArray;
}

@end
