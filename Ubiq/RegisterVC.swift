
import UIKit
import Alamofire

class RegisterVC: UIViewController {

    @IBOutlet weak var Registrobtn: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Registrobtn.layer.cornerRadius = 15
    }
    
    @IBAction func registroBtn(_ sender: Any) {
        peticionPost(sender: sender)
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert,animated: true)
    }

    func peticionPost(sender: Any?){
        let parameters = ["name" : name.text!,
                          "email" : email.text!,
                          "password" : password.text!]
        
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/register", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                let statusCode = response.response?.statusCode
                print(statusCode)
                
                if statusCode == 200 {
                    self.performSegue(withIdentifier: "register", sender: sender)
                }
                
                if statusCode == 403 {
                    self.showAlert(title: "Permission denied", message: "You don't have permission")
                }
                
                if statusCode == 400 {
                    self.showAlert(title: "Wrong credentials", message: "This email is already on use.")
                }
                
                if statusCode == 500 {
                    self.showAlert(title: "Error", message: "There's a problem on server")
                }
        }
        
    }
}
