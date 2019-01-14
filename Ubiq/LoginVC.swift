
import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var linkRegistro: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 15
        email.layer.cornerRadius = 15
    }
    
    @IBAction func email(_ sender: Any) {
    
    }
    
    @IBAction func password(_ sender: Any) {
    
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
    }
}
