//
//  TestSurvey.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 4/12/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit
import Firebase

class TestViewController: UIViewController, ORKTaskViewControllerDelegate {

    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    
    var taskResultFinishedCompletionHandler: ((ORKResult) -> Void)?
    var tempString = String()
    let userID = Auth.auth().currentUser?.uid
    let email = Auth.auth().currentUser?.email

    override func viewDidLoad() {
        super.viewDidLoad()
        button0.applyDesign()
        button1.applyDesign()
        button2.applyDesign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func PromisClicked(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: PromisSurvey, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }

    @IBAction func SymptomClicked(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: SymptomSurvey, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func DemoClicked(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: DemographicsSurvey, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        let results = taskViewController.result
        
        var surveyResults = getSurveyResults(survey: results)
        if (surveyResults.isPROMIS == true) {
            surveyResults.calcResultScore()
        }
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    /*
     Function to get the survey results when a survey is completed.
     Calls the corresponding parsing method.
     Also sends the data to the Firestore database.
     In: ORKTaskResult
     Out: surveyResults struct with result data.
     */
    func getSurveyResults(survey: ORKTaskResult) -> surveyResults {
        let results = survey.results
        var savedResults = surveyResults(result: survey)
        for stepResult in results! as! [ORKStepResult]
        {
            if (stepResult.identifier == "PROMISIntroStep") {
                savedResults = parsePFSurvey(survey: survey)
            } else if (stepResult.identifier == "SymptomIntroStep"){
                savedResults = parseSymptomSurvey(survey: survey)
            } else if (stepResult.identifier == "DemographicIntroStep") {
                savedResults = parseDemoSurvey(survey: survey)
            }
        }
        savedResults.sendToFirebase()
        return savedResults
    }
    
    /*
     Function to parse the PROMIS PF10 survey and return the results.
     In: ORKTaskResult
     Out: surveyResults struct with result data
     */
    func parsePFSurvey(survey: ORKTaskResult) -> surveyResults {
        let results = survey.results
        var savedResults = surveyResults(result: survey)
        for stepResult in results! as! [ORKStepResult]
        {
            if (stepResult.identifier == "PROMISSummaryStep") {
                savedResults.calcResultScore()
                savedResults.isPROMIS = true
                savedResults.isDemo = false
                savedResults.isSymptoms = false
            }
            else if (stepResult.identifier != "PROMISIntroStep") {
                for result in stepResult.results! {
                    let RKResult = result as! ORKChoiceQuestionResult
                    let arrResult = (RKResult.answer! as! NSArray).mutableCopy() as! NSMutableArray
                    savedResults.resultsList.append(arrResult[0] as! NSNumber)
                }
            }
        }
        return savedResults
    }
    
    /*
     Function to parse the Symptoms survey and return the results.
     Also sends the data to the Firestore database.
     In: ORKTaskResult
     Out: surveyResults struct with result data
     */
    func parseSymptomSurvey(survey: ORKTaskResult) -> surveyResults {
        let results = survey.results
        var savedResults = surveyResults(result: survey)
        for stepResult in results! as! [ORKStepResult]
        {
            if (stepResult.identifier == "SymptomSummaryStep") {
                savedResults.isSymptoms = true
                savedResults.isPROMIS = false
                savedResults.isDemo = false
            }
            else if (stepResult.identifier != "SymptomIntroStep") {
                for result in stepResult.results! {
                    let RKResult = result as! ORKChoiceQuestionResult
                    let arrResult = (RKResult.answer! as! NSArray).mutableCopy() as! NSMutableArray
                    savedResults.resultsList.append(arrResult[0] as! NSNumber)
                }
            }
        }
        return savedResults
    }
    
    /*
     Function to parse the Demographics survey and return the results.
     Also sends the data to the Firestore database.
     In: ORKTaskResult
     Out: surveyResults struct with result data
     */
    func parseDemoSurvey(survey: ORKTaskResult) -> surveyResults {
        let results = survey.results
        var savedResults = surveyResults(result: survey)
        for stepResult in results! as! [ORKStepResult]
        {
            if (stepResult.identifier == "DemographicSummaryStep") {
                savedResults.isDemo = true
                savedResults.isPROMIS = false
                savedResults.isSymptoms = false
                savedResults.sendToFirebase()
            }
            else if (stepResult.identifier != "DemographicIntroStep") {
                
                for result in stepResult.results! {
                    let id = result.identifier
                    var RKResult: ORKQuestionResult?
                    
                    if (id == "GenderStep" || id == "RaceStep" || id == "EduQuestionStep") {
                        RKResult = result as! ORKChoiceQuestionResult
                        let arrResult = (RKResult!.answer! as! NSArray).mutableCopy() as! NSMutableArray
                        savedResults.resultsList.append(arrResult[0] as! NSString)
                    } else if (id == "NameStep" || id == "DiagnosisStep"){
                        RKResult = result as! ORKTextQuestionResult
                        let arrResult = RKResult!.answer
                        savedResults.resultsList.append(arrResult as! NSString)
                    } else if (id == "AgeStep") {
                        RKResult = result as! ORKNumericQuestionResult
                        let arrResult = RKResult!.answer
                        savedResults.resultsList.append(arrResult as! NSNumber)
                    } else if (id == "DateStep"){
                        RKResult = result as! ORKDateQuestionResult
                        let arrResult = RKResult!.answer
                        savedResults.resultsList.append(arrResult as! NSDate)
                    }
                }
            }
        }
        return savedResults
    }
}

/*
 Struct to hold survey result data.
 Contains methods for calculating the raw score, T-score, and sending the data to the Firestore database.
 */
public struct surveyResults {
    
    var resultsList = [NSObject]()
    var allResults: ORKTaskResult
    var resultTotal = 0
    var resultAvg = 0
    var resultScore = 0.0
    var isPROMIS = false
    var isSymptoms = false
    var isDemo = false
    let userID = Auth.auth().currentUser?.uid
    let email = Auth.auth().currentUser?.email
    let date = Date()
    
    init(result: ORKTaskResult) {
        allResults = result
    }
    
    /*
     Function to calculate the total raw score.
     Should only be called in calcResultScore()
     */
    mutating func calcResultTotal() {
        resultTotal = 0
        for result in resultsList {
            resultTotal += (result as! Int)
        }
    }
    
    /*
     Function to calculate the t-score. Calls convertRawToTScore().
     Should only be called in ParsePFSurvey()
     */
    mutating func calcResultScore() {
        calcResultTotal()
        resultScore = convertRawtoTScore(score: resultTotal)
    }
    
    /*
     Function to send survey results to Google FireStore database
     For PROMIS/Symptom survey: Creates new document with timestamp for each time survey is taken
     For Demographics survey: Creates new document if one does not exist, or updates existing document
     */
    mutating func sendToFirebase() {
        let docref = Firestore.firestore().document("users/\(email ?? "0")")
        
        if (isPROMIS == true) {
            let newref = docref.collection("PROMIS PF10").document("\(date)")
            let dataToSave = ["PROMIS PF10": resultsList, "PFScore": resultScore] as [String: Any]
            newref.setData(dataToSave)
            docref.updateData(["PFScore": resultScore] as [String: Any])
        } else if (isSymptoms == true) {
            let newref = docref.collection("Symptoms").document("\(date)")
            let dataToSave = ["Symptoms": resultsList] as [String: Any]
            newref.setData(dataToSave)
        } else {
            let dataToSave = ["Demographics": resultsList] as [String: Any]
            docref.updateData(dataToSave)
        }
    }
    
    
    /*
     Function to convert raw score from PROMIS Survey.
     Should only be called in ParsePFSurvey()
     In: Raw PROMIS survey score (Int)
     Out: Converted T-score (Double)
     */
    func convertRawtoTScore(score: Int) -> Double {
        var tScore: Double = 0
        switch score {
        case 10:
            tScore = 13.5
        case 11:
            tScore = 16.6
        case 12:
            tScore = 18.3
        case 13:
            tScore = 19.7
        case 14:
            tScore = 20.9
        case 15:
            tScore = 22.1
        case 16:
            tScore = 23.1
        case 17:
            tScore = 24.1
        case 18:
            tScore = 25
        case 19:
            tScore = 26
        case 20:
            tScore = 26.9
        case 21:
            tScore = 27.7
        case 22:
            tScore = 28.6
        case 23:
            tScore = 29.4
        case 24:
            tScore = 30.2
        case 25:
            tScore = 31
        case 26:
            tScore = 31.8
        case 27:
            tScore = 32.5
        case 28:
            tScore = 33.3
        case 29:
            tScore = 34
        case 30:
            tScore = 34.8
        case 31:
            tScore = 35.5
        case 32:
            tScore = 36.3
        case 33:
            tScore = 37
        case 34:
            tScore = 37.8
        case 35:
            tScore = 38.5
        case 36:
            tScore = 39.3
        case 37:
            tScore = 40.1
        case 38:
            tScore = 40.9
        case 39:
            tScore = 41.7
        case 40:
            tScore = 42.6
        case 41:
            tScore = 43.5
        case 42:
            tScore = 44.4
        case 43:
            tScore = 45.5
        case 44:
            tScore = 46.6
        case 45:
            tScore = 47.9
        case 46:
            tScore = 49.4
        case 47:
            tScore = 51.2
        case 48:
            tScore = 53.4
        case 49:
            tScore = 55.8
        case 50:
            tScore = 61.9
        default:
            tScore = 0
        }
        return tScore
    }
    
}


