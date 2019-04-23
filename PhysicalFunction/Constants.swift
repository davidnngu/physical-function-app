//
//  Constants.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 4/10/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import Foundation

struct Constants{
    static let authUrl = URL(string: "https://www.fitbit.com/oauth2/authorize")
    static let responseType = "code"
    static let clientID = "22DKLD"
    static let redirectScheme = "PhysicalFunction://"
    static let redirectUrl = "\(redirectScheme)fitbit/auth"
    static let scope = ["activity", "heartrate", "profile", "settings", "weight" ]
    static let expire = "604800"
    static let tokenURl = URL(string: "https://api.fitbit.com/oauth2/token")
    static let apiURL = URL(string: "https://api.fitbit.com/")
    private init(){}
    
}
