

import UIKit
import Alamofire

class PerfilVC: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var user_id = UserDefaults.standard.string(forKey: "user_id")
    //var token = UserDefaults.standard.string(forKey: "token")
    var deleted:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Asignar información del token a los label y la imagen.
        getAllUsers()
        
    }

    @IBAction func BorrarBtn(_ sender: Any) {
        if deleted {
            performSegue(withIdentifier: "deleteAccount", sender: sender)
        }
    }
    
    func delete(){
        Alamofire.request("http://ubiq/public/index.php/api/user/"+user_id!, method: .delete)
        return deleted = true
    }

    @IBAction func LogOut(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "token")
        performSegue(withIdentifier: "LogOut", sender: sender)
    }
    
    func getAllUsers(){
        Alamofire.request("http://ubiq/public/index.php/api/user", method: .get)
            .responseJSON { response in
               print(response)
        }
    }
    
    
}
