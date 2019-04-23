//
//  AuthHandlerType.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 4/10/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import Foundation
import SafariServices
import AuthenticationServices

typealias AuthHandlerCompletion = (URL?, Error?) -> Void

protocol AuthHandlerType: class {
    var session: NSObject? {get set}
    func auth(url: URL, callbackScheme: String, completion: @escaping AuthHandlerCompletion)
}

extension AuthHandlerType {
    func auth(url: URL, callbackScheme: String, completion: @escaping AuthHandlerCompletion){
        if #available(iOS 12, *){
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackScheme){
                url, error in
                completion(url, error)
            }
            session.start()
            self.session = session
        } else {
            let session = SFAuthenticationSession(url: url, callbackURLScheme: callbackScheme){
                url, error in
                completion(url, error)
            }
            session.start()
            self.session = session
        }
    }
}
