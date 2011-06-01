#import <UIKit/UIKit.h>
#import "ActionMenu.h"
#import <SpringBoard/SpringBoard.h>

#define PREFERENCE_PATH @"/var/mobile/Library/Preferences/jp.r-plus.amCustom.plist"
/*
@interface CustomSheetHandler : NSObject <UIActionSheetDelegate>
{
	NSString *selection;
}
@property (nonatomic,copy) NSString *selection;

@end

@implementation CustomSheetHandler

@synthesize selection;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	actionSheet.delegate = nil;
	[self autorelease];
}

@end
*/


@implementation UIView (CustomActionMenuPlugin)

- (void)showCustomSheet:(id)sender
{
	NSDictionary *prefsDict = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
	NSString *scheme = [prefsDict objectForKey:@"AMCustomScheme"] ?: @"x-web-search:///?@s";
	NSArray *array = [scheme componentsSeparatedByString:@"@"];
	
	NSMutableString *string = [[NSMutableString alloc] init];
	NSString *selection = [self selectedTextualRepresentation];
	selection = [selection stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
	
	NSArray *URLTypes;
	NSDictionary *URLType;
	NSString *returnScheme = nil;
	
	if ((URLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"])) {
		if ((URLType = [URLTypes lastObject])) {
			returnScheme = [[URLType objectForKey:@"CFBundleURLSchemes"] lastObject];
		}
	}
	
	BOOL isFirstAppend = YES;
	
	for ( NSString *add in array ){
	
		if (isFirstAppend) {
			[string appendString:add];
			isFirstAppend = NO;
			continue;
		}
		
		switch ([add characterAtIndex:0]) {
			case 's': //selected text
				[string appendString:selection];
				[string appendString:[add substringFromIndex:1]];
				break;
				
			case 'r': //e.g. com.atebits.Tweetie2+3.0.0
				if ( returnScheme != nil ) {
					[string appendString:returnScheme];
					[string appendString:@":"];
				}
				[string appendString:[add substringFromIndex:1]];
				break;
				
			case 'i': //e.g. com.atebits.Tweetie2
				[string appendString:identifier];
				[string appendString:[add substringFromIndex:1]];
				break;
			/*
			case 'b': //e.g. Twitter
				[string appendString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
				[string appendString:[add substringFromIndex:1]];
				break;
			*/
			default: //other
				[string appendString:add];
				break;
		}
	}
	
	[identifier isEqualToString:@"com.apple.springboard"] ?
	  [[UIApplication sharedApplication] applicationOpenURL:[NSURL URLWithString:string]]
	: [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
	
	[string release];

	/*
	CustomSheetHandler *delegate = [[CustomSheetHandler alloc] init];
	delegate.selection = [self selectedTextualRepresentation];
	//NSDictionary *prefsDict = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
	//delegate.prefsDict = prefsDict;
	
	UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:nil
																				 delegate:delegate
																cancelButtonTitle:nil
													 destructiveButtonTitle:nil
																otherButtonTitles:nil]
						 autorelease];
	
	[sheet setAlertSheetStyle:2];
	[sheet setContext:@"amCustomSheet"];
	[sheet addButtonWithTitle:@"Safari"];
	[sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"Cancel"]];
	
	int i = [sheet numberOfButtons];
	if (i > 5) {
		//[sheet setUseTwoColumnsButtonsLayout:YES];
		//[sheet setTwoColumnsLayoutMode:2];
	}
	[sheet showInView:self];
	*/
}

- (BOOL)canShowCustomSheet:(id)sender
{
	return ( [[self textualRepresentation] length] > 0 && [self respondsToSelector:@selector(selectAll)] ) ? YES : NO;
}

+ (void)load
{
	static BOOL isPad;
	
	NSString* model = [[UIDevice currentDevice] model];
	isPad = [model isEqualToString:@"iPad"];
	
	id<AMMenuItem> customSheetMenu = [[UIMenuController sharedMenuController] registerAction:@selector(showCustomSheet:) title:@"Custom" canPerform:@selector(canShowCustomSheet:)];
		
	if (!isPad && [[UIScreen mainScreen] scale] == 2.0 ) {
		customSheetMenu.image = [[UIImage alloc] initWithContentsOfFile:@"/Library/ActionMenu/Plugins/Custom@2x.png"];
	} else {
		customSheetMenu.image = [[UIImage alloc] initWithContentsOfFile:@"/Library/ActionMenu/Plugins/Custom.png"];
	}
}

@end

// vim:ft=objc
