

import UIKit
import MapKit

class nuevaUbicacionVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var change: UIButton!
    @IBOutlet weak var fechaInicio: UIDatePicker!
    @IBOutlet weak var fechaFin: UIDatePicker!
    
    var dateInicio: String?
    var dateFin: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descripcion.borderStyle = UITextBorderStyle.roundedRect
        btn.layer.cornerRadius = 15
        
        var imagen: UIImage
        var coor_x: CLLocationCoordinate2D
        var coor_y: CLLocationCoordinate2D
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "TriggerTouchAction:")
        mapa.addGestureRecognizer(gestureRecognizer)
    }
    
    //Convierte la fecha seleccionada en el datePicker a string y la guarda en una variable externa
    @IBAction func fechaInicio(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: fechaInicio.date)
        self.dateInicio = strDate
    }

    @IBAction func fechaFin(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: fechaFin.date)
        self.dateFin = strDate
    }
    
    @IBAction func change(_ sender: Any) {
        //Dejar escoger de la galeria o de la camara
    }
    
    //Crea un nuevo sitio y envia al usuario a la vista detalle
    @IBAction func create(_ sender: Any) {
        performSegue(withIdentifier: "create", sender: sender)
        
        peticionPost()
        
    }
    
    func peticionPost(){
        let url = URL(string: "")
        var postRequest = URLRequest(url: url!)
        postRequest.httpMethod = "POST"
        
        let parameters = ["titulo" : titulo.text,
                          "descripcion" : descripcion.text]
        
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
   
}
