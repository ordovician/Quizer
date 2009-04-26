//
//  QuizEntry.h
//  QuizExerciser
//
//  Created by Erik Engheim on Sun Jan 18 2004.
//  Copyright (c) 2004 Translusion. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QuizEntry : NSObject <NSCoding>{
  NSString        *iQuestion;
  NSString        *iAnswer;
  int             iEntryType;
  int             iCorrectChoice;
  NSMutableArray  *iChoices;    // Text for each choice
  NSMutableArray  *iCorrectChoices;
}

/// Accessors
- (NSString *)question;
- (void)setQuestion:(NSString *)aQuestion;
- (NSString *)answer;
- (void)setAnswer:(NSString *)aAnswer;
- (int)entryType;
- (void)setEntryType:(int)aEntryType;
- (int)correctChoice;
- (void)setCorrectChoice:(int)aChoice;
- (unsigned int)countOfChoices;
- (NSString *)choiceAtIndex:(unsigned int)aIndex;
- (BOOL)correctChoiceAtIndex:(unsigned int)aIndex;
- (void)insertChoice:(NSString *)aChoice atIndex:(unsigned int)aIndex;
- (void)replaceChoiceAtIndex:(unsigned int)aIndex withChoice: (NSString *)aChoice;
- (void)setCorrectChoiceAtIndex:(unsigned int)aIndex to:(BOOL)aChoice;
- (void)removeChoiceAtIndex:(unsigned int)aIndex;

/// Request
- (BOOL)isEqual:(QuizEntry *)aQuizEntry;

@end
