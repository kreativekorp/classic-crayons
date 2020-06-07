//
//  CrayonView.h
//  ClassicCrayons
//
//  Created by Rebecca Bettencourt on 6/7/20.
//  Copyright (c) 2020 Kreative Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CrayonView : NSView {
    NSImage *_image;
    NSString *_text;
    id _target;
    SEL _action;
    NSPoint _location;
}

- (NSImage *)image;
- (void)setImage:(NSImage *)theImage;
- (NSString *)text;
- (void)setText:(NSString *)theText;

- (id)target;
- (void)setTarget:(id)anObject;
- (SEL)action;
- (void)setAction:(SEL)aSelector;
- (NSPoint)location;
- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;

@end
