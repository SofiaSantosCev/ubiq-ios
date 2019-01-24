

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
    @IBAction func fechaInicio(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let strDate = dateFormatter.string(from: fechaInicio.date)
        self.dateInicio = strDate
    }

    @IBAction func fechaFin(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let strDate = dateFormatter.string(from: fechaFin.date)
        self.dateFin = strDate
    }
    
    //Crea un nuevo sitio y envia al usuario a la vista detalle
    @IBAction func create(_ sender: Any) {
        peticionPost(sender: sender)
        performSegue(withIdentifier: "create", sender: sender)
    }
    
    //Enviar datos a la api
    func peticionPost(sender: Any){
        let headers: HTTPHeaders = [
            "Authorization":UserDefaults.standard.object(forKey: "token") as! String
        ]
        
        let parameters = ["name" : titulo.text!,
                          "description" : textView.text!,
                          "x_coordinate" : longitude,
                          "y_coordinate" : latitude,
                          "start_date" : fechaInicio.date,
                          "end_date" : fechaFin.date] as [String : Any]
        
        Alamofire.request("http://localhost:8888/ubiq/public/index.php/api/location", method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers:headers)
            .responseJSON { response in
                print("status code= ",response.response?.statusCode)
                print(response.result.value)
                
                if response.response?.statusCode == 200 {
                    self.performSegue(withIdentifier: "create", sender: sender)
                } else {
                    let alert = UIAlertController(title: "Permission denied", message: "You dont have permission", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert,animated: true)
                }
        }
    }
    
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapaCrearSpot.handleLongPress(gestureReconizer:)))
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
            marcar(longitude: longitude, latitude: latitude)
            longitudeField.text = String(longitude)
            latitudeField.text = String(latitude)
        }
    }
    
    func marcar(longitude: Double, latitude: Double){
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let localizacion = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        print("longitude = ", localizacion.longitude, "latitude = ", localizacion.latitude)
        let region = MKCoordinateRegion(center: localizacion, span: span)
        map.setRegion(region, animated: true)
        
        //marcador
        let anotacion = MKPointAnnotation()
        anotacion.coordinate.latitude = latitude
        anotacion.coordinate.longitude = longitude
        map.addAnnotation(anotacion)
    }
    
    //Enviar datos a la pantalla detalle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetalleVC {
            let destination = segue.destination as! DetalleVC
            let new = sender as! nuevaUbicacionVC
            
            destination.Titulo.text = new.titulo.text
            destination.Descripcion.text = new.textView.text
            destination.fechaDesde.text = new.dateInicio
            destination.fechaHasta.text = new.dateFin
            destination.latitude = new.latitude
            destination.longitude = new.longitude
        }
    }
    
}
