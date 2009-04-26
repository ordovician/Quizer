/* QuizController */

#import <Cocoa/Cocoa.h>

@interface QuizController : NSArrayController
{
    IBOutlet NSTabView    *iTabView;
    IBOutlet NSTextField  *iEssayQuestion;    
    IBOutlet NSTextField  *iChoiceQuestion;        
    IBOutlet NSTextField  *iMultipleQuestion;        
    IBOutlet NSTextField  *iChoiceA1;
    IBOutlet NSTextField  *iChoiceB1;
    IBOutlet NSTextField  *iChoiceC1;
    IBOutlet NSTextField  *iChoiceD1;            
    IBOutlet NSTextField  *iChoiceA2;
    IBOutlet NSTextField  *iChoiceB2;
    IBOutlet NSTextField  *iChoiceC2;
    IBOutlet NSTextField  *iChoiceD2;    
    
    IBOutlet NSMatrix     *iCorrectChoices;
}
- (void)updateChoices;
@end
