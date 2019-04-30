//
//  StepDataModel.swift
//  Fitbit
//
//  Created by Isabel Zhao on 4/19/19.
//  Copyright © 2019 Isabel Zhao. All rights reserved.
//

import Foundation

import Foundation

struct Step: Codable {
    let activitiesTrackerSteps: [ActivitiesTrackerStep]
    
    enum CodingKeys: String, CodingKey {
        case activitiesTrackerSteps = "activities-tracker-steps"
    }
}

struct ActivitiesTrackerStep: Codable {
    let dateTime, value: String?
}

