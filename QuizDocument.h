//
//  QuizDocument.h
//  Quizer
//
//  Created by Erik Engheim on Fri Jun 11 2004.
//  Copyright (c) 2004 Translusion. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "QuizController.h"

@interface QuizDocument : NSDocument
{
  IBOutlet NSWindow           *iWindow;
  IBOutlet QuizController     *iEntriesController;  
  IBOutlet NSPopUpButton      *iQuestionType;	
  IBOutlet NSTabView          *iMainTabView;	  
  NSMutableArray              *iEntries;
  BOOL                         iExcerciseMode;
  
  // Excersise variables
  IBOutlet NSTabView          *iQuestionTypeTab;	    
  IBOutlet NSTextField        *iCorrectField;	    
  IBOutlet NSTextField        *iWrongField;	    
  IBOutlet NSTextField        *iPercentField;	
  IBOutlet NSTextField        *iTotalField;	            
  IBOutlet NSTextField        *iRightAnswerField;	        
  IBOutlet NSTextField        *iAnswerField;	        
  IBOutlet NSTextField        *iEssayQuestionField;	        
  IBOutlet NSTextField        *iChoiceQuestionField;	          
  IBOutlet NSTextField        *iMultipleQuestionField;	            

  IBOutlet NSTextField        *iChoiceA1;
  IBOutlet NSTextField        *iChoiceB1;
  IBOutlet NSTextField        *iChoiceC1;
  IBOutlet NSTextField        *iChoiceD1;            
  IBOutlet NSTextField        *iChoiceA2;
  IBOutlet NSTextField        *iChoiceB2;
  IBOutlet NSTextField        *iChoiceC2;
  IBOutlet NSTextField        *iChoiceD2;
  
  IBOutlet NSMatrix           *iAnswerChoices;  
  IBOutlet NSMatrix           *iAnswerOptions;    

  IBOutlet NSButton           *iAnswerButton;	              
  unsigned int                iQuestionIndex;
  unsigned int                iCorrect;
  unsigned int                iWrong;
}
/// Accessors
- (void) setEntries: (NSMutableArray *)aEntries;
- (NSMutableArray *)entries;

/// Operations
- (IBAction)controlTextDidChange:(NSNotification *)aNotification;
- (IBAction)selectCorrectAnswer:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)insert:(id)sender;
- (IBAction)excercise:(id)sender;
- (IBAction)start:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)randomize:(id)sender;
- (IBAction)answer:(id)sender;
@end
