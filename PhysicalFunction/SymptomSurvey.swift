//
//  SymptomSurvey.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 4/16/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit

public var SymptomSurvey: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    //Introduction
    let instructionStep = ORKInstructionStep(identifier: "SymptomIntroStep")
    instructionStep.title = "Symptom Severity Survey"
    instructionStep.text = "Answer nine questions to complete the survey."
    steps += [instructionStep]
    
    
    var questionNumber = 1;
    
    let questionSet = ["In the last 7 days, what was the SEVERITY of your DECREASED APPETITE at its WORST?", "In the last 7 days, what was the SEVERITY of your ANXIETY at its WORST?", "In the last 7 days, what was the SEVERITY of your CONSTIPATION and its WORST?", "In the last 7 days, what was the SEVERITY of your SAD OR UNHAPPY FEELINGS at its WORST?", "In the last 7 days, what was the SEVERITY of your FATIGUE, TIREDNESS OR LACK OF ENERGY at its WORST?", "In the last 7 days, what was the SEVERITY of your INSOMINA (INCLUDING DIFFICULTY FALLING ASLEEP, STAYING ASLEEP OR WAKING UP EARLY) at its WORST?", "In the last 7 days, what was the SEVERITY of your NAUSEA OR VOMITING at its WORST?", "In the last 7 days, what was the SEVERITY of your PAIN?", "In the last 7 days, what was the SEVERITY of your SHORTNESS OF BREATH at its WORST?"]
    
    for question in questionSet {
        let textChoiceQuestion = question
        var textChoice : [ORKTextChoice]
        textChoice = [
            ORKTextChoice(text: "None", value: 0 as NSNumber),
            ORKTextChoice(text: "Mild", value: 1 as NSNumber),
            ORKTextChoice(text: "Moderate", value: 2 as NSNumber),
            ORKTextChoice(text: "Severe", value: 3 as NSNumber),
            ORKTextChoice(text: "Very Severe", value: 4 as NSNumber)
        ]
        let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoice)
        let questQuestionStep = ORKQuestionStep(identifier: "QuestionStep\(questionNumber)", title: textChoiceQuestion, answer: questAnswerFormat)
        questQuestionStep.isOptional = false
        steps += [questQuestionStep]
        questionNumber+=1
    }
    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "SymptomSummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the survey"
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
