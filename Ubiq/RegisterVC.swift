
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
        //Guardar datos del formulario en BBDD con peticion POST
        
    }
}
