#import "QuizController.h"
#import "QuizEntry.h"

@interface QuizController (Private)
- (void)updateChoicesUi;
- (QuizEntry *)getEntry;
- (int)getEntryType;
- (void)clearChoicesUi;
@end

@implementation QuizController
-(void)updateChoices
{
  NSArray *objects = [self selectedObjects];
  if (objects != nil && [objects count] > 0) {  
    QuizEntry *entry = [objects objectAtIndex:0];
    if (entry != nil) {
      // Store changes before changing view
      if ([entry entryType] == 1) {
        [entry replaceChoiceAtIndex: 0 withChoice: [iChoiceA1 stringValue]];
        [entry replaceChoiceAtIndex: 1 withChoice: [iChoiceB1 stringValue]];
        [entry replaceChoiceAtIndex: 2 withChoice: [iChoiceC1 stringValue]];
        [entry replaceChoiceAtIndex: 3 withChoice: [iChoiceD1 stringValue]];            
      }
      else if ([entry entryType] == 2) {
        // Text fields
        [entry replaceChoiceAtIndex: 0 withChoice: [iChoiceA2 stringValue]];
        [entry replaceChoiceAtIndex: 1 withChoice: [iChoiceB2 stringValue]];
        [entry replaceChoiceAtIndex: 2 withChoice: [iChoiceC2 stringValue]];
        [entry replaceChoiceAtIndex: 3 withChoice: [iChoiceD2 stringValue]]; 
        
        // Check boxes
        [entry setCorrectChoiceAtIndex: 0 to: [[iCorrectChoices cellAtRow:0 column:0] state] == NSOnState];
        [entry setCorrectChoiceAtIndex: 1 to: [[iCorrectChoices cellAtRow:1 column:0] state] == NSOnState];
        [entry setCorrectChoiceAtIndex: 2 to: [[iCorrectChoices cellAtRow:2 column:0] state] == NSOnState];
        [entry setCorrectChoiceAtIndex: 3 to: [[iCorrectChoices cellAtRow:3 column:0] state] == NSOnState];                                           
      }      
    } // entry != nil
  } // objects != nil
}

- (void)updateChoicesUi 
{
  QuizEntry *entry = [self getEntry];
  if (entry == nil) {
    [self clearChoicesUi];
    return;
  }
  int index = [entry entryType];
  [iTabView selectTabViewItemAtIndex: index];
  
  // Update choice text fields
  [iChoiceA1 setStringValue: [entry choiceAtIndex: 0]];
  [iChoiceB1 setStringValue: [entry choiceAtIndex: 1]];
  [iChoiceC1 setStringValue: [entry choiceAtIndex: 2]];
  [iChoiceD1 setStringValue: [entry choiceAtIndex: 3]];            
  
  [iChoiceA2 setStringValue: [entry choiceAtIndex: 0]];
  [iChoiceB2 setStringValue: [entry choiceAtIndex: 1]];
  [iChoiceC2 setStringValue: [entry choiceAtIndex: 2]];
  [iChoiceD2 setStringValue: [entry choiceAtIndex: 3]]; 
    
  [iCorrectChoices setState:[entry correctChoiceAtIndex: 0] atRow:0 column:0];
  [iCorrectChoices setState:[entry correctChoiceAtIndex: 1] atRow:1 column:0];
  [iCorrectChoices setState:[entry correctChoiceAtIndex: 2] atRow:2 column:0];
  [iCorrectChoices setState:[entry correctChoiceAtIndex: 3] atRow:3 column:0];      
}

- (QuizEntry *)getEntry {
  NSArray *objects = [self selectedObjects];
  if (objects == nil || [objects count] < 1)
    return nil;
      
  return [objects objectAtIndex:0];  
}

- (int)getEntryType {
  QuizEntry *entry = [self getEntry];
  if (entry == nil) return -1;
  return  [entry entryType];
}

- (void)clearChoicesUi {
  [iChoiceA1 setStringValue: @""];
  [iChoiceB1 setStringValue: @""];
  [iChoiceC1 setStringValue: @""];
  [iChoiceD1 setStringValue: @""];            
  
  [iChoiceA2 setStringValue: @""];
  [iChoiceB2 setStringValue: @""];
  [iChoiceC2 setStringValue: @""];
  [iChoiceD2 setStringValue: @""]; 
    
  [iCorrectChoices setState: 0 atRow:0 column:0];
  [iCorrectChoices setState: 0 atRow:1 column:0];
  [iCorrectChoices setState: 0 atRow:2 column:0];
  [iCorrectChoices setState: 0 atRow:3 column:0]; 
  [iTabView selectTabViewItemAtIndex: 0];  
}

- (BOOL)setSelectionIndexes:(NSIndexSet *)indexes
{
  [self updateChoices];  
  BOOL isOk = [super setSelectionIndexes:indexes];
  if ([indexes firstIndex] != NSNotFound) {
    [self updateChoicesUi];
  } 
  return isOk;
}

- (void)add:(id)sender {
  [self updateChoices];
  [super add: sender];
  [self updateChoicesUi];
  switch ([self getEntryType]) {
    case 0: [iEssayQuestion selectText:self]; break;
    case 1: [iChoiceQuestion selectText:self]; break;
    case 2: [iMultipleQuestion selectText:self]; break;
    default: break;
  }
}

- (void)remove:(id)sender {
  [self updateChoices];
  [super remove: sender];
  [self updateChoicesUi];
  switch ([self getEntryType]) {
    case 0: [iEssayQuestion selectText:self]; break;
    case 1: [iChoiceQuestion selectText:self]; break;
    case 2: [iMultipleQuestion selectText:self]; break;
    default: break;
  }
}


@end
