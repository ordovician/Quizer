//
//  QuizEntry.m
//  QuizExerciser
//
//  Created by Erik Engheim on Sun Jan 18 2004.
//  Copyright (c) 2004 Translusion. All rights reserved.
//

#import "QuizEntry.h"

static int lastEntryType = 0; // Make sure new entries are of same type as previous one.

@implementation QuizEntry
- (id)init {
  [super init];
  [self setQuestion: @""];
  [self setAnswer: @""];
  iChoices = [[NSMutableArray alloc] initWithObjects: @"", @"", @"", @"", nil];
  iCorrectChoices = [[NSMutableArray alloc] initWithObjects: 
                      [NSNumber numberWithBool:NO], 
                      [NSNumber numberWithBool:NO],
                      [NSNumber numberWithBool:NO], 
                      [NSNumber numberWithBool:NO], 
                      nil];
                      
  iEntryType = lastEntryType;  
  iCorrectChoice = 0;
  
  return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
  [self setQuestion: [aCoder decodeObject]];
  [self setAnswer: [aCoder decodeObject]]; 
  iChoices = [[aCoder decodeObject] retain];
  iCorrectChoices = [[aCoder decodeObject] retain];  
  [aCoder decodeValueOfObjCType: @encode(int) at: &iEntryType];    
  [aCoder decodeValueOfObjCType: @encode(int) at: &iCorrectChoice];  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject: [self question]];
  [aCoder encodeObject: [self answer]];  
  [aCoder encodeObject: iChoices];    
  [aCoder encodeObject: iCorrectChoices];  
  [aCoder encodeValueOfObjCType: @encode(int) at: &iEntryType];    
  [aCoder encodeValueOfObjCType: @encode(int) at: &iCorrectChoice];      
}

- (void)dealloc {
  [iQuestion release];
  [iAnswer release];
  [iChoices release];
  [iCorrectChoices release];
  [super dealloc];
}

// ============================================================
// Access
// ============================================================
- (NSString *)question {
  return iQuestion;
}

- (void)setQuestion:(NSString *)aQuestion {
  [iQuestion autorelease];
  iQuestion = [aQuestion copy];
}

- (NSString *)answer  {
  if (iEntryType == 1)
    return [iChoices objectAtIndex: iCorrectChoice];
  else if (iEntryType == 2) {
    NSMutableString *s = [NSMutableString stringWithCapacity: 20];
    BOOL sep = NO;
    int i;
    for (i=0; i<[iChoices count]; ++i) {
      if ([[iCorrectChoices objectAtIndex: i] boolValue]) {
        if (sep) [s appendString: @", "]; 
        sep = YES;      
        [s appendString: [iChoices objectAtIndex: i]];
      }
    }
    return s;
  }
  else
    return iAnswer;
}

- (void)setAnswer:(NSString *)aAnswer {
  if (iEntryType == 1)
    [iChoices replaceObjectAtIndex: iCorrectChoice withObject: aAnswer];
  else {
    [iAnswer autorelease];
    iAnswer = [aAnswer copy];
  }
}

- (int)entryType {
  return iEntryType;
}

- (void)setEntryType:(int)aEntryType {
  iEntryType = aEntryType;
  lastEntryType = iEntryType;
}

- (int)correctChoice {
  return iCorrectChoice;
}

- (void)setCorrectChoice:(int)aChoice {
  iCorrectChoice = aChoice;
}

- (unsigned int)countOfChoices {
  return [iChoices count];
}


- (NSString *)choiceAtIndex:(unsigned int)aIndex {
     return [iChoices objectAtIndex: aIndex];
}

- (BOOL)correctChoiceAtIndex:(unsigned int)aIndex {
     return [[iCorrectChoices objectAtIndex: aIndex] boolValue];
}


- (void)insertChoice:(NSString *)aChoice atIndex:(unsigned int)aIndex {
  [iChoices insertObject: aChoice atIndex: aIndex];
  [iCorrectChoices insertObject: [NSNumber numberWithBool:NO] atIndex: aIndex];  
}

- (void)replaceChoiceAtIndex:(unsigned int)aIndex withChoice: (NSString *)aChoice {
  [iChoices replaceObjectAtIndex: aIndex withObject: aChoice]; 
}

- (void)setCorrectChoiceAtIndex:(unsigned int)aIndex to: (BOOL)aChoice {
  [iCorrectChoices replaceObjectAtIndex: aIndex withObject: [NSNumber numberWithBool:aChoice]]; 
}

- (void)removeChoiceAtIndex:(unsigned int)aIndex {
  [iChoices removeObjectAtIndex: aIndex];
  [iCorrectChoices removeObjectAtIndex: aIndex];  
}

// ============================================================
// Request
// ============================================================
- (BOOL)isEqual:(QuizEntry *)aQuizEntry {
  if ([[self question] isEqualToString: [aQuizEntry question]] &&
      [[self answer  ] isEqualToString: [aQuizEntry answer  ]])
    return YES;
  else
    return NO;
}
@end
