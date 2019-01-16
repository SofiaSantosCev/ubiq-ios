
import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 15
        email.layer.cornerRadius = 15
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        //peticionPost()
    }

    func peticionPost(){
        let url = URL(string: "")
        var postRequest = URLRequest(url: url!)
        postRequest.httpMethod = "POST"
        
        let parameters = ["email" : email.text,
                          "password" : password.text]
        
        do {
            postRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .sortedKeys)
        } catch {
            print("Error al pasar el JSON")
        }
        
        postRequest.addValue("appliction/json", forHTTPHeaderField: "Content-type")
        postRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            if error == nil {
                print("Estas logueado")
            } else {
                print(error ?? "Error")
            }
            
            }.resume()
        
    }
}
