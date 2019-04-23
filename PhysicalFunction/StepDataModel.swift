//
//  StepDataModel.swift
//  Fitbit
//
//  Created by Isabel Zhao on 4/19/19.
//  Copyright © 2019 Isabel Zhao. All rights reserved.
//

import Foundation

struct Step: Codable {
    let activities: [Activity]?
    let goals: Goals?
    let summary: Summary
}

struct Activity: Codable {
    let activityID, activityParentID, calories: Int
    let description: String
    let distance: Double
    let duration: Int
    let hasStartTime, isFavorite: Bool
    let logID: Int
    let name, startTime: String
    let steps: Int
    
    enum CodingKeys: String, CodingKey {
        case activityID = "activityId"
        case activityParentID = "activityParentId"
        case calories, description, distance, duration, hasStartTime, isFavorite
        case logID = "logId"
        case name, startTime, steps
    }
}

struct Goals: Codable {
    let caloriesOut: Int
    let distance: Double
    let floors, steps: Int
}

struct Summary: Codable {
    let activityCalories, caloriesBMR, caloriesOut: Int
    let distances: [Distance]
    let elevation: Double
    let fairlyActiveMinutes, floors, lightlyActiveMinutes, marginalCalories: Int
    let sedentaryMinutes, steps, veryActiveMinutes: Int
}

struct Distance: Codable {
    let activity: String
    let distance: Double
}
