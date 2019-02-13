

import UIKit
import Alamofire

class PerfilVC: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var user_id = UserDefaults.standard.string(forKey: "user_id")
    var token = UserDefaults.standard.string(forKey: "token")
    
    //Configura la vista del boton
    override func viewDidLoad() {
        super.viewDidLoad()
        peticionGet()
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
      
    }
    
    //Peticion GET para recibir los usuarios registrados
    func peticionGet(){
        
        let headers: HTTPHeaders = [
            "Authorization": UserDefaults.standard.string(forKey: "token")! as! String
        ]
        
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/user/"+user_id!, method: .get, headers: headers)
            .responseJSON { response in
                let responseJSON = response.result.value as! [String: Any]
                let data = responseJSON["user"] as! [String:Any]
            
                self.Name.text = data["name"] as? String
                self.Email.text = data["email"] as? String
                
        }
    }


    //Se cierra sesión y se abre la pantalla login
    @IBAction func LogOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
}
