
import UIKit
import Alamofire

class LoginVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    var isLoggedIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 15
        email.layer.cornerRadius = 15
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        peticionPost(sender: sender)
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert,animated: true)
    }

    func peticionPost(sender: Any){
        let parameters = ["email" : email.text!,
                          "password" : password.text!]
        
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/login", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                let token = response.result.value! as! [String : Any]
                let statusCode = response.response?.statusCode
                
                if statusCode == 200 {
                    self.performSegue(withIdentifier: "login", sender: sender)
                }
                
                if statusCode == 403 {
                    self.showAlert(title: "Permission denied", message: "You don't have permission")
                }
                
                if statusCode == 400 {
                    self.showAlert(title: "Wrong credentials", message: "Your email or password are incorrect")
                }
                
                UserDefaults.standard.set(token["token"], forKey: "token")
                UserDefaults.standard.set(token["user_id"], forKey: "user_id")
        }
        
    }
}
