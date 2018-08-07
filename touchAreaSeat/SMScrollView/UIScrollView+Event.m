//
//  UIScrollView+Event.m
//  test
//
//  Created by ghwang on 2018/5/21.
//  Copyright © 2018年 ghwang. All rights reserved.
//

#import "UIScrollView+Event.h"

@implementation UIScrollView(Event)
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    //[super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
@end
