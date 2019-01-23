

import UIKit
import MapKit
import Alamofire

class nuevaUbicacionVC: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var change: UIButton!
    @IBOutlet weak var fechaInicio: UIDatePicker!
    @IBOutlet weak var fechaFin: UIDatePicker!
    
    var dateInicio: String?
    var dateFin: String?
    var coordenadas:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descripcion.borderStyle = UITextBorderStyle.roundedRect
        btn.layer.cornerRadius = 15
    }
    
    //Convierte la fecha seleccionada en el datePicker a string y la guarda en una variable externa
    @IBAction func fechaInicio(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: fechaInicio.date)
        self.dateInicio = strDate
    }

    @IBAction func fechaFin(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: fechaFin.date)
        self.dateFin = strDate
    }
    
    @IBAction func change(_ sender: Any) {
        //Dejar escoger de la galeria o de la camara
    }
    
    //Crea un nuevo sitio y envia al usuario a la vista detalle
    @IBAction func create(_ sender: Any) {
        peticionPost()
        performSegue(withIdentifier: "create", sender: sender)
        
    }
    
    //Enviar datos a la api
    func peticionPost(){
        let parameters = ["name" : titulo.text!,
                          "description" : descripcion.text!,
                          "x_coordinate" : coordenadas?.longitude,
                          "y_coordinate" : coordenadas?.latitude,
                          "start_date" : fechaInicio.date,
                          "end_date" : fechaFin.date] as [String : Any]
        
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/location", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .responseJSON { response in
                print(response.result.value)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetalleVC {
            let destination = segue.destination as! DetalleVC
            let nuevo = sender as! nuevaUbicacionVC
            
            destination.Titulo.text = nuevo.titulo.text
            destination.Descripcion.text = nuevo.descripcion.text
            destination.fechaDesde.text = dateInicio
            destination.fechaHasta.text = dateFin
            destination.image.image = nuevo.image.image
        }
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        
            
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum;
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
            self.dismiss(animated: true, completion: { () -> Void in
                
            })
            
            self.image.image = image
        }
    
}
