import UIKit
import ResearchKit

public var PromisSurvey: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    //Introduction
    let instructionStep = ORKInstructionStep(identifier: "PROMISIntroStep")
    instructionStep.title = "PROMIS PF10 Survey"
    instructionStep.text = "Answer ten questions to complete the survey."
    steps += [instructionStep]
    
    
    var questionNumber = 1;
    
    let questionSet = ["Does your health now limit you in doing vigorous activities, such as running, lifting heavy objects, participating in strenuous sports?", "Does your health now limit you in walking more than a mile? (1.6 km)", "Does your health now limit you in climbing one flight of stairs?", "Does your health now limit you in lifting or carrying groceries? ", "Does you health now limit you in bending, kneeling or stooping", "Are you able to do chores such as vacuuming or yard work?", "Are you able to dress yourself including tying shoelaces and buttoning your clothes?", "Are you able to shampoo your hair?", "Are you able to wash and dry your body?", "Are you able to sit on and get up from the toilet?"]
    
    for question in questionSet {
        let textChoiceQuestion = question
        var textChoice : [ORKTextChoice]
        
        if (questionNumber <= 5) {
            textChoice = [
                ORKTextChoice(text: "Not at all", value: 5 as NSNumber),
                ORKTextChoice(text: "Very Little", value: 4 as NSNumber),
                ORKTextChoice(text: "Somewhat", value: 3 as NSNumber),
                ORKTextChoice(text: "Quite a lot", value: 2 as NSNumber),
                ORKTextChoice(text: "Cannot do", value: 1 as NSNumber)
            ]
        } else {
            textChoice = [
                ORKTextChoice(text: "Without any difficulty", value: 5 as NSNumber),
                ORKTextChoice(text: "With a little difficulty", value: 4 as NSNumber),
                ORKTextChoice(text: "With some difficulty", value: 3 as NSNumber),
                ORKTextChoice(text: "With much difficulty", value: 2 as NSNumber),
                ORKTextChoice(text: "Cannot do", value: 1 as NSNumber)
            ]
        }
        let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoice)
        let questQuestionStep = ORKQuestionStep(identifier: "QuestionStep\(questionNumber)", title: textChoiceQuestion, answer: questAnswerFormat)
        questQuestionStep.isOptional = false
        steps += [questQuestionStep]
        questionNumber+=1
        }
    
    //Summary
    let completionStep = ORKCompletionStep(identifier: "PROMISSummaryStep")
    completionStep.title = "Thank You!!"
    completionStep.text = "You have completed the survey"
    steps += [completionStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
