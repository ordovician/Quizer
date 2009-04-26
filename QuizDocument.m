//
//  QuizDocument.m
//  Quizer
//
//  Created by Erik Engheim on Fri Jun 11 2004.
//  Copyright (c) 2004 Translusion. All rights reserved.
//

#import "QuizDocument.h"
#import "QuizEntry.h"

static NSString* 	QuizDocToolbarIdentifier 		          = @"Quiz Document Toolbar Identifier";
static NSString*	AddDocToolbarItemIdentifier 	        = @"Add Document Item Identifier";
static NSString*	RemoveDocToolbarItemIdentifier 	      = @"Remove Document Item Identifier";
static NSString*	InsertDocToolbarItemIdentifier 	      = @"Insert Document Item Identifier";
static NSString*	ExcerciseDocToolbarItemIdentifier 	  = @"Excercise Document Item Identifier";
static NSString*	QuestionTypeDocToolbarItemIdentifier 	= @"Question Type Document Item Identifier";

@interface QuizDocument (Private)
- (void)setupToolbar;
- (void)updateExcerciseUi;
@end


@implementation QuizDocument

- (id)init
{
    self = [super init];
    if (self) {
      iEntries = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
  [iQuestionType release];
  iQuestionType = nil;  
  [iEntries release];
  iEntries = nil;
  

  [super dealloc];
}


- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"QuizDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    iExcerciseMode = NO; 
    iQuestionIndex = 0;
    iCorrect       = 0;
    iWrong         = 0;
    
    // Make sure pop up button isn't deleted when not in toolbar
    [iQuestionType retain];
    [iQuestionType removeFromSuperview];

    // Set up the toolbar after the document nib has been loaded 
    [self setupToolbar];
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
  // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
  return [NSArchiver archivedDataWithRootObject:[self entries]];
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
  // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
  [self setEntries: [NSUnarchiver unarchiveObjectWithData:data]];
  [self updateChangeCount: NSChangeCleared];
  return YES;
}

// ============================================================
// Accessors
// ============================================================
- (void) setEntries: (NSMutableArray *)aEntries {
  [iEntries autorelease];
  iEntries = [aEntries retain];
}

- (NSMutableArray *)entries {
  return iEntries;
}


// ============================================================
// Operations
// ============================================================
- (IBAction)controlTextDidChange:(NSNotification *)aNotification {
  [self updateChangeCount: NSChangeDone];
}

/// Called when selection is made in radio group or checkbox group
- (IBAction)selectCorrectAnswer:(id)sender {
  [self updateChangeCount: NSChangeDone];
  [iEntriesController updateChoices];
  [iEntriesController rearrangeObjects];  
}

- (IBAction)add:(id)sender {
  [self updateChangeCount: NSChangeDone];
  [iEntriesController add: sender];
}

- (IBAction)remove:(id)sender {
  [self updateChangeCount: NSChangeDone];
  [iEntriesController remove: sender];  
}

- (IBAction)insert:(id)sender {
  [self updateChangeCount: NSChangeDone];
  [iEntriesController insert: sender];  
}

- (IBAction)excercise:(id)sender {
  iExcerciseMode = !iExcerciseMode;
  if (iExcerciseMode) {
    [iMainTabView selectLastTabViewItem:nil];
    [iQuestionType setEnabled: NO]; 
    [self updateExcerciseUi]; 
    [iTotalField setIntValue: [iEntries count]];
  }
  else {
    [iMainTabView selectFirstTabViewItem:nil]; 
    [iQuestionType setEnabled: YES];     
  }
}

- (IBAction)start:(id)sender {
  iQuestionIndex = 0;
  iCorrect       = 0;
  iWrong         = 0;  
  [self updateExcerciseUi];
  [iAnswerField setStringValue: @""];
  [iAnswerField selectText:self];        
}

- (IBAction)next:(id)sender {
  if (++iQuestionIndex >= [iEntries count])
    iQuestionIndex = 0;
  [self updateExcerciseUi];  
  [iAnswerField setStringValue: @""];  
  [iAnswerField selectText:self];    
}

- (IBAction)randomize:(id)sender {

}

