import Foundation

struct tokens: Decodable{
    let access_token: String?
    let expires_in: Int?
    let refresh_token: String?
    let token_type: String?
    let user_id: String?
    
}

class Model: AuthHandlerType {
    
    var session: NSObject? = nil
    var aCode: String = ""
    var token: tokens? = nil
    var heartData:HeartRate? = nil
    var weeklyHeartData: HeartRate? = nil
    var monthlyHeartData: HeartRate? = nil
    var stepData:Step? = nil
    var weeklyStepData:Step? = nil
    var monthlyStepData:Step? = nil
    var averageMonthlyHeartRate: Int = 0
    
    
    func auth(_ completion: @escaping ((String?, Error?) -> Void)) {
        guard let authUrl = Constants.authUrl else {
            completion(nil, nil)
            
            return
        }
        
        var urlComponents = URLComponents(url: authUrl, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name:"response_type" , value: Constants.responseType),
            URLQueryItem(name:"client_id" , value: Constants.clientID),
            URLQueryItem(name:"redirect_url" , value: Constants.redirectUrl),
            URLQueryItem(name:"scope" , value: Constants.scope.joined(separator: " ")),
            URLQueryItem(name:"expire_in" , value: String(Constants.expire))
        ]
        
        guard let url = urlComponents?.url else {
            completion(nil, nil)
            
            return
        }
        
