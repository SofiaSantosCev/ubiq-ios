

import UIKit
import Alamofire

class PerfilVC: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Email: UILabel!
    
    var user_id = UserDefaults.standard.string(forKey: "user_id")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
    }
    
    //Peticion GET para recibir los usuarios registrados
    func getInfo(){
        let headers: HTTPHeaders = [
            "Authorization":UserDefaults.standard.object(forKey: "token") as! String
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
    @IBAction func BorrarBtn(_ sender: Any) {
        Alamofire.request("http://ubiq/public/index.php/api/user/"+user_id!, method: .delete).responseJSON {
            response in
            
            if response.response?.statusCode == 200 {
                //performSegue(withIdentifier: "deleteAccount", sender: self.sender)
            } else {
                print("error")
            }
        }
    }

    //Se cierra sesión y se abre la pantalla login
    @IBAction func LogOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        performSegue(withIdentifier: "logOut", sender: sender)
    }
    
    
    
    
}
