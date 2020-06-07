//
//  CrayonView.m
//  ClassicCrayons
//
//  Created by Rebecca Bettencourt on 6/7/20.
//  Copyright (c) 2020 Kreative Software. All rights reserved.
//

#import "CrayonView.h"

@implementation CrayonView

- (void)dealloc {
    [_image release];
    [_text release];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_image) {
        NSRect bounds = [self bounds];
        NSSize size = [_image size];
        CGFloat x = bounds.origin.x + floor((bounds.size.width - size.width) / 2);
        CGFloat y = bounds.origin.y + floor((bounds.size.height - size.height) / 2);
        NSRect dr = NSMakeRect(x, y, size.width, size.height);
        NSRect sr = NSMakeRect(0, 0, size.width, size.height);
        [_image drawInRect:dr fromRect:sr operation:NSCompositeSourceOver fraction:1.0f];
        
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        [ps setAlignment:NSCenterTextAlignment];
        NSMutableDictionary *attr = [[NSMutableDictionary alloc] init];
        [attr setObject:ps forKey:NSParagraphStyleAttributeName];
        [attr setObject:[NSColor grayColor] forKey:NSForegroundColorAttributeName];
        [attr setObject:[NSFont systemFontOfSize:13] forKey:NSFontAttributeName];
        [_text drawInRect:dr withAttributes:attr];
    }
}

- (NSImage *)image {
    return _image;
}

- (void)setImage:(NSImage *)theImage {
    [_image release];
    _image = [theImage retain];
    [self setNeedsDisplay:YES];
}

- (NSString *)text {
    return _text;
}

- (void)setText:(NSString *)theText {
    [_text release];
    _text = [theText retain];
    [self setNeedsDisplay:YES];
}

- (id)target {
    return _target;
}

- (void)setTarget:(id)anObject {
    _target = anObject;
}

- (SEL)action {
    return _action;
}

- (void)setAction:(SEL)aSelector {
    _action = aSelector;
}

- (NSPoint)location {
    return _location;
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (_image) {
        NSRect bounds = [self bounds];
        NSSize size = [_image size];
        CGFloat x = bounds.origin.x + floor((bounds.size.width - size.width) / 2);
        CGFloat y = bounds.origin.y + floor((bounds.size.height - size.height) / 2);
        NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        _location = NSMakePoint(p.x - x, p.y - y);
        [[NSApplication sharedApplication] sendAction:_action to:_target from:self];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent {
    if (_image) {
        NSRect bounds = [self bounds];
        NSSize size = [_image size];
        CGFloat x = bounds.origin.x + floor((bounds.size.width - size.width) / 2);
        CGFloat y = bounds.origin.y + floor((bounds.size.height - size.height) / 2);
        NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        _location = NSMakePoint(p.x - x, p.y - y);
        [[NSApplication sharedApplication] sendAction:_action to:_target from:self];
    }
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {
    return YES;
}

@end