- (IBAction)answer:(id)sender {
  QuizEntry *entry = [iEntries objectAtIndex:iQuestionIndex];
  NSString *answer = [[iEntries objectAtIndex: iQuestionIndex] answer];
  switch ([entry entryType]) {
  case 0: { 
    if ([answer caseInsensitiveCompare: [iAnswerField stringValue]] == NSOrderedSame) {
      ++iCorrect;
    }
    else {
      ++iWrong;
    }
    break;
  }
  case 1:
    if ([iAnswerChoices selectedRow] == [entry correctChoice]) {
      ++iCorrect;
    }
    else {
      ++iWrong;
    }
    break;
  case 2: {
      int noChoices = [entry countOfChoices];
      int i;
      for (i=0; i<noChoices; ++i) {
        if ([entry correctChoiceAtIndex: i] != 
            ([[iAnswerOptions cellAtRow:i column:0] state] == NSOnState)) {
          ++iWrong;
          goto exitLoop;
        }
      } 
      ++iCorrect;
exitLoop:      
      break;
    }
  }
  [self updateExcerciseUi];    
  [iRightAnswerField setStringValue: answer];  
  [iAnswerField setEnabled: NO];
  [iAnswerChoices setEnabled: NO];  
  [iAnswerOptions setEnabled: NO];    
  [iAnswerButton setEnabled: NO]; 
}

- (void)updateExcerciseUi {
  NSAssert(iQuestionIndex < [iEntries count], @"Question Index out of bounds");
  [iRightAnswerField setStringValue: @""];
  
  QuizEntry *entry = [iEntries objectAtIndex:iQuestionIndex];
  NSString *question = [entry question];
  [iEssayQuestionField setStringValue: question];
  [iChoiceQuestionField setStringValue: question];
  [iMultipleQuestionField setStringValue: question];    
  
  
  [iCorrectField setIntValue: iCorrect];  
  [iWrongField setIntValue: iWrong];  
  [iCorrectField setIntValue: iCorrect];    
  float percent = iCorrect+iWrong; if (percent != 0) percent = 100.0*iCorrect/percent;
  [iPercentField setFloatValue: percent];  
  
 // Update choice text fields
  [iChoiceA1 setStringValue: [entry choiceAtIndex: 0]];
  [iChoiceB1 setStringValue: [entry choiceAtIndex: 1]];
  [iChoiceC1 setStringValue: [entry choiceAtIndex: 2]];
  [iChoiceD1 setStringValue: [entry choiceAtIndex: 3]];            
  
  [iChoiceA2 setStringValue: [entry choiceAtIndex: 0]];
  [iChoiceB2 setStringValue: [entry choiceAtIndex: 1]];
  [iChoiceC2 setStringValue: [entry choiceAtIndex: 2]];
  [iChoiceD2 setStringValue: [entry choiceAtIndex: 3]]; 
  
  // Set correct question type type and enable buttons and fields
  int entryType =  [entry entryType];
  [iQuestionTypeTab selectTabViewItemAtIndex: entryType];
  [iAnswerField setEnabled: YES];
  [iAnswerChoices setEnabled: YES];  
  [iAnswerOptions setEnabled: YES];    
  [iAnswerButton setEnabled: YES];  
}

// ============================================================
// NSToolbar Related Methods
// ============================================================

- (void) setupToolbar {
    NSToolbar *toolbar = [[[NSToolbar alloc] initWithIdentifier: QuizDocToolbarIdentifier] autorelease];
    
    [toolbar setAllowsUserCustomization: YES];
    [toolbar setAutosavesConfiguration: YES];
    [toolbar setDisplayMode: NSToolbarDisplayModeIconAndLabel];
    
    [toolbar setDelegate: self];
    
    [iWindow setToolbar: toolbar];
}

