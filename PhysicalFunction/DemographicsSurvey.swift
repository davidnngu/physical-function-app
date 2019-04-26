//
//  DemographicsSurvey.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 4/16/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit

public var DemographicsSurvey: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    //Introduction
    let instructionStep = ORKInstructionStep(identifier: "DemographicIntroStep")
    instructionStep.title = "Demographic Survey"
    instructionStep.text = "Answer seven questions to complete the survey."
    steps += [instructionStep]
    
    //Name Question
    let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 30)
    nameAnswerFormat.multipleLines = false
    let nameQuestionStepTitle = "What is your name?"
    let nameQuestionStep = ORKQuestionStep(identifier: "NameStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
    nameQuestionStep.isOptional = false
    steps += [nameQuestionStep]
    
    //Gender Question
    var textChoice: [ORKTextChoice]
    textChoice = [
        ORKTextChoice(text: "Male", value: "Male" as NSString),
        ORKTextChoice(text: "Female", value: "Female" as NSString)
    ]
    let questAnswerFormat:
        ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoice)
    let questQuestionStep = ORKQuestionStep(identifier: "GenderStep", title: "What is your gender?", answer: questAnswerFormat)
    questQuestionStep.isOptional = false
    steps += [questQuestionStep]
    
    //Age Question
    let ageQuestion = "What is your age?"
    let ageAnswer = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: "years")
    ageAnswer.minimum = 18
    ageAnswer.maximum = 100
    let ageQuestionStep = ORKQuestionStep(identifier: "AgeStep", title: ageQuestion, answer: ageAnswer)
    ageQuestionStep.isOptional = false
    steps += [ageQuestionStep]
    
    //Diagnosis Question
    let textAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
    nameAnswerFormat.multipleLines = false
    let textQuestionStepTitle = "What is your cancer diagnosis?"
    let textQuestionStep = ORKQuestionStep(identifier: "CancerStep", title: textQuestionStepTitle, answer: textAnswerFormat)
    textQuestionStep.isOptional = false
    steps += [textQuestionStep]
    
    //Date Question
    let formatter = DateFormatter()
    formatter.dateFormat = "mm/dd/yyyy"
    let minDate = formatter.date(from: "01/01/1980")
    let maxDate = Date()
    let defaultDate = formatter.date(from: "04/16/2019")
    
    let dateQuestion = "What is the date of your diagnosis?"
    let dateAnswer = ORKDateAnswerFormat.dateAnswerFormat(withDefaultDate: defaultDate, minimumDate: minDate, maximumDate: maxDate, calendar: Calendar.current)
    let dateQuestionStep = ORKQuestionStep(identifier: "DateStep", title: dateQuestion, answer: dateAnswer)
    dateQuestionStep.isOptional = false
    steps += [dateQuestionStep]
    
    //Race Question
    textChoice = [
        ORKTextChoice(text: "White", value: "White" as NSString),
        ORKTextChoice(text: "Black or African American", value: "Black" as NSString),
        ORKTextChoice(text: "Asian", value: "Asian" as NSString),
        ORKTextChoice(text: "Native American or Alaska Native", value: "Native American" as NSString),
        ORKTextChoice(text: "Native Hawaiian or Pacific Islander", value: "Native Hawaiian" as NSString),
        ORKTextChoice(text: "More than one race", value: "Multiple" as NSString),
        ORKTextChoice(text: "Prefer not to answer", value: "No answer" as NSString)
    ]
    
    let raceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoice)
    let raceQuestionStep = ORKQuestionStep(identifier: "RaceStep", title: "What is your race?", answer: raceAnswerFormat)
    raceQuestionStep.isOptional = false
    steps += [raceQuestionStep]
    
    //Education Question
    textChoice = [
        ORKTextChoice(text: "1-12 years but did not graduate", value: "1-12" as NSString),
        ORKTextChoice(text: "Completed High School/GED", value: "High School" as NSString),
        ORKTextChoice(text: "Some College", value: "Some College" as NSString),
        ORKTextChoice(text: "College Graduate", value: "College Graduate" as NSString),
        ORKTextChoice(text: "Post-Graduate (e.g. Masters, Doctorate", value: "Post-Graduate" as NSString)
    ]
    let eduAnswerFormat:
        ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoice)
    let eduQuestionStep = ORKQuestionStep(identifier: "eduStep", title: "What is the highest grade or level of schooling that you have completed?", answer: eduAnswerFormat)
    eduQuestionStep.isOptional = false
    steps += [eduQuestionStep]
    
    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "DemographicSummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the survey"
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
