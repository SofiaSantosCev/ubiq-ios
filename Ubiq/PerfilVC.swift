

import UIKit
import Alamofire

class PerfilVC: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Email: UILabel!
    
    var user_id = UserDefaults.standard.string(forKey: "user_id")
    var token = UserDefaults.standard.string(forKey: "token") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peticionGet()
    }
    
    //Peticion GET para recibir los usuarios registrados
    func peticionGet(){
        let headers: HTTPHeaders = [
            "Authorization":token
        ]
        
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/user", method: .get, headers: headers)
            .responseJSON { response in
                let responseJSON = response.result.value as! [String: Any]
                let data = responseJSON["users"] as! [[String:Any]]
                
                for x in data {
                    self.Name.text = x["name"] as? String
                    self.Email.text = x["email"] as? String
                }
        }
    }

    //Boton eliminar usuario. Se elimina el usuario y se manda a la pantalla de registro
    @IBAction func BorrarBtn( sender: Any) {
        peticionDelete(sender: sender)
    }

    //Se cierra sesión y se abre la pantalla login
    @IBAction func LogOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func peticionDelete(sender: Any){
        let headers: HTTPHeaders = [
            "Authorization":token
        ]
        
        Alamofire.request("http://ubiq/public/index.php/api/user/"+user_id!, method: .delete, headers: headers).responseJSON {
            response in
            
            if response.response?.statusCode == 200 {
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "register") as! RegisterVC
                self.present(newViewController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "An error ocurred", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again later", style: .cancel, handler: nil))
                self.present(alert,animated: true)
            }
        }
    }
}
