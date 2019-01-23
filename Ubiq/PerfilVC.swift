

import UIKit
import Alamofire

class PerfilVC: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Email: UILabel!
    
    var user_id = UserDefaults.standard.string(forKey: "user_id")
    var deleted:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
    }
    
    func getInfo(){
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/user", method: .get)
            .responseJSON { response in
                print("response.result.value= ", response.result.value)
                /*let responseJSON = response.result.value as! [String: Any]
                let data = responseJSON["users"] as! [[String:Any]]
                
                
                for x in data {
                    self.Name.text = x["name"] as! String
                    self.Email.text = x["email"] as! String
                }*/
        }
    }

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

    @IBAction func LogOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        performSegue(withIdentifier: "logOut", sender: sender)
    }
    
    
    
    
}