- (NSToolbarItem *) toolbar: (NSToolbar *)toolbar itemForItemIdentifier: (NSString *) itemIdent willBeInsertedIntoToolbar:(BOOL) willBeInserted {
  NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];

  if ([itemIdent isEqual: AddDocToolbarItemIdentifier]) {
    [toolbarItem setLabel: @"Add"];
    [toolbarItem setPaletteLabel: @"Add"];
    
    [toolbarItem setToolTip: @"Add question to quiz"];
    [toolbarItem setImage: [NSImage imageNamed: @"AddEntryItemImage"]];
    
    [toolbarItem setTarget: self];
    [toolbarItem setAction: @selector(add:)];
  } 
  else if ([itemIdent isEqual: RemoveDocToolbarItemIdentifier]) {
    [toolbarItem setLabel: @"Remove"];
    [toolbarItem setPaletteLabel: @"Remove"];
    
    [toolbarItem setToolTip: @"Remove question to quiz"];
    [toolbarItem setImage: [NSImage imageNamed: @"RemoveEntryItemImage"]];
    
    [toolbarItem setTarget: self];
    [toolbarItem setAction: @selector(remove:)];
  }   
  else if ([itemIdent isEqual: InsertDocToolbarItemIdentifier]) {
    [toolbarItem setLabel: @"Insert"];
    [toolbarItem setPaletteLabel: @"Insert"];
    
    [toolbarItem setToolTip: @"Insert question to quiz"];
    [toolbarItem setImage: [NSImage imageNamed: @"InsertEntryItemImage"]];
    
    [toolbarItem setTarget: self];
    [toolbarItem setAction: @selector(insert:)];
  }     
  else if ([itemIdent isEqual: ExcerciseDocToolbarItemIdentifier]) {
    [toolbarItem setLabel: @"Exercise"];
    [toolbarItem setPaletteLabel: @"Exercise"];
    
    [toolbarItem setToolTip: @"Practice questions"];
    [toolbarItem setImage: [NSImage imageNamed: @"ExcerciseItemImage"]];
    
    [toolbarItem setTarget: self];
    [toolbarItem setAction: @selector(excercise:)];
  }  
  else if([itemIdent isEqual: QuestionTypeDocToolbarItemIdentifier]) {    
    // Set up the standard properties 
    [toolbarItem setLabel: @"Question type"];
    [toolbarItem setPaletteLabel: @"Question type"];
    [toolbarItem setToolTip: @"Select the type of question"];
    
    // Set max and min size for custome toolbutton
    [toolbarItem setView: iQuestionType];
    [toolbarItem setMinSize:NSMakeSize(30, NSHeight([iQuestionType frame]))];
    [toolbarItem setMaxSize:NSMakeSize(200,NSHeight([iQuestionType frame]))];
  }       
  else {
    toolbarItem = nil;
  }
  return toolbarItem;
}

- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *) toolbar {
    return [NSArray arrayWithObjects:	AddDocToolbarItemIdentifier, RemoveDocToolbarItemIdentifier, 
            ExcerciseDocToolbarItemIdentifier, NSToolbarSeparatorItemIdentifier, NSToolbarSpaceItemIdentifier,
            QuestionTypeDocToolbarItemIdentifier, nil];
}

- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *) toolbar {
    return [NSArray arrayWithObjects:	AddDocToolbarItemIdentifier, RemoveDocToolbarItemIdentifier, 
            InsertDocToolbarItemIdentifier, ExcerciseDocToolbarItemIdentifier, 
            NSToolbarSeparatorItemIdentifier, NSToolbarSpaceItemIdentifier,
            QuestionTypeDocToolbarItemIdentifier, nil];
}

- (void) toolbarWillAddItem: (NSNotification *) notif {
}  

- (void) toolbarDidRemoveItem: (NSNotification *) notif {
}

- (BOOL) validateToolbarItem: (NSToolbarItem *) toolbarItem {
  BOOL enable;
  if (iExcerciseMode) {
    enable = [[toolbarItem itemIdentifier] isEqual: ExcerciseDocToolbarItemIdentifier];
  }
  else {
    enable = YES;
    if ([[toolbarItem itemIdentifier] isEqual: RemoveDocToolbarItemIdentifier]) {
      enable = [iEntriesController selectionIndex] != NSNotFound;
    }
    else if ([[toolbarItem itemIdentifier] isEqual: ExcerciseDocToolbarItemIdentifier]) {
      enable = [iEntries count] > 0;
    }  
  }
  return enable;
}

@end
