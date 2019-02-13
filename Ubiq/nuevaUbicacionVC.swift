

import UIKit
import MapKit
import Alamofire

class nuevaUbicacionVC: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var fechaInicio: UIDatePicker!
    @IBOutlet weak var fechaFin: UIDatePicker!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    
    var longitude: Double = 0.0
    var latitude:Double = 0.0
    var dateInicio: String?
    var dateFin: String?
    var sitio: Sitio?
    var id: Int?
        
    //Configura la vista del boton
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = borderColor.cgColor
        textView.layer.cornerRadius = 5.0
        btn.layer.cornerRadius = 15
        setMapview()
    }
    
    //Convierte la fecha seleccionada en el datePicker a string y la guarda en una variable externa
    func DatetoString(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateInicio = dateFormatter.string(from: fechaInicio.date)
        self.dateFin = dateFormatter.string(from: fechaFin.date)
    }
    
    //Crea un nuevo sitio y envia al usuario a la vista detalle
    @IBAction func create(_ sender: Any) {
        DatetoString()
        peticionPost()
    }
    
    //Crear nueva localizacion
    func peticionPost(){
        let headers: HTTPHeaders = [
            "Authorization":UserDefaults.standard.object(forKey: "token")! as! String
        ]
        
        let parameters: Parameters = ["name" : titulo.text!,
                                      "description" : textView.text!,
                                      "x_coordinate" : longitude,
                                      "y_coordinate" : latitude,
                                      "start_date" : dateInicio!,
                                      "end_date" : dateFin!]
        
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/location", method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers:headers)
            .responseJSON { response in
                let responseJson = response.result.value! as! [String : Any]
                self.id = responseJson["data"] as? Int
                if response.response?.statusCode == 200 {
                    let alert = UIAlertController(title: "Location created", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                    self.present(alert,animated: true)
                } else {
                    let alert = UIAlertController(title: "Error", message: "something went wrong", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                    self.present(alert,animated: true)
                }
        }
    }
    
    //Configura y el longpressgesturerecognizer en el map
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        map.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            let touchLocation = gestureReconizer.location(in: map)
            let locationCoordinate = map.convert(touchLocation,toCoordinateFrom: map)
            longitude = locationCoordinate.longitude
            latitude = locationCoordinate.latitude
            longitudeField.text = String(longitude)
            latitudeField.text = String(latitude)
            
            marcar(longitude: longitude, latitude: latitude)
        }
    }
    
    //Añade un pin con los parametros introducidos
    func marcar(longitude: Double, latitude: Double){
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let localizacion = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let region = MKCoordinateRegion(center: localizacion, span: span)
        map.setRegion(region, animated: true)
        
        //marcador
        let anotacion = MKPointAnnotation()
        anotacion.coordinate.latitude = latitude
        anotacion.coordinate.longitude = longitude
        map.addAnnotation(anotacion)
        
    }
    
}
