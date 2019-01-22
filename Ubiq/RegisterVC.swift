
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
    
    func peticionPost(sender: Any?){
        let parameters = ["name" : name.text!,
                          "email" : email.text!,
                          "password" : password.text!]
        
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/register", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                print(response.result.value)
                
                if response.response?.statusCode == 200 {
                    self.performSegue(withIdentifier: "register", sender: sender)
                } else {
                    let alert = UIAlertController(title: "Permission denied", message: "You dont have permission", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert,animated: true)
                }
        }
        
    }
}
