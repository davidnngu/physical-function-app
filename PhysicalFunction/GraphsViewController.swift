import UIKit
import SafariServices

class GraphsViewController: UIViewController {
    
    var model: Model = Model()
    var dailyheart: Int = 0
    var dailystep: Int = 0
    var weeklyheart: Int = 0
    var weeklystep: Int = 0
    var monthlyheart: Int = 0
    var monthlystep: Int = 0
    
    @IBOutlet weak var stepsDaily: UILabel!
    @IBOutlet weak var stepsWeekly: UILabel!
    @IBOutlet weak var stepsMonthly: UILabel!
    @IBOutlet weak var heartDaily: UILabel!
    @IBOutlet weak var heartWeekly: UILabel!
    @IBOutlet weak var heartMonthly: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //automically ask for authorization and get access code and tokens
        self.authDidTap {
            () -> () in
            self.getTokens()
        }
    }
    
    //handle authorization
    private func authDidTap(_ handleComplete:@escaping (()->())) {
        model.auth{ authCode, error in
            if error != nil {
                print("Auth flow finished with error \(String(describing: error))")
            } else {
                print("Succes")
                handleComplete()
            }
        }
    }
    
    //Get access token
    private func getTokens(){
        model.getTokens()
    }
    
    //Get data from FitbitApi
    @IBAction func getData(_ sender: Any) {
        
        self.dailyheart = Int(self.model.getHeartRate() ?? 0)
        self.dailystep = Int(self.model.getStep() ?? 0)
        self.weeklyheart = Int(self.model.getWeeklyHeartRate() ?? 0 )
        self.weeklystep = Int(self.model.getWeeklyStep() ?? 0)
        self.monthlyheart = Int(self.model.getMonthlyHeartRate() ?? 0)
        self.monthlystep = Int(self.model.getMonthlyStep() ?? 0)
        
        
        
        DispatchQueue.main.async{
            self.heartDaily.text = "\(self.dailyheart)"
            self.stepsDaily.text = "\(self.dailystep)"
            self.heartWeekly.text = "\(self.weeklyheart)"
            self.stepsWeekly.text = "\(self.weeklystep)"
            self.heartMonthly.text = "\(self.monthlyheart)"
            self.stepsMonthly.text = "\(self.monthlystep)"
        }
    }
}


    


