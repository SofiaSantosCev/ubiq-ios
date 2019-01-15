
import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var linkRegistro: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 15
        email.layer.cornerRadius = 15
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        //Comprobar datos del formulario con BBDD con peticion GET
    }

}