        auth(url:url, callbackScheme: Constants.redirectScheme){
            url, error in
            if error != nil{
                completion(nil, error)
            } else if let url = url {
                guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                    let item = components.queryItems?.first(where: {$0.name == "code"}),
                    let code = item.value else {
                        completion(nil, nil)
                        return
                }
                self.aCode = code
                completion(code, nil)
            }
        }
        
    }
    
    func getTokens() {
        
        guard let tokenURL = Constants.tokenURl else {
            return
        }
        var endpoint = URLComponents(url: tokenURL, resolvingAgainstBaseURL: false)
        endpoint?.queryItems = [
            URLQueryItem(name:"client_id", value: Constants.clientID),
            URLQueryItem(name:"grant_type", value:"authorization_code"),
            URLQueryItem(name: "code", value: aCode),
            URLQueryItem(name: "redirect_url", value: Constants.redirectUrl)
        ]
        
        guard let endpointURL = endpoint?.url else { return }
        var request = URLRequest(url:endpointURL)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let secret = "ab096c58ecfd6b4d323a2fbacde6c472"
        let authString = String(format: "%@:%@", Constants.clientID,secret)
        let authData = authString.data(using: String.Encoding.utf8)!
        let base64AuthString = authData.base64EncodedString()
        request.addValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, err) in
            guard let data = data.self else {return}
            
            do {
                self.self.token = try JSONDecoder().decode(tokens.self, from: data)
                
            }
                
            catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
        }
        task.resume()
    }
    
    
    func getHeartRate() -> Int? {
        
        guard let apiURL = Constants.apiURL else {
            return 0
        }
        
        let id = token!.user_id!
        var heartComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
        heartComponents!.path = "/1/user/\(id)/activities/heart/date/today/1d.json"
        
        guard let heartURL = heartComponents?.url else { return 0 }
        var request = URLRequest(url: heartURL)
        request.httpMethod = "GET"
        let accToken = token!.access_token!
        request.addValue("Bearer \(accToken)", forHTTPHeaderField: "Authorization")
        let semaphore = DispatchSemaphore(value : 0)
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            guard let data = data.self else { return }
            
            
            do {
                self.heartData = try JSONDecoder().decode(HeartRate.self, from: data)
                semaphore.signal()
            }
                
            catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        return self.heartData?.activitiesHeart[0].value.restingHeartRate
    }
    
    func getStep() -> Int? {
        guard let apiURL = Constants.apiURL else {
            return 0
        }
        
        let id = token!.user_id!
        
        var stepComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
        stepComponents!.path = "/1/user/\(id)/activities/tracker/steps/date/today/1d.json"
        
        guard let stepURL = stepComponents?.url else { return 0 }
        var request = URLRequest(url: stepURL)
        request.httpMethod = "GET"
        let accToken = token!.access_token!
        request.addValue("Bearer \(accToken)", forHTTPHeaderField: "Authorization")
        var actualStep: Int = 0
        let semaphore = DispatchSemaphore(value : 0)
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            guard let data = data.self else { return }
            
            do {
                self.stepData = try JSONDecoder().decode(Step.self, from: data)
                actualStep = Int(self.stepData?.activitiesTrackerSteps[0].value ?? "") ?? 0
                semaphore.signal()
                
            }
                
            catch let jsonErr{
                print("Error serializing daily step json:", jsonErr)
            }
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        return actualStep
    }
    
    func getWeeklyHeartRate() -> Int? {
        guard let apiURL = Constants.apiURL else {
            return 0
        }
        
        let id = token!.user_id!
        let semaphore = DispatchSemaphore(value : 0)
        var heartComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
        heartComponents!.path = "/1/user/\(id)/activities/heart/date/today/1w.json"
        
        guard let heartURL = heartComponents?.url else { return 0 }
        var request = URLRequest(url: heartURL)
        request.httpMethod = "GET"
        let accToken = token!.access_token!
        request.addValue("Bearer \(accToken)", forHTTPHeaderField: "Authorization")
        var averageHeartRate: Int = 0
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            guard let data = data.self else { return }
            
            
            do {
                self.weeklyHeartData = try JSONDecoder().decode(HeartRate.self, from: data)
                for i in 0..<29 {
                    let temp: Int = Int(self.monthlyHeartData?.activitiesHeart[i].value.restingHeartRate ?? 0)
                    averageHeartRate = averageHeartRate + temp
                }
                averageHeartRate = averageHeartRate/7
                semaphore.signal()
            }
                
            catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        return averageHeartRate
    }
    
    
    func getMonthlyHeartRate() -> Int?{
        guard let apiURL = Constants.apiURL else {
            return 0
        }
        
        let id = token!.user_id!
        var heartComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
        heartComponents!.path = "/1/user/\(id)/activities/heart/date/today/1m.json"
        
        guard let heartURL = heartComponents?.url else { return 0 }
        var request = URLRequest(url: heartURL)
        request.httpMethod = "GET"
        var temp2: Int = 0
        let accToken = token!.access_token!
        request.addValue("Bearer \(accToken)", forHTTPHeaderField: "Authorization")
        
        
        let semaphore = DispatchSemaphore(value : 0)
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            guard let data = data.self else { return }
            
            do {
                self.monthlyHeartData = try JSONDecoder().decode(HeartRate.self, from: data)
                for i in 0..<29 {
                    let temp: Int = Int(self.monthlyHeartData?.activitiesHeart[i].value.restingHeartRate ?? 0)
                    temp2 =  temp2 + temp
                }
                self.averageMonthlyHeartRate = temp2/30
                semaphore.signal()
            }
                
            catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
        }
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        return self.averageMonthlyHeartRate
    }
    
    func getWeeklyStep() -> Int? {
        guard let apiURL = Constants.apiURL else {
            return 0
        }
        
        let id = token!.user_id!
        var stepComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
        stepComponents!.path = "/1/user/\(id)/activities/tracker/steps/date/today/1w.json"
        var averageWeeklySteps: Int = 0
        
        guard let stepURL = stepComponents?.url else { return 0 }
        var request = URLRequest(url: stepURL)
        request.httpMethod = "GET"
        let accToken = token!.access_token!
        request.addValue("Bearer \(accToken)", forHTTPHeaderField: "Authorization")
        
        let semaphore = DispatchSemaphore(value : 0)
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            guard let data = data.self else { return }
            
            
            do {
                self.weeklyStepData = try JSONDecoder().decode(Step.self, from: data)
                semaphore.signal()
                
            }
                
            catch let jsonErr{
                print("Error serializing weekly step json:", jsonErr)
            }
        }
        
        task.resume()
        
        for i in 0..<6{
            let temp = Int(self.weeklyStepData?.activitiesTrackerSteps[i].value ?? "error") ?? 0
            averageWeeklySteps = averageWeeklySteps + temp
        }
        averageWeeklySteps = averageWeeklySteps/7
        _ = semaphore.wait(timeout: .distantFuture)
        return averageWeeklySteps
    }
    
    
    func getMonthlyStep() -> Int?{
        guard let apiURL = Constants.apiURL else {
            return 0
        }
        
        let id = token!.user_id!
        
        var stepComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: false)
        stepComponents!.path = "/1/user/\(id)/activities/tracker/steps/date/today/1m.json"
        var averageSteps:Int = 0
        guard let stepURL = stepComponents?.url else { return 0 }
        var request = URLRequest(url: stepURL)
        request.httpMethod = "GET"
        let accToken = token!.access_token!
        request.addValue("Bearer \(accToken)", forHTTPHeaderField: "Authorization")
        
        let semaphore = DispatchSemaphore(value : 0)
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            guard let data = data.self else { return }
            
            do {
                self.monthlyStepData = try JSONDecoder().decode(Step.self, from: data)
                semaphore.signal()
                
            }
                
            catch let jsonErr{
                print("Error serializing monthly step json: ", jsonErr)
            }
        }
        task.resume()
        for i in 0..<29{
            let temp = Int(self.monthlyStepData?.activitiesTrackerSteps[i].value ?? "error") ?? 0
            averageSteps = averageSteps + temp
        }
        averageSteps = averageSteps/30
        _ = semaphore.wait(timeout: .distantFuture)
        return averageSteps
    }
}
