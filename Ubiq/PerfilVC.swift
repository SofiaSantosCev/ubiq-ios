

import UIKit

class PerfilVC: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Asignar información del token a los label y la imagen.
    }

  
    @IBAction func BorrarBtn(_ sender: Any) {
        performSegue(withIdentifier: "BorrarCuenta", sender: sender)
    }
    
    
    @IBAction func LogOut(_ sender: Any) {
        performSegue(withIdentifier: "LogOut", sender: sender)
    }
    
}
