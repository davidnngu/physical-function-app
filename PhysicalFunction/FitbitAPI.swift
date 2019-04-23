//
//  FitbitAPI.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 4/10/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import Foundation
import UIKit

class FitbitAPI {
    
    static let sharedInstance: FitbitAPI = FitbitAPI()
    static let baseAPIURL = URL(string:"https://api.fitbit.com/1")
    
    func authorize(with token: String) {
        let sessionConfiguration = URLSessionConfiguration.default
        var headers = sessionConfiguration.httpAdditionalHeaders ?? [:]
        headers["Authorization"] = "Bearer \(token)"
        sessionConfiguration.httpAdditionalHeaders = headers
        session = URLSession(configuration: sessionConfiguration)
    }
    
    var session: URLSession?
}
