/*
 CustomBadge.h
 
 *** Description: ***
 With this class you can draw a typical iOS badge indicator with a custom text on any view.
 Please use the allocator customBadgeWithString to create a new badge.
 In this version you can modfiy the color inside the badge (insetColor),
 the color of the frame (frameColor), the color of the text and you can
 tell the class if you want a frame around the badge.
 
 *** License & Copyright ***
 Created by Sascha Marc Paulus www.spaulus.com on 04/2011. Version 2.0
 This tiny class can be used for free in private and commercial applications.
 Please feel free to modify, extend or distribution this class. 
 If you modify it: Please send me your modified version of the class.
 A commercial distribution of this class is not allowed.
 
 I would appreciate if you could refer to my website www.spaulus.com if you use this class.
 
 If you have any questions please feel free to contact me (open@spaulus.com).
 */


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{

    FromRight=1,//stretch from right corner to right
    FromLeft=2,//stretch from left corner to left
    FromRightToLeft = 3 //inner stretch from right to left
    
}DirectionType;

@interface CustomBadge : UIView {
	
	NSString *badgeText;
	UIColor *badgeTextColor;
	UIColor *badgeInsetColor;
	UIColor *badgeFrameColor;
	BOOL badgeFrame;
	BOOL badgeShining;
	CGFloat badgeCornerRoundness;
	CGFloat badgeScaleFactor;
    DirectionType direction;
    
    CGFloat super_width;//width of super view
    CGFloat offset_x;//right outer offset
    BOOL withShadow;
}
@property (nonatomic, assign) BOOL withShadow;
@property(nonatomic,assign) CGFloat super_width;
@property(nonatomic,assign) CGFloat offset_x;
@property(nonatomic,retain) NSString *badgeText;
@property(nonatomic,retain) UIColor *badgeTextColor;
@property(nonatomic,retain) UIColor *badgeInsetColor;
@property(nonatomic,retain) UIColor *badgeFrameColor;

@property(nonatomic,readwrite) BOOL badgeFrame;
@property(nonatomic,readwrite) BOOL badgeShining;

@property(nonatomic,readwrite) CGFloat badgeCornerRoundness;
@property(nonatomic,readwrite) CGFloat badgeScaleFactor;
//@property (nonatomic, assign) CGFloat lineWidth;

+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString direction:(DirectionType)dir;

+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining direction:(DirectionType)dir;

+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining withShadow:(BOOL)withShadow direction:(DirectionType)dir;

- (id) initWithString:(NSString *)badgeString withScale:(CGFloat)scale withShining:(BOOL)shining direction:(DirectionType)dir;

- (id) initWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining  direction:(DirectionType)dir;

- (id) initWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining withShadow:(BOOL)withShadow direction:(DirectionType)dir;

- (void) autoBadgeSizeWithString:(NSString *)badgeString;

- (void)autoBadgeSizeWithString:(NSString *)badgeString badgeTextColor:(UIColor *)badgeTextColor badgeFrameColor:(UIColor *)badgeFrameColor badgeInsetColor:(UIColor *)badgeInsetColor frameFixed:(BOOL)frameFixed;

@end
