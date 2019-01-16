
import UIKit

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
        peticionPost()
        
    }
    
    func peticionPost(){
        let urlRegister = URL(string: "localhost:8888/ubiq/public/index.php/register")
        var postRequest = URLRequest(url: urlRegister!)
        postRequest.httpMethod = "POST"
        
        let parameters = ["name" : name.text,
                          "email" : email.text,
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
                print("Usuario creado")
            } else {
                print(error ?? "Error")
            }
            
        }.resume()
        
    }
    
}
